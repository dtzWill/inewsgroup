//newsfunctions.m
//Will Dietz

/*
    This file is part of iNewsGroup.

    iNewsGroup is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    iNewsGroup is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with iNewsGroup.  If not, see <http://www.gnu.org/licenses/>.

*/

#import <Foundation/Foundation.h>
#import <Foundation/NSHost.h>
#import <dns_sd.h>
#import <UIKit/UIKit.h>
#import "newsfunctions.h"
#import "tin.h"
#import "extern.h"
#import "NetworkController.h"

//file name consts used for user flexibility.... wish I knew a better way to do this 
char F_NEWSAUTH_HOME[ MAX_FILENAME_LEN ];
char F_NEWSEMAIL_HOME[ MAX_FILENAME_LEN ];
char F_NEWSRC_HOME[ MAX_FILENAME_LEN ];
char F_POSTPONED_HOME[ MAX_FILENAME_LEN ];
char F_TIN_DIR_HOME[ MAX_FILENAME_LEN ];
char F_NNTP_HOME[ MAX_FILENAME_LEN ];
char F_TMPNEW_HOME[ MAX_FILENAME_LEN ];


bool m_hasConnected;

bool hasConnected()
{
	return m_hasConnected;
}

bool canPost()
{
	return can_post;
}



int numSubscribed()
{//TODO: Better way??
	int subCount = 0;
	int i;
	for_each_group(i)
		if ( active[i].subscribed )
			subCount++;
	return subCount;
}


int numActive()
{
	return num_active;

}

NSString * getServer()
{
	if ( nntp_server && strlen( nntp_server ) > 0 )
		return [NSString stringWithCString: nntp_server ];
	return @"";
}

NSString * getUserName()
{
	if ( authusername[0] != '\0' )
		return [NSString stringWithCString: (char *)authusername ]; 
	return @"";
}

NSString * getPass()
{
	if ( authpassword[0] != '\0' )
		return [NSString stringWithCString: (char *)authpassword ];
	return @""; 
}

NSString * getEmail()
{
	if ( email[0] != '\0' )
		return [NSString stringWithCString: (char *)email ];
	return @""; 
}

NSString * getRealName()
{
	if ( name[0] != '\0' )
		return [NSString stringWithCString: (char *)name ];
	return @"";
}

NSString * getFromString()
{
	//TODO: eventually add the user's full name as well, as set in the
	//preferences pane

	return [NSString stringWithFormat: L_FROM_FORMAT, getRealName(), getEmail()];

}


//bool weCreatedNNTPServer = false;
void setServer( NSString * server )
{

	nntp_server = (char *)malloc( strlen( [server cString] ) + 1 );
	strcpy( nntp_server, [server cString] );

//	NSLog( @" new server: %s\n", nntp_server );
}

void setUserName( NSString * user )
{
	authusername[0] = '\0';
	if (user && [ user cString ] )
		strncpy( authusername, [user cString], PATH_LEN );
//	NSLog( @" new username: %s\n", authusername );	
//	[user release];
}

void setPassword( NSString * pass )
{
	authpassword[0] = '\0';
	if ( pass && [pass cString] )
		strncpy( authpassword, [pass cString], PATH_LEN );
//	NSLog( @" new pass: %s\n", authpassword );

//	[pass release];

}

void setEmail( NSString * ns_email )
{
	email[0] = '\0';
	if( ns_email && [ns_email cString] )
		strncpy( email, [ns_email cString], MAX_EMAIL );
}

void setRealName( NSString * realname )
{
	name[0] = '\0';
	if( realname && [realname cString] )
		strncpy( name, [realname cString], MAX_EMAIL );
}

void readSettingsFromFile()
{

	FILE * f_newsauth;

	//update ~/.newsauth
	
	if ( ( f_newsauth = fopen( F_NEWSAUTH_HOME, "r" ) )== 0 )
	{
		//error :(
		return;
	}
	//for now, we only allow for /1/ line
	//TODO: change this if/when we support multiple servers

	
	//TODO: do a better job error handling than this!!
	fscanf( f_newsauth, "%s\t%s\t%s\n", nntp_server, authpassword, authusername );


	fclose( f_newsauth );


	FILE * f_email;

	//read from ~/.newsemail

	if ( ( f_email = fopen( F_NEWSEMAIL_HOME, "r" ) ) == 0 )
	{
		//error :(
		return;
	}

	fscanf( f_email, "%[^\n]\n", email );
	fscanf( f_email, "%[^\n]\n", name );

	fclose( f_newsauth );




}

void saveSettingsToFiles()
{
	//by 'update' I mean 'overwrite' and 'replace'
//	NSLog( @" saving settings...\n");
	FILE * f_nntpserver, * f_newsauth, * f_newsemail;
	NSLog( @"\ntrying to save...." );	 
	//update /etc/nntpserver
	
	if ( ( f_nntpserver = fopen( F_NNTP_HOME, "w" ) ) == 0 )
	{
		//error! :(
		return;
	}
	//else
	fprintf( f_nntpserver, "%s\n", nntp_server );

	fclose( f_nntpserver); //yay that was fun

	//update ~/.newsemail

	if ( ( f_newsemail = fopen( F_NEWSEMAIL_HOME, "w" ) ) == 0 )
	{
		//error :(
		return;
	}

	fprintf( f_newsemail, "%s\n", email );
	fprintf( f_newsemail, "%s\n", name );

	fclose( f_newsemail );//yay more fun


	//update ~/.newsauth
	
	if ( ( f_newsauth = fopen( F_NEWSAUTH_HOME, "w" ) )== 0 )
	{
		//error :(
		return;
	}
	//TODO: smarter behavior here?
	if (authpassword && strcmp( authpassword, "" ) &&
		authusername && strcmp( authusername, "" ) ) //don't bother writing if no username or password
		fprintf( f_newsauth, "%s\t%s\t%s\n",nntp_server, authpassword, authusername ); 	

	fclose( f_newsauth );
	NSLog( @"save successful!\n");
}


void loadGroup( int groupnum )
{
	tinrc.cache_overview_files = true;
	index_group( &active[ my_group[ groupnum ] ] );


}


int artsInThread( int threadnum )
{
	int i, count = 0;
	for_each_art_in_thread( i, threadnum )
	{
		count++;
	}
	return count;
}

bool openArticle( int groupnum, int articlenum )
{
/*	NSLog( @"attempting to open article: %s\ from group: %s\n", 
		arts[ articlenum].subject,
		active[ my_group[ groupnum ] ].name );
*/
	//This line looks worthless, but some code we call here needs this to be set appropriately.  Sigh... 
	curr_group = &active[ my_group[ groupnum ] ];

//	tinrc.wrap_column = 1000;

	return art_open( false, &arts[ articlenum ], //which article? THIS article
		curr_group,//grab the group
		&_curArt,//store it in our article data structure
		false, "Test" )//hell no progress meter :)
		== 0; //success??

}


NSString *	readArticleContent()
{
	NSMutableString * body = [[NSMutableString alloc] init];
	char * line;
	int i; 
/*
	rewind( _curArt.raw );

	NSLog( @"Raw Data" );
	while ( ( line = tin_fgets( _curArt.raw, TRUE ) ) != NULL )
	{
		NSLog( @"%s\n", line );
	}
*/
	rewind( _curArt.cooked );

	//i=1, to skip the 'Newsgroups: " line that should have been
	//removed with the headers, but apparently not.
	for (i = 1; i < _curArt.cooked_lines; i++) {
		fseek(_curArt.cooked, _curArt.cookl[i].offset, SEEK_SET);
		line = tin_fgets(_curArt.cooked, FALSE);
		[ body appendString: [ NSMutableString stringWithFormat: @"%s\n", line ] ];
	}
	return body;
}

NSString * articleFrom()
{
	if ( _curArt.hdr.from )
	{
		return [NSString stringWithCString: _curArt.hdr.from ];
	}
	return L_DEFAULT_FROM;

}

NSString * articleSubject()
{
	if ( _curArt.hdr.subj )
	{
		return [NSString stringWithCString: _curArt.hdr.subj ];
	}
	return L_DEFAULT_SUBJECT;

}

NSString * getReferences( int articlenum )
{

	char * refs = NULL;

	refs = get_references( arts[ articlenum ].refptr );
	NSString * ret = [NSString stringWithCString: ( refs ? refs : "" ) ];
//	NSLog( ret );
	
	return [ ret retain ];
}



void closeArticle()
{
	art_close( &_curArt );

}

void markArticleRead( int groupnum, int postnum )
{
	art_mark( &active[ my_group[ groupnum ] ], &arts[ postnum ], ART_READ );

}


void markGroupRead( int groupnum )
{
	grp_mark_read( &active[ my_group[ groupnum ] ], NULL );
}

bool isThreadRead( int threadnum )
{
	int i;
	for_each_art_in_thread( i, threadnum )
	{
		if ( arts[ i ].status == ART_UNREAD ) return false;//one unread article makes thread unread

	}
	return true;
}

void doSubscribe( struct t_group *  group, int status )
{

	subscribe( group, SUB_CHAR( status ), true );


}




//TODO: do we care about this function??
void readNewsRC()
{
	//TODO: do something with this number?
	read_news_via_nntp = true;
//	list_active = true;
//	newsrc_active = false;
	newsrc_active = true;
	list_active = false; 
	int num_subscribed = read_newsrc( newsrc, true );


}

void saveNews()
{
	write_config_file(local_config_file);
	write_newsrc();
}

void init()
{
	m_hasConnected = false;
	init_alloc();
//	NSLog( @"alloc init completed" );
	hash_init();
//	NSLog( @"hash init completed" );
	init_selfinfo();
//	NSLog( @"selfinfo init completed" );
	init_group_hash();
	//no we don't want anything keybinding-related, but for now
	//leaving this here so any code in tin depending on it doesn't
	//die horribly.
//	NSLog( @"group hash init completed" );
	setup_default_keys(); /* preinit keybindings */

	email[0] = '\0'; //empty

	set_signal_handlers();
//	NSLog( @"sig handler init completed" );
//	read_newsauth_file( nntp_server, user, pass );

	//colorSpace = CGColorSpaceCreateDeviceRGB();


	struct passwd * p = getpwuid( getuid() );
	char * home = p->pw_dir; 


	//the following is all just to make the files that are in ~/* go to the right place
	strncpy( F_NEWSAUTH_HOME, home, MAX_FILENAME_LEN - 1 ); 
	strncpy( F_NEWSEMAIL_HOME, home, MAX_FILENAME_LEN - 1 ); 
	strncpy( F_NEWSRC_HOME, home, MAX_FILENAME_LEN - 1 ); 
	strncpy( F_POSTPONED_HOME, home, MAX_FILENAME_LEN - 1 ); 
	strncpy( F_TIN_DIR_HOME, home, MAX_FILENAME_LEN - 1 ); 
	strncpy( F_NNTP_HOME, home, MAX_FILENAME_LEN - 1 ); 
	strncpy( F_TMPNEW_HOME, home, MAX_FILENAME_LEN - 1 ); 

	//TODO: use strncat
	strcat( F_NEWSAUTH_HOME, F_NEWSAUTH ); 
	strcat( F_NEWSEMAIL_HOME, F_NEWSEMAIL );
	strcat( F_NEWSRC_HOME, F_NEWSRC );
	strcat( F_POSTPONED_HOME , F_POSTPONEDARTICLES );
	strcat( F_TIN_DIR_HOME, TIN_DIR );
	strcat( F_NNTP_HOME, F_NNTPSERVER );
	strcat( F_TMPNEW_HOME, F_TMPNEW );

}

//dns request
bool resolveHostname( char * hostname )
{
	NSString * name = [NSString stringWithFormat: @"%s", hostname ];

	NSLog( @"Resolving for %@", name );
	DNSServiceErrorType error;
	DNSServiceRef service;

	error = DNSServiceQueryRecord( &service, 0 /*no flags*/,
		0 /*all network interfaces */,
		hostname,
		kDNSServiceType_A, /* we want the ipv4 addy */ 
		kDNSServiceClass_IN, /* internet */
		0, /* no callback */ 
		NULL /* no context */ );

	if ( error == kDNSServiceErr_NoError )//good so far...
	{
		int dns_sd_fd = DNSServiceRefSockFD(service);
		int nfds = dns_sd_fd + 1;
		fd_set readfds;
		struct timeval tv;
	
		FD_ZERO(&readfds);
		FD_SET(dns_sd_fd, &readfds);
		tv.tv_sec = DNS_RESOLV_TIMEOUT;
		tv.tv_usec = 0;
		bool ret = false;
		int result = select(nfds, &readfds, (fd_set*)NULL, (fd_set*)NULL, &tv);
		if (result > 0)
		{
			if (FD_ISSET(dns_sd_fd, &readfds))
			{
				//remove this if you want to compile in c, not obj-c
				NSLog( @"resolved %s to %@", hostname, [ [ NSHost hostWithName: name ] address ] );
				ret = true;
			}
		}
		//clean up and return accordingly
		DNSServiceRefDeallocate( service );
		return ret;

	}
	//clean up....
	DNSServiceRefDeallocate( service );

	NSLog( @"dns error: %d", error );

	return false;
}

int init_server()
{
	NSLog( @"Checking connection....");

//DEBUG:
//	force_no_post = YES;
//DEBUG
	if(!([[NetworkController sharedInstance]isNetworkUp]))
	{
		if(![[NetworkController sharedInstance]isEdgeUp])
		{
			[[NetworkController sharedInstance]keepEdgeUp];									
			[[NetworkController sharedInstance]bringUpEdge];
			NSLog( @"Bringing edge up....");//update message
			sleep( 3 );
//			[[MessageController sharedInstance] setAlertText: @"Bringing edge up... 5" ];
//			sleep(1);
//			[[MessageController sharedInstance] setAlertText: @"Bringing edge up... 4" ];
//			sleep(1);
//			[[MessageController sharedInstance] setAlertText: @"Bringing edge up... 3" ];
//			sleep(1);
//			[[MessageController sharedInstance] setAlertText: @"Bringing edge up... 2" ];
//			sleep(1);
//			[[MessageController sharedInstance] setAlertText: @"Bringing edge up... 1" ];
//			sleep(1);
//			[[MessageController sharedInstance] setAlertText: @"Connecting..." ];
		}
	}
	
	read_news_via_nntp = true; //not local news server
	check_for_new_newsgroups = true;//update newsgroup listing
	read_saved_news = false;//don't just read local cache of messages

	tinrc.auto_reconnect = true;
	tinrc.cache_overview_files = true;

	//These don't seem to have any effect, possibly overwritten by
	//group->attributes->thread_arts for the individual group 
//	tinrc.thread_articles = 0;
	tinrc.thread_articles = 3;//subject and reference

	changed = true; //flag ripped out of auth.c so we can tell it
					//to try again anyway
	
	//batch_mode = true;//silence/speed things up...?

	char * server = getserverbyfile( F_NNTP_HOME );
	if( !server )
		return false;//no server name, don't even try it
	//else
	nntp_server =  server;
	NSLog ( @"server: %s\n", nntp_server ) ;	

	readSettingsFromFile();
	
	NSLog( @"force_no_post: %d", force_no_post );

	force_auth_on_conn_open = ( authpassword[0] != '\0' );
	NSLog( @"Force auth: %d", force_auth_on_conn_open );

	if ( !resolveHostname( (char *)nntp_server ) )
		return false; //DNS failed :(

	int connect = nntp_open();

	if ( connect != 0 )
	{
		switch( connect )
		{
			case -1:
				//auth failed...?
			default:
				break;
		}
		NSLog( @"nntp_open() != 0, failing" );
		return false;
	}

	int worked = check_auth(); //make sure we're auth'd....


	NSLog( @"\n\ncheck_auth: %d\n", worked );
	if ( worked == -1 )//if failure....
	{
		return false; // :-(
	}



	postinit_regexp();

	m_hasConnected = true;
	return true;//it worked!!! \o/
}


int updateData()
{
	if ( hasConnected() )
	{	
		newsrc_active = false;
		list_active = true;
//		newsrc_active = true;
//		list_active = false;
	
//		[ [MessageController sharedInstance] setAlertText: @"Reading active file..." ];	
		read_news_active_file();
	
//		[ [MessageController sharedInstance] setAlertText: @"Reading newsgroups file..." ];	
		read_newsgroups_file( true );
	
		//TODO: use this value (and check that it means what the variable name suggests it emans)	
//		[ [MessageController sharedInstance] setAlertText: @"Reading newsrc file..." ];	
		int num_subscribed = read_newsrc( newsrc, true );
	
//		[ [MessageController sharedInstance] setAlertText: @"Updating active file.." ];	
		create_save_active_file();
	
		//don't update, it takes too long, let's do it when viewing a group..
	//	do_update( false );
	
		return true;//it worked!!! \o/
	}
	return false;
};


void printActive()
{
	int i;
	NSLog( @"%d\n", num_active );
	for_each_group(i)
	{
		NSLog( @"%s:%d\n", active[i].name, active[i].next );

	}


};

//sends a message synchronously
bool sendMessage( NSString * newsgroup, NSString * references, NSString * subject, NSString * message )
{
	//empty the postpone queue
	unlink( F_POSTPONED_HOME );

	NSLog( @"Sending Message: ");
	NSLog( @"Newsgroups: %@", newsgroup );
	NSLog( @"Subject: %@", subject );
	NSLog( @"References: %@", references );
	NSLog( @"message: %@", message );

	FILE * f_newmail;
	
	//write this to a file and then tell the tin code to add it to the postponed queue

	if ( ( f_newmail = fopen( F_TMPNEW_HOME, "w" ) ) == 0 )
	{
		//error! :(
		return;
	}
	//else

	//these aren't pushed into 'consts.h' because they aren't language-specific
	fprintf( f_newmail, "From: %s <%s>\n", name, email );

	fprintf( f_newmail, "Subject: %s\n", [ subject cString ] ); 

	fprintf( f_newmail, "Newsgroups: %s\n", [newsgroup cString ] );

	if ( [ references compare: @"" ] != 0 )
	{
		fprintf( f_newmail, "References: %s\n", [references cString ] );
	}

	fprintf( f_newmail, "\n" ); //newline to start the message

	fprintf( f_newmail, "%s\n", [ message cString ] );


	fclose( f_newmail ); //yay that was fun

	//now actually do the sending

	//we do it this roundabout way with the postponing, because this way we avoid
	//the ui-based post_loop 

	postpone_article( F_TMPNEW_HOME );

	bool ret =  pickup_postponed_articles( false, true ); //ask=no, all=yes

	char newsgroupsline[ 256 ];
	sprintf( newsgroupsline, "Newsgroups: %s", [ newsgroup cString ] );

	update_active_after_posting( newsgroupsline );

	return ret;

}

double getNewestDateInThread( int threadnum )
{
	double date = arts[ base[ threadnum ] ].date ;
	int i, art;
	for_each_art_in_thread( i, threadnum )
	{
		if ( arts[i].date > date ) date = arts[i].date;
	}


	return date;
}

NSString * getSenderForArt( int artnum )
{
//name doesn't seemt to be loaded until we load the rest of the article....
//	if ( arts[artnum].name )
//		return [ NSString stringWithCString: arts[artnum].name ];
	if ( arts[artnum].from )
	{
		return [ NSString stringWithCString: arts[artnum].from ];
	} 
	return @"";
}

NSString * getSenderForThread( int threadnum )
{
	if ( arts[ base[ threadnum ] ].from )
	{
		return [ NSString stringWithCString: arts[ base[ threadnum ] ].from ];
	}
	return @"";

}

//TODO: add function to fix all memory that's part of
//		--newsfunctions
//		--tin code, since this should be the layer between our code and tin's
