//Will Dietz
//inewsgroup.m --wrapper/launcher for main application
#import <UIKit/UIKit.h>


/*
#import "iNewsApp.h"
#import "newsfunctions.h"
#import "datastructures.h"
*/
#import "tin.h"

int main(int argc, char **argv)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSLog( @"starting... \n" );	
	set_signal_handlers();
	
	read_news_via_nntp = true;
	nntp_server = "news.cs.uiuc.edu";

	batch_mode = true;//silence/speed things up...?
	
	init_alloc();
	hash_init();
	init_selfinfo();
	init_group_hash();
	setup_default_keys(); /* preinit keybindings */

	if ( !nntp_open() )
	{
		NSLog( @"opened successfully!\n" );
	}
	else
	{
		NSLog( @"error!\n");
//		exit( 0 );
	}

	char user[30], pass[30];
//	read_newsauth_file( nntp_server, user, pass);

	char response[1000];
	FILE * file;
	if ( file = nntp_command("list",215, response, 1000 ) ) 
		NSLog( @"worked:%s\n", response );
	else
		NSLog( @"failure\n" );
	char * line;

	while ( line = tin_fgets( file, FALSE ) )
	{
		printf( "%s\n", line );

	}

//old testing code:
/*
	NSLog( @"Return of newmessages():%d", tinCheckForMessages() );
	out_message msg;
	msg.subject = @"testing more";
	msg.newsgroups = @"cs.test";
	msg.content = @"This time it's completely automated.. no gui yet :(";
	connection c;
	c.from = @"Will Dietz <wdietz2@uiuc.edu>";
		
	NSLog( @"Writing message and sending..." );
	if ( argc != 2 )
	{
		sendMessage( msg, c );
	} 
	else
	{
		tinSendMessages();	
	}
	NSLog( @"done" );
*/
	return 0; //UIApplicationMain(argc, argv, [iNewsApp class]);
}
