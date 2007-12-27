//newsfunctions.c
//Will Dietz
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "newsfunctions.h"
#import "tin.h"
#import "extern.h"
#import "NetworkController.h"

bool m_hasConnected;

bool hasConnected()
{
	return m_hasConnected;
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
	return nil;
}

NSString * getUserName()
{
	if ( authusername[0] != '\0' )
		return [NSString stringWithCString: (char *)authusername ]; 
	return nil;
}

NSString * getPass()
{
	if ( authpassword[0] != '\0' )
		return [NSString stringWithCString: (char *)authpassword ];
	return nil; 
}

NSString * getEmail()
{
	if ( email[0] != '\0' )
		return [NSString stringWithCString: (char *)email ];
	return nil; 
}

NSString * getFromString()
{
	//TODO: eventually add the user's full name as well, as set in the
	//preferences pane

	return [NSString stringWithFormat: L_FROM_FORMAT, getEmail()];

}


//bool weCreatedNNTPServer = false;
void setServer( NSString * server )
{
	//TODO:
	//necessary?? better way?!?! gah
/*	if ( nntp_server && weCreatedNNTPServer )
		free( nntp_server );
*/
	//the above doesn't work.. and maybe eventually I'll got through the tin code..
	//for now.. potential leak :-/
	nntp_server = (char *)malloc( strlen( [server cString] ) + 1 );
	strcpy( nntp_server, [server cString] );
//	[server release];
//	weCreatedNNTPServer = true;
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


void readSettingsFromFile()
{

	FILE * f_newsauth;

	//update ~/.newsauth
	
	if ( ( f_newsauth = fopen( F_NEWSAUTH, "r" ) )== 0 )
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

	if ( ( f_email = fopen( F_NEWSEMAIL, "r" ) ) == 0 )
	{
		//error :(
		return;
	}

	fscanf( f_email, "%s\n", email );

	fclose( f_newsauth );




}

void saveSettingsToFiles()
{
	//by 'update' I mean 'overwrite' and 'replace'
//	NSLog( @" saving settings...\n");
	FILE * f_nntpserver, * f_newsauth, * f_newsemail;
	NSLog( @"\ntrying to save...." );	 
	//update /etc/nntpserver
	
	if ( ( f_nntpserver = fopen( F_NNTPSERVER, "w" ) ) == 0 )
	{
		//error! :(
		return;
	}
	//else
	fprintf( f_nntpserver, "%s\n", nntp_server );

	fclose( f_nntpserver); //yay that was fun

	//update ~/.newsemail

	if ( ( f_newsemail = fopen( F_NEWSEMAIL, "w" ) ) == 0 )
	{
		//error :(
		return;
	}

	fprintf( f_newsemail, "%s\n", email );

	fclose( f_newsemail );//yay more fun


	//update ~/.newsauth
	
	if ( ( f_newsauth = fopen( F_NEWSAUTH, "w" ) )== 0 )
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
	//DAMN YOU CURR_GROUP :-(
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
	NSLog( ret );
	
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
	list_active = true;
	newsrc_active = false;
//	newsrc_active = true;
//	list_active = false; 
	int num_subscribed = read_newsrc( newsrc, true );
//	list_active = true;
//	newsrc_active = false;

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

}

//ty rss for code structure
bool fakeHTTPRequest( char * url )
{
	NSURLResponse *response=0;
	NSError *error=0;
	NSData * responsedata;
	NSString * urlstr = [NSString stringWithFormat: @"http://%s", url ];
	NSURL * newsserverurl = [NSURL URLWithString: urlstr];
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL: newsserverurl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval: HTTP_REQUEST_TIMEOUT ];
	if ( ! theRequest )
	{
		NSLog( @"Error in request");
		return false;
	}	
	responsedata = [NSURLConnection sendSynchronousRequest: theRequest returningResponse: &response error: &error];
	
	if ( ! responsedata )
	{
		NSLog(@"Error in fakeHTTPrequest!");
		return false;
	}
	

//	CFRelease( message );
//	CFRelease( newsserverurl );
//	CFRelease( data );
	
//	[urlstr release];

	NSLog( @"done with httprequest");
	return true;
}

int init_server()
{
	NSLog( @"Checking connection....");
	//make sure we have a connection.. we'll need it :)
//	[[NetworkController sharedInstance]keepEdgeUp];									
//	[[NetworkController sharedInstance]bringUpEdge];
//	sleep ( 5 );

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
	tinrc.thread_articles = 3;//subject and reference

	changed = true; //flag ripped out of auth.c so we can tell it
					//to try again anyway
	
	//batch_mode = true;//silence/speed things up...?

	char * server = getserverbyfile( NNTP_SERVER_FILE );
	if( !server )
		return false;//no server name, don't even try it
	//else
	nntp_server =  server;
	NSLog ( @"server: %s\n", nntp_server ) ;	

	readSettingsFromFile();
	
	NSLog( @"force_no_post: %d", force_no_post );

	force_auth_on_conn_open = ( authpassword[0] != '\0' );
	NSLog( @"Force auth: %d", force_auth_on_conn_open );

	int connect = nntp_open();
//	NSLog( @"nntp_open: %d", connect );
	if ( connect == -65 ) //if failed due to system call, particularly "no route to host"
	{
		NSLog( @"Connect failed  --couldn't resolve host, trying http req" );
//		[ [MessageController sharedInstance] setAlertText: @"Can't find server.  Trying to force dns resolution..." ];
		if ( !fakeHTTPRequest( (char *)nntp_server ) )//if we can't connect at all
		{
			NSLog( @"Failed to connect!" );
			return false;	
		}
		NSLog( @"Reconnecting...." );
		if ( ( connect = nntp_open() ) != 0 )
		{
			NSLog( @"Failed to connect!" );
			return false;
		}	
		
	}
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


//	NSLog( @"\n\nworked: %d\n", worked );
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

	NSLog( @"Sending Message: ");
	NSLog( @"Newsgroups: %@", newsgroup );
	NSLog( @"Subject: %@", subject );
	NSLog( @"References: %@", references );
	NSLog( @"message: %@", message );


	references = nil;

	FILE * f_newmail;
	
	//write this to a file and then tell the tin code to add it to the postponed queue

	if ( ( f_newmail = fopen( F_TMPNEW, "w" ) ) == 0 )
	{
		//error! :(
		return;
	}
	//else

	//these aren't pushed into 'consts.h' because they aren't language-specific
	fprintf( f_newmail, "From: %s\n", [ getEmail() cString ] );

	fprintf( f_newmail, "Subject: %s\n", [ subject cString ] ); 

	fprintf( f_newmail, "Newsgroups: %s\n", [newsgroup cString ] );

	if ( [ references compare: @"" ] != 0 )
	{
		fprintf( f_newmail, "References: %s\n", [references cString ] );
	}

	fprintf( f_newmail, "\n" ); //newline to start the message

	fprintf( f_newmail, "%s\n", [ message cString ] );


	fclose( f_newmail ); //yay that was fun


	postpone_article( F_TMPNEW );

	return pickup_postponed_articles( false, true ); //ask=no, all=yes

}





//TODO: add function to fix all memory that's part of
//		--newsfunctions
//		--tin code, since this should be the layer between our code and tin's
