//
//  nntp_account.m
//  iNG
//
//  Created by Will Dietz on 3/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "nntp_account.h"
#import "resolveHostname.h"

#import <arpa/inet.h>
#import <fcntl.h>

//comment this out to hide the nslog'ing of network read/writes
//#define DEBUG_NETWORK_ACTIVITY 1

//NOTE these *must* match the keys as defined in
//Root.plist in Settings.bundle
//preferences
#define K_SERVER @"SERVER"
#define K_PORT @"PORT"
#define K_USER @"USER"
#define K_PASSWORD @"PASSWORD"
#define K_MAX_ART_CACHE @"MAXARTCACHE"
#define K_SUBSCRIBED @"SUBSCRIBED"
//group cache
#define K_GROUPS @"ACTIVE_GROUPS"


//these go in the Settings.bundle now
//#define DEFAULT_SERVER @"news.yourservergoeshere.com"
//#define DEFAULT_PORT 119
//#define DEFAULT_USER @""
//#define DEFAULT_PASSWORD @""
//#define DEFAULT_MAX_ART_CACHE 100

#define CONNECT_TIMEOUT 10
#define COMMAND_TIMEOUT 10

#define GROUPS_FILE   \
        [[NSBundle mainBundle] pathForResource:@"groups" ofType:@""]


static nntp_account * sharedInstance = nil;

@implementation nntp_account

+ (nntp_account * ) sharedInstance
{
	if ( sharedInstance )
		return sharedInstance;
	//else
	return sharedInstance = [ [ nntp_account alloc ] init ];
}

//init constructor
- (nntp_account *) init
{
	self = [ super init ];

	_sockd = 0;
	_arts = nil;
	_groups = nil;
	_subscribed = nil;
	_canPost = false;

	return self;
}


/*-----------------------------------------------------------------------------
 *  Accessors
 *-----------------------------------------------------------------------------*/
- (NSString *) getUser
{
	return [ [ NSUserDefaults standardUserDefaults ] stringForKey: K_USER ];
}
- (NSString *) getPassword
{
	return [ [ NSUserDefaults standardUserDefaults ] stringForKey: K_PASSWORD ];
}
- (NSString *) getServer
{
	return [ [ NSUserDefaults standardUserDefaults ] stringForKey: K_SERVER ];
}
- (int) getPort
{
	return  [ [ NSUserDefaults standardUserDefaults ] integerForKey: K_PORT ];
}
- (bool) isConnected;
{
	return _sockd != 0;
}
- (bool) canPost
{
	return _canPost;
}

- (void) setUser: (NSString *) user
{
	[ [ NSUserDefaults standardUserDefaults ] setObject: user forKey: K_USER ];
}

- (void) setPassword: (NSString *) password
{
	[ [ NSUserDefaults standardUserDefaults ] setObject: password forKey: K_PASSWORD ];
}

- (void) setServer: (NSString *) server
{
	[ [ NSUserDefaults standardUserDefaults ] setObject: server forKey: K_SERVER ];
}

- (void) setPort: (int) port
{
	[ [ NSUserDefaults standardUserDefaults ] setInteger: port forKey: K_PORT ];
}


- (bool) isValid
{//returns if we 'reasonably' think the data is valid.
	//check if set, not the (invalid) default and not empty
	return (
		[ self getServer ] &&
		[ [ self getServer ] compare: @"news.example.com" ] &&
		[ [ self getServer ] compare: @"" ] );
}


/*-----------------------------------------------------------------------------
 *  NNTP methods
 *-----------------------------------------------------------------------------*/

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  connect
 *  Description:  attempt to connect.  returns true iff successful
 * =====================================================================================
 */
- (bool) connect
{
	struct sockaddr_in s_add;
	fd_set fdset; 
	struct timeval tv;
	int arg, res, optval;
	unsigned int optlen = sizeof( int );

	
	NSString * nsip = resolveHostname( [ [ self getServer ] UTF8String ] );
	if ( nsip == nil )
	{
		//couldn't resolve!
		NSLog( @"Bad server or resolution failure!" );
		return NO;

	}
	const char * serverip = [ nsip UTF8String ];

	if ( ( _sockd = socket( PF_INET, SOCK_STREAM, 0 ) ) < 0 )
	{
		_sockd = 0;
		return NO;
	}

	//make it non-blocking
	if ( ( arg = fcntl( _sockd, F_GETFL, NULL ) ) < 0 )
	{
		close( _sockd );
		_sockd = 0;
		return NO;
	}

	arg |= O_NONBLOCK; 
	
	if( fcntl( _sockd, F_SETFL, arg ) < 0 )
	{
		close( _sockd );
		_sockd = 0;
		return NO;
	} 

	memset( &s_add, 0, sizeof( struct sockaddr_in ) );
	s_add.sin_family = AF_INET;
	s_add.sin_port = htons( [ self getPort ] );
	s_add.sin_addr.s_addr = inet_addr( serverip );//must be an IP!

	res = connect( _sockd, (struct sockaddr *)&s_add, sizeof( struct sockaddr_in) );
	if ( res < 0 )
	{
		if ( errno == EINPROGRESS )
		{//it's non-blocking like we told it (not) to....
			tv.tv_sec = CONNECT_TIMEOUT;
			tv.tv_usec = 0;
			FD_ZERO( &fdset );
			FD_SET( _sockd, &fdset );
			res = select( _sockd + 1, NULL, &fdset, NULL, &tv );//wait until connect finishes or timeout

			if ( res < 0 && errno != EINTR )
			{
				close( _sockd );
				_sockd = 0;
				return NO;//error connecting
			}
			else if ( res == 0 )
			{
				close( _sockd );
				_sockd = 0;
				return NO;//timeout :(
			}
			//res > 0

			//make sure things went smoothly...

			if ( getsockopt( _sockd, SOL_SOCKET, SO_ERROR, (void*)(&optval), &optlen ) < 0 ) 
			{
				close( _sockd );
				_sockd = 0;
				return NO;//error in getsockopt, treat as connect error
			}

			if ( optval )
			{
				//connect didn't go so well
				close( _sockd );
				_sockd = 0;
				return NO;
			}
		}
		else
		{
			//not the errorcode we expected..so error
			close( _sockd );
			_sockd = 0;
			return NO;
		}
	}

	//back to blocking since that's what we want
	if ( ( arg = fcntl( _sockd, F_GETFL, NULL ) ) < 0 )
	{
		close( _sockd );
		_sockd = 0;
		return NO;
	}

	arg &= ~O_NONBLOCK;//make it blocking again..

	if ( fcntl( _sockd, F_SETFL, arg ) < 0 )
	{
		close( _sockd );
		_sockd = 0;
		return NO;
	}

	return [ self getLine ] != nil;

}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  getLine
 *  Description:  reads a line from the network stream
 * =====================================================================================
 */
- (NSString *) getLine
{
	NSMutableString * ret = nil;
	char buffer[160];
	//TODO: non-blocking, and TIMEOUT.

	NSUInteger newline_index = -1;
	int res = recv( _sockd, buffer, sizeof( buffer ) - 1, MSG_PEEK );
	if ( res != -1 )
	{
		buffer[res]='\0';
		ret = [ NSMutableString stringWithCString: buffer ];
	}
	else
	{
		return nil;
	}

	if ( ( newline_index = [ ret rangeOfString: @"\n" ].location ) != NSNotFound )
	{
		NSString * line = [ ret substringToIndex: newline_index ];
		//actually read it.. but only up to the newline
		read( _sockd, buffer, newline_index + 1 );
#ifdef DEBUG_NETWORK_ACTIVITY		
		NSLog( @"recv'd: %d, %@", newline_index, line );
#endif //DEBUG_NETWORK_ACTIVITY
		return line;
	}

	return nil;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  isSuccessfulCommand
 *  Description:  returns true iff the string starts with a '2'.  Used to determine if a server is happy
 * =====================================================================================
 */
- (bool) isSuccessfulCommand: (NSString *) response
{
	return [ response characterAtIndex: 0 ] == '2';
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  interpretModeReaderResponse
 *  Description:  sets _canPost depending on the response we get via mode reader 
 * =====================================================================================
 */
- (void) interpretModeReaderResponse: (NSString *) response
{
	_canPost = [ response hasPrefix: @"201" ]; //201 means we can post;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  sendCommand
 *  Description:  sends a command to the nntp server, returns if send has an error (local)
 * =====================================================================================
 */
- (bool) sendCommand: (NSString *) command withArg: (NSString *) arg
{
	//TODO: switch to non-blocking network IO
	//and make use of COMMAND_TIMEOUT... like in the
	//connect code
	NSString * fullcmd = [ NSString stringWithFormat: @"%@ %@\n", command, arg ];
#ifdef DEBUG_NETWORK_ACTIVITY
	NSLog( @"Sending command: %@", fullcmd );
#endif //DEBUG_NETWORK_ACTIVITY

	int len = [ fullcmd length ];
	int res = send( _sockd, [ fullcmd UTF8String ], len, 0 );
	if ( res == -1 || res != len )//yes latter implies former, but just being clear
	{//if error or didn't send all
		return false;
	}
	return true;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  getResponse
 *  Description:  gets the rest of the response
 * =====================================================================================
 */
- (NSArray *) getResponse
{
	//TODO: not sure what to do if this is called and there's no response...
	//for now only call it when appropriate :)
	//in the future a timeout will handle that I suppose
	NSMutableArray * response = [ [ NSMutableArray alloc ] init ];

	bool done = false;
	while ( !done )
	{
		NSString * line = [ self getLine ];
		done = ( [ line characterAtIndex: 0 ] == '.' );//keep going until see '.' by itself
		
		if ( !done )
		{
			[ response addObject: line ];
		}
	}

	return response;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  authenticate
 *  Description:  Attempts to authenticate, if necessary (if username is valid, or forceAuth is true).
 *                returns true iff successful
 * =====================================================================================
 */
- (bool) authenticate: (bool) forceAuth
{
	NSString * response;
	NSLog( @"User: %@, Pass: %@", [ self getUser ], [ self getPassword ] );
	if ( forceAuth || [ [ self getUser ] compare: @"" ] )
	{
		//here we send 1x or 2x, and then get the responses

		[self sendCommand: @"AUTHINFO USER" withArg: [ self getUser ] ];
		//TODO: actually check for the 381 req'd the password
		if ( [ [ self getPassword ] compare: @"" ] )
		{//if password exists...
			[ self sendCommand: @"AUTHINFO PASS" withArg: [ self getPassword ] ];
			response = [ self getLine ];
		}
		response = [self getLine ];

		if ( ![ self isSuccessfulCommand: response ] )
		{//we need a 200 response
			//handle response error here

			//281--success
			//381--more info needed (pass usually, see above)
			//480--auth needed (?)
			//482--auth rejected
			//502--no permission

			//now we get to try other methods..
			//
			//Skipping AUTHINFO SIMPLE since that's a violation of rfc 977, and either generic or original
			//should be there

			//TODO: and we're skipping AUTHINFO GENERIC for now, b/c I can't find an example of a particular
			//implementation.

			//since all auth attempts failed...
			return false;
		}
		//we might be able to post now when we couldn't before...
		[ self sendCommand: @"MODE" withArg: @"READER" ]; //(response to this tells us if we can post or not)
		//update canPost accordingly
		[ self interpretModeReaderResponse: [ self getLine ] ];

		//sweet
		return true;
	}

	//no auth needed.. so success
	return true;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  getGroupList
 *  Description:  get list of the groups this server has
 *                uses cache on disk, only updating when forceRefresh.
 *                if cache doesn't exist, it'll get a new listing
 * =====================================================================================
 */
- (NSData *) getGroupList: (bool) forceRefresh
{
	//TODO: once read file into memory... leave it there (and re-use it)?
	NSString * groups_file = GROUPS_FILE;
	NSMutableData * groups_array = nil;


	if ( !forceRefresh )
	{
		if ( _groups ) return _groups;

		if ( groups_file )
		{
			groups_array = [ NSMutableData dataWithContentsOfFile: groups_file ];
		}

		if ( groups_array != nil )
		{
			if ( _groups ) [ _groups release ];
			_groups = groups_array;
			return groups_array;
		}
	}

	//if get here, either we were forced to refresh, or failed to read the cache...

	[ self sendCommand: @"LIST" withArg: @"ACTIVE" ];
	if ( [self isSuccessfulCommand: [ self getLine ] ] )
	{
		NSArray * lines = [ self getResponse ];
		groups_array = [ [ NSMutableData alloc ] initWithLength: sizeof( NNTPGroup ) * [ lines count ] ];	
		NNTPGroup * groups_data = (NNTPGroup *)[ groups_array bytes ];

		NSEnumerator * enumer = [ lines objectEnumerator ];
		NSString * line;

		int i = 0;
		while  ( line = [ enumer nextObject ] )
		{
			NNTPGroup group = [ self NNTPGroupFromNSString: line ];
			group.hasUnread = false;//we don't keep track of this for unsubscribed groups
			
			groups_data[i++] = group;
		}
		
		//write it back!
		if ( groups_array )
		{
			[ groups_array writeToFile: groups_file atomically: YES ];	
			NSLog( @"wrote groups to file" );
		}

		if ( _groups ) [ _groups release ];
		_groups = groups_array;
		return groups_array;
	}

	return nil;//:-(

}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  subscribedGroups
 *  Description:  Returns array containing the subscribed groups. (of type NTTPGroup)
 * =====================================================================================
 */
- (NSData *) subscribedGroups
{
	//just pull from defaults :)
	NSMutableData * subscribed = [ [ NSUserDefaults standardUserDefaults ] objectForKey: K_SUBSCRIBED ];

	//loop var
	int i;
	if ( !subscribed )
	{
		//fetch with "list subscriptions" ?
		[ self sendCommand: @"LIST" withArg: @"SUBSCRIPTIONS" ];
		if ( [ self isSuccessfulCommand: [ self getLine ] ] )
		{
			NSArray * lines = [ self getResponse ];
			subscribed = [ [ NSMutableData alloc ] initWithLength: sizeof( NNTPGroup ) * [ lines count ] ];
			NNTPGroup * sub_arr = (NNTPGroup *)[ subscribed bytes ];
			NSLog ( @"%d", [ subscribed length ] / sizeof( NNTPGroup ) );
		//	NSLog( @"line count: %d", [ lines count ] );
			for ( i = 0; i < [ lines count ]; i++ )
			{
				strncpy( sub_arr[i].name, [ [ lines objectAtIndex: i ] UTF8String ], sizeof( sub_arr[i].name ) );;
				sub_arr[i].hasUnread = true;//it /*could*/ be empty
				sub_arr[i].low = 0;
				sub_arr[i].high = 0;
				sub_arr[i].count = 0;
				NSLog( @"%s", sub_arr[i].name );
			}
			[ [ NSUserDefaults standardUserDefaults ] setObject: subscribed forKey: K_SUBSCRIBED ];

			return subscribed;
		}
		
		return nil;

	}
	else
	{
		NSLog( @"%d", [ subscribed length ]/sizeof( NNTPGroup ) );
		NNTPGroup * sub_arr = (NNTPGroup *)[ subscribed bytes ];
		for ( i = 0; i < [ subscribed length ] / sizeof( NNTPGroup ); i++ )
		{
			NSLog( @"Subscribed to: %s", sub_arr[i].name );
		}

	}

	return subscribed;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  updateSubscribedGroups
 *  Description:  updates information on subscribed groups (high, low, etc).
 *                used to determine if we have unread articles or not.
 * =====================================================================================
 */
- (void) updateSubscribedGroups
{
	/*TODO:
	 * depending on server latency, number of subscribed groups, etc, it may or may not be efficient to send multiple 'group GROUPNAME' requests--/might/ be better to simply do a 'list', store that, and keep track of that.
	 * just something to keep in mind
	 */
	NSData * subscribed = [ self subscribedGroups ];

	NNTPGroup * sub_arr = (NNTPGroup *)[ subscribed bytes ];

	int i =0;
	int count = [ subscribed length ] / sizeof( NNTPGroup );

	//send a group command for each group....
	for ( ; i < count; i++ )
	{
		[ self sendCommand: @"GROUP" withArg: [ NSString stringWithCString: sub_arr[i].name ] ];
	}
	//now get the responses and parse
	for ( i = 0; i < count; i++ )
	{
		NSString * response = [ self getLine ];
		if ( [ self isSuccessfulCommand: response ] )
		{
			NSArray * parts = [ response componentsSeparatedByString: @" " ];
			//should be:
			//responsecode articlecount low high name
			NNTPGroup old = sub_arr[i];
			sub_arr[i].count = [ [ parts objectAtIndex: 1 ] intValue ];
			sub_arr[i].low = [ [ parts objectAtIndex: 2 ] intValue ];
			sub_arr[i].high = [ [ parts objectAtIndex: 3 ] intValue ];

			if ( !sub_arr[i].hasUnread )
			{
				//if more articles have been posted... then we have something to read
				sub_arr[i].hasUnread = ( sub_arr[i].high < old.high );
			}

		}
		else
		{
			//keep going
		}


	}


}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  setGroupAndFetchHeaders
 *  Description:  Enters the specified group
 *                also uses XOVER to get the headers.
 *                Uses the progressdelegate.
 * =====================================================================================
 */
- (void) setGroupAndFetchHeaders: (NSString *) group
{

}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  getArts
 *  Description:  returns pointer to internal array of the articles
 *                initially it's just the headers filled in by the initial XOVE
 *                body only guaranteed to be there for the last article that we got
 *                the body for (as memory allows)
 * =====================================================================================
 */
- (NSArray *) getArts
{

	return nil;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  updateAllSubscribedAndHeaders
 *  Description:  go through all subscribed groups and update them.
 *                this means their hi/lo (via updateSubscribedGroups) as well as
 *                fetching headers for each
 * =====================================================================================
 */
//- (void) updateAllSubcribedAndHeaders;

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  getBodyForArticle
 *  Description:  Returns pointer to the article requested, optionally fetching body
 *                Primary purpose is to fetch the body
 * =====================================================================================
 */
- (NNTPArticle *) getBodyForArticle: (int) artid
{

	return nil;
}
//TODO: clean up the bodies if we get a low-mem warning

//does what you'd expect
- (NNTPGroup) NNTPGroupFromNSString: (NSString *) string
{
	//groupname high low flags
	//for our purposes we're ignoring flags
	NSArray * parts = [ string componentsSeparatedByString: @" " ];
	NNTPGroup group;
	strncpy( group.name, [ [ parts objectAtIndex: 0 ] UTF8String ], sizeof( group.name ) );
	group.high = [ [ parts objectAtIndex: 1 ] intValue ];
	group.low = [ [ parts objectAtIndex: 2 ] intValue ];

	group.hasUnread = false;//default, just initializing it

	return group;
}

//TODO: POSTING SUPPORT!
//TODO: THREADING!


- (void) dealloc
{
	[ _arts release ];
	[ _groups release ];
	[ _subscribed release ];
	if ( _sockd )
	{
		close( _sockd );
		_sockd = 0;
	}

	if ( self == sharedInstance ) //it BETTER!
	{
		sharedInstance = nil;
	}

	[ super dealloc ];
}


@end
