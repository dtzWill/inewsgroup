//newsfunctions.c
//Will Dietz
//#import <unistd.h>
//#import <stdio.h>
//#import <CFNetwork/CFNetwork.h>
//#import <CFNetwork/CFHTTPMessage.h>
//#import "datastructures.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "newsfunctions.h"
#import "tin.h"
#import "extern.h"


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

void readSettingsFromFile()
{

	FILE * f_newsauth;

	//update ~/.newsauth
	
	if ( ( f_newsauth = fopen( "/var/root/.newsauth", "r" ) )== 0 )
	{
		//error :(
		return;
	}
	//for now, we only allow for /1/ line
	//TODO: change this if/when we support multiple servers

	
	//TODO: do a better job error handling than this!!
	fscanf( f_newsauth, "%s\t%s\t%s\n", nntp_server, authpassword, authusername );


	fclose( f_newsauth );

}

void saveSettingsToFiles()
{
	//by 'update' I mean 'overwrite' and 'replace'
//	NSLog( @" saving settings...\n");
	FILE * f_nntpserver, * f_newsauth;
	NSLog( @"\ntrying to save...." );	 
	//update /etc/nntpserver
	
	if ( ( f_nntpserver = fopen( "/etc/nntpserver", "w" ) ) == 0 )
	{
		//error! :(
		return;
	}
	//else
	fprintf( f_nntpserver, "%s\n", nntp_server );

	fclose( f_nntpserver); //yay that was fun

	//update ~/.newsauth
	
	if ( ( f_newsauth = fopen( "/var/root/.newsauth", "w" ) )== 0 )
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
	for (i = 0; i < _curArt.cooked_lines; i++) {
		fseek(_curArt.cooked, _curArt.cookl[i].offset, SEEK_SET);
		line = tin_fgets(_curArt.cooked, FALSE);
		[ body appendString: [ NSMutableString stringWithFormat: @"%s\n", line ] ];
	}
	return body;
}

NSString * articleFrom()
{
	return [NSString stringWithCString: _curArt.hdr.from ];

}

NSString * articleSubject()
{
	return [NSString stringWithCString: _curArt.hdr.subj ];

}



void closeArticle()
{
	art_close( &_curArt );

}

void markArticleRead( int groupnum, int postnum )
{
	art_mark( &active[ my_group[ groupnum ] ], &arts[ postnum ], ART_READ );

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
	newsrc_active = true;
/*	newsrc_active = true;
	list_active = false; */
	int num_subscribed = read_newsrc( newsrc, true );
//	list_active = true;
//	newsrc_active = false;

}


void init()
{
	m_hasConnected = false;
	init_alloc();
	hash_init();
	init_selfinfo();
	init_group_hash();
	//no we don't want anything keybinding-related, but for now
	//leaving this here so any code in tin depending on it doesn't
	//die horribly.
	setup_default_keys(); /* preinit keybindings */

	set_signal_handlers();
//	read_newsauth_file( nntp_server, user, pass );

	colorSpace = CGColorSpaceCreateDeviceRGB();

}

//ty rss for code structure
void fakeHTTPRequest( char * url )
{
	NSURLResponse *response=0;
	NSError *error=0;
	NSData * responsedata;
	NSString * urlstr = [NSString stringWithFormat: @"http://%s", url ];
	NSURL * newsserverurl = [NSURL URLWithString: urlstr];
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL: newsserverurl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
	
	responsedata = [NSURLConnection sendSynchronousRequest: theRequest returningResponse: &response error: &error];
	
	if ( responsedata == nil )
	{
		//ERROR! show alert and handle gracefully
		/*_eyeCandy = [[EyeCandy alloc] init];
		[_eyeCandy showStandardAlertWithString: @"An Error Occurred" closeBtnTitle: @"Close" withError: [error localizedFailureReason]];

		*/
	}
	

//	CFRelease( message );
//	CFRelease( newsserverurl );
//	CFRelease( data );
	
//	[urlstr release];

	NSLog( @"done with httprequest");
}

int init_server()
{
	
	read_news_via_nntp = true;
	check_for_new_newsgroups = true;
	read_saved_news = false;
//why was this ever a good idea??
	//force_auth_on_conn_open = true;

	newsrc_active = false;
	list_active = true;
	tinrc.auto_reconnect = true;
	tinrc.cache_overview_files = true;
	tinrc.thread_articles = 3;//subject and reference
	
	//batch_mode = true;//silence/speed things up...?

	nntp_server =  getserverbyfile(NNTP_SERVER_FILE);
	NSLog ( @"server: %s\n", nntp_server ) ;	
	fakeHTTPRequest( (char *)nntp_server );
	NSLog ( @"server: %s\n", nntp_server ) ;	

//make httprequest we don't care about.  doesn't matter if it works or not--this fixes the dns resolution by using the apple api to try to resolve it.
//it's a little slower, but /works/ which until libresolv.a gets figured out is plenty sufficient.



	if ( nntp_open() == 0 )
	{
		NSLog( @"Established connection to %s\n", nntp_server );
	}
	else
	{
		NSLog( @"error connecting to server: %s\n", nntp_server );
		return false;
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
		
		read_news_active_file();
	
		read_newsgroups_file( true );
	
		//TODO: use this value (and check that it means what the variable name suggests it emans)	
		int num_subscribed = read_newsrc( newsrc, true );
	
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

//TODO: add function to fix all memory that's part of
//		--newsfunctions
//		--tin code, since this should be the layer between our code and tin's