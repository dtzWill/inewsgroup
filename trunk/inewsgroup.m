//Will Dietz
//inewsgroup.m --wrapper/launcher for main application
#import <UIKit/UIKit.h>

#import "iNewsApp.h"
#import "newsfunctions.h"
#import "datastructures.h"

int main(int argc, char **argv)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

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
	return UIApplicationMain(argc, argv, [iNewsApp class]);
}