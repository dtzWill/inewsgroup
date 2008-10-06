//
//  NNTPAccount.m
//  iNG
//
//  Created by Will Dietz on 3/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NNTPAccount.h"
#import "resolveHostname.h"
#import "NNTPGroupBasic.h"

#import <arpa/inet.h>
#import <fcntl.h>

//comment this out to hide the nslog'ing of network read/writes
#define DEBUG_NETWORK_ACTIVITY 1

//NOTE these *must* match the keys as defined in
//Root.plist in Settings.bundle
//preferences
#define K_SERVER @"SERVER"
#define K_PORT @"PORT"
#define K_USER @"USERNAME"
#define K_PASSWORD @"PASSWORD"
#define K_MAX_ART_CACHE @"MAXARTCACHE"
#define K_SUBSCRIBED @"SUBSCRIBED"
//group cache
#define K_GROUPS @"ACTIVE_GROUPS"

#define CONNECT_TIMEOUT 10
#define COMMAND_TIMEOUT 10

#define RESOURCEPATH [ NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) objectAtIndex: 0 ]
#define F_SUBS [ RESOURCEPATH stringByAppendingPathComponent: @"iNG.subs.data" ]
#define F_GROUPS [ RESOURCEPATH stringByAppendingPathComponent: @"iNG.groups.data" ]

//max size of a single line
#define MAX_BUFFER_SIZE 1000

static NNTPAccount * sharedInstance = nil;

@implementation NNTPAccount

+ (NNTPAccount * ) sharedInstance
{
	if ( sharedInstance )
		return sharedInstance;
	//else
	return sharedInstance = [ [ NNTPAccount alloc ] init ];
}

//init constructor
- (NNTPAccount *) init
{
	if ( self = [ super init ] )
	{
		_sockd = 0;
		_networkStream = 0;
		_groups = nil;
		_subscribed = nil;
		_canPost = false;
		_currentGroup = nil;
		_authFailDelegate = nil;
	}

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

- (unsigned int) getMaxArtCache
{
	unsigned int max = [ [ NSUserDefaults standardUserDefaults ] integerForKey: K_MAX_ART_CACHE ];
	if ( !max )
	{
		max = 50;
	}
	return max;
}


- (int) getPort
{
	int port = [ [ NSUserDefaults standardUserDefaults ] integerForKey: K_PORT ];
	if ( !port )
	{
		port = 119;//default NNTP port
	}

	return port;
}
- (bool) isConnected;
{
	//TODO: possibly do more than check if we ever connected successfully...
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
	if ( [self isConnected ] )
	{
		//TODO: possibly do a simple command to verify we're up
		return true;
	}
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
		NSLog( @"Failed to get socket options" );
		close( _sockd );
		_sockd = 0;
		return NO;
	}

	arg |= O_NONBLOCK; 
	
	if( fcntl( _sockd, F_SETFL, arg ) < 0 )
	{
		NSLog( @"Failed to set nonblocking option" );
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
				NSLog( @"Error in connect attempt" );
				close( _sockd );
				_sockd = 0;
				return NO;//error connecting
			}
			else if ( res == 0 )
			{
				NSLog( @"Connect timed out" );
				close( _sockd );
				_sockd = 0;
				return NO;//timeout :(
			}
			//res > 0

			//make sure things went smoothly...

			if ( getsockopt( _sockd, SOL_SOCKET, SO_ERROR, (void*)(&optval), &optlen ) < 0 ) 
			{
				NSLog( @"Error in getsockopt" );
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
			NSLog( @"Not error expected, connect failed" );
			//not the errorcode we expected..so error
			close( _sockd );
			_sockd = 0;
			return NO;
		}
	}

	//back to blocking since that's what we want
	if ( ( arg = fcntl( _sockd, F_GETFL, NULL ) ) < 0 )
	{
		NSLog( @"Failed to get socket options" );
		close( _sockd );
		_sockd = 0;
		return NO;
	}

	arg &= ~O_NONBLOCK;//make it blocking again..

	if ( fcntl( _sockd, F_SETFL, arg ) < 0 )
	{
		NSLog( @"Failed to set blocking option" );
		close( _sockd );
		_sockd = 0;
		return NO;
	}
	_networkStream = fdopen( _sockd, "rw" );

	bool worked = [ self getLine ] != nil;
	if ( !worked )
	{
		NSLog( @"Error in getting first response line" );
	}
	return worked;

}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  getLine
 *  Description:  reads a line from the network stream
 * =====================================================================================
 */
- (NSString *) getLine
{
	NSString * ret = nil;
	char buffer[MAX_BUFFER_SIZE];
	//TODO: non-blocking, and TIMEOUT.

	int size;
	char * res = fgets( buffer, sizeof( buffer ) - 1, _networkStream );
	if ( res )
	{
		//remove newlines as appropriate
		size = strlen( buffer );
		//if last character is \n... remove it!
		if ( size > 1 )
		{
			if ( buffer[ size - 1 ] == '\n' )
			{
				buffer[ size - 1 ] = '\0';
			}
			//could've been a dos-style newline
			if ( size > 2 )
			{
				if ( buffer[ size - 2 ] == '\r' )
				{

					buffer[ size - 2 ] = '\0';
				}
			}
		}

		ret = [ [ NSString alloc ] initWithCString: buffer ];
	}
	else
	{
		NSLog( @"Error in getLine", errno );
		return nil;
	}

#if DEBUG_NETWORK_ACTIVITY
	NSLog( @"RECV: %@", ret );
#endif
	
	return ret;
}

- (void) setAuthFailDelegate: (id) delegate
{
	_authFailDelegate = delegate;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  isSuccessfulCommand
 *  Description:  returns true iff the string starts with a '2'.  Used to determine if a server is happy.  if response code indicates auth needed, calls authNeededDelegate
 * =====================================================================================
 */
- (bool) isSuccessfulCommand: (NSString *) response
{
	//check to see if we have an auth-related error
	//381--more info needed (pass usually, see above)
	//480--auth needed (?)
	//482--auth rejected
	//502--no permission
	if ( [ response hasPrefix: @"381" ] || [ response hasPrefix: @"480" ] || [ response hasPrefix: @"482" ] || [ response hasPrefix: @"502" ] )
	{
		NSLog( @"Auth Error!" );
		if ( _authFailDelegate && [ _authFailDelegate respondsToSelector:@selector( authFail: ) ] )
		{
			[ _authFailDelegate authFail: response ];
		}
	}

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
#if DEBUG_NETWORK_ACTIVITY
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
		//XXX: BETTER HANDLING OF THIS!
		if ( !line )//if we had a network problem...
		{
			break;
		}
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
			[ self getLine ];
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
	//TODO: verify?
	[ self sendCommand: @"MODE" withArg: @"READER" ];
	response = [ self getLine ];
	return [ self isSuccessfulCommand: response ];
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  getGroupList
 *  Description:  get list of the groups this server has
 *                uses cache on disk, only updating when forceRefresh.
 *                if cache doesn't exist, it'll get a new listing
 * =====================================================================================
 */
- (NSArray *) getGroupList: (bool) forceRefresh
{
	//TODO: once read file into memory... leave it there (and re-use it)?
	NSMutableArray * groups_array = nil;

	if ( !forceRefresh )
	{
		if ( _groups ) return [ _groups retain ];

		NSDictionary * rootObject = [ NSKeyedUnarchiver unarchiveObjectWithFile: F_GROUPS ];
		groups_array = [ rootObject valueForKey: K_GROUPS ];

		if ( groups_array != nil )
		{
			//if _groups were defined we would return already
			//XXX: review this logic
			NSLog( @"groups from file! count: %d", [ groups_array count ] );
			_groups = groups_array;
			return [ _groups retain ];
		}
	}

	//if get here, either we were forced to refresh, or failed to read the cache...

	[ self sendCommand: @"LIST" withArg: @"ACTIVE" ];
	if ( [self isSuccessfulCommand: [ self getLine ] ] )
	{
		NSArray * lines = [ self getResponse ];

		//we have a list of the groups in 'lines', but we want to strip
		//all the unneeded data.  we don't track high/low/anything
		//for non-subscribed groups, only we want a list
		//of what exists
		groups_array = [ NSMutableArray arrayWithCapacity: [ lines count ] ];	
		[ groups_array retain ];

		for ( NSString * line in lines )
		{

			NSArray * parts = [ line componentsSeparatedByString: @" " ];
			[ groups_array addObject: [ [ parts objectAtIndex: 0 ] retain ] ]; 
		}
		
		[ groups_array sortUsingSelector: @selector(compare:) ];


		//write it back!
		if ( groups_array )
		{
			NSMutableDictionary * rootObject;
			rootObject = [ [ [ NSMutableDictionary alloc ] init ] autorelease ];
			[ rootObject setValue: groups_array forKey: K_GROUPS ];
			NSLog( @"save grouplist: %d", [ NSKeyedArchiver archiveRootObject: rootObject toFile: F_GROUPS ] );

		}

		if ( _groups ) [ _groups release ];
		_groups = groups_array;
		return _groups;
	}

	return nil;//:-(

}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  saveSubscribedGroups
 *  Description:  saves _subscribed to disk
 * =====================================================================================
 */
- (void) saveSubscribedGroups
{
	//write it back!
	if ( _subscribed )
	{
		[ _subscribed sortUsingSelector: @selector(compareGroupName:) ];
		NSMutableDictionary * rootObject;
		rootObject = [ [ [ NSMutableDictionary alloc ] init ] autorelease ];
		[ rootObject setValue: _subscribed forKey: K_SUBSCRIBED ];
		NSLog( @"save subscriptions: %d", [ NSKeyedArchiver archiveRootObject: rootObject toFile: F_SUBS ] );
	}
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  subscribedGroups
 *  Description:  Returns array containing the subscribed groups. (of type NTTPGroupBasic)
 * =====================================================================================
 */
- (NSArray *) subscribedGroups
{
	//XXX
	if ( _subscribed ) return _subscribed;

	//load from file if we can

	NSDictionary * rootObject = [ NSKeyedUnarchiver unarchiveObjectWithFile: F_SUBS ];
	NSMutableArray * subscribed = [ rootObject valueForKey: K_SUBSCRIBED ];

	//loop var
	unsigned int i;
	if ( !subscribed )
	{
		
		[ self sendCommand: @"LIST" withArg: @"SUBSCRIPTIONS" ];
		if ( [ self isSuccessfulCommand: [ self getLine ] ] )
		{
			NSArray * lines = [ self getResponse ];
			subscribed = [ NSMutableArray arrayWithCapacity: [ lines count ] ];
		//	NSLog( @"line count: %d", [ lines count ] );
			for ( i = 0; i < [ lines count ]; i++ )
			{
				NNTPGroupBasic * subscribedGroup = [ [ NNTPGroupBasic alloc ] initWithName: [ lines objectAtIndex: i ] ];
				[ subscribed addObject: subscribedGroup ];
				[ subscribedGroup release ];
			}

			[ subscribed retain ];

			_subscribed = subscribed;

			[ self saveSubscribedGroups ];

			return subscribed;
		}
		
		return nil;

	}
	else
	{
		//print out subscriptions for debug's sake?
		NSLog( @"already had subscription list!" );
		_subscribed = [ subscribed retain ];

	}

	return subscribed;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  updateGroupUnread
 *  Description:  updates unread data
 * =====================================================================================
 */
- (void) updateGroupUnread
{
	if ( _currentGroup )
	{
		[ _currentGroup updateUnreadCount ];
	}
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
	NSArray * subscribed = [ self subscribedGroups ];
	unsigned int i;//iter var

	//send a group command for each subscribed group
	for ( i = 0; i < [ subscribed count ]; i++ )
	{
		[ self sendCommand: @"GROUP" withArg: ( (NNTPGroupBasic *)[ subscribed objectAtIndex: i ] ).name ];
	}

	//now get responses
	for ( i = 0; i < [ subscribed count ]; i++ )
	{
		NSString * response = [ self getLine ];
		if ( [ self isSuccessfulCommand: response ] )
		{
			[ (NNTPGroupBasic *)[ subscribed objectAtIndex: i ] updateWithGroupLine: response ];
		}
	}
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  setGroupAndFetchHeaders
 *  Description:  Enters the specified group
 *                also gets the headers
 *                Uses the progressdelegate.
 * =====================================================================================
 */
- (void) setGroupAndFetchHeaders: (NSString *) group
{
	NNTPGroupBasic * newGroup = nil;
	for( NNTPGroupBasic * basic in [ self subscribedGroups ] )	
	{
		if ( [ basic.name isEqualToString: group ] )
		{
			newGroup = basic;	
			break;
		}
	}
	//XXX: what if _currentGroup is what we want already?
	[ self leaveGroup ];

	if ( newGroup )
	{
		_currentGroup = [ newGroup enterGroup ];
		[ _currentGroup refresh ];
	}
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  leaveGroup
 *  Description:  leaves group we're currently in
 * =====================================================================================
 */
- (void) leaveGroup
{
	if ( _currentGroup )
	{
		[ [ _currentGroup getParent ] leaveGroup ];
		_currentGroup = nil;
	}
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

	if ( _currentGroup )
	{
		return _currentGroup.articles;
	}
	//else	
	
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


//TODO: POSTING SUPPORT!
//TODO: THREADING!


- (void) dealloc
{
	[ _groups release ];
	[ _subscribed release ];
	if ( _networkStream )
	{
		fclose( _networkStream );
		_networkStream = 0;	
	}

	if ( self == sharedInstance ) //it BETTER!
	{
		sharedInstance = nil;
	}

	[ super dealloc ];
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  isSubscribedTo
 *  Description:  returns if we're subscribed to the group specified.
 * =====================================================================================
 */
- (bool) isSubscribedTo: (NSString *) group
{
	for( NNTPGroupBasic * basic in [ self subscribedGroups ] )	
	{
		if ( [ basic.name isEqualToString: group ] )
		{
			return true;
		}
	}

	return false;
}



/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  subscribeTo
 *  Description:  subscribe to the group specified if we're not already
 * =====================================================================================
 */
- (void) subscribeTo: (NSString *) group
{
	if ( ![ self isSubscribedTo: group ] )
	{
		NNTPGroupBasic * basic = [ [ NNTPGroupBasic alloc ] initWithName: group ];

		[ _subscribed addObject: basic ];
		[ basic release ];

		[ self saveSubscribedGroups ];

	}

}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  unsubscribeFrom
 *  Description:  unsubscribe from the group specified
 * =====================================================================================
 */
- (void) unsubscribeFrom: (NSString *) group
{
	[ self subscribedGroups ];

	unsigned int i = 0;
	for ( NNTPGroupBasic * basic in _subscribed )
	{
		if ( [ basic.name isEqualToString: group ] )
		{
			break;
		}
		i++;
	}

	if ( i < [ _subscribed count ] )//if we found it
	{
		[ _subscribed removeObjectAtIndex: i ] ;
	}
}


@end
