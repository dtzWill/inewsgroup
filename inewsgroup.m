//Will Dietz
//inewsgroup.m --wrapper/launcher for main application
#import <UIKit/UIKit.h>

#import "iNewsApp.h"


int main(int argc, char **argv)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSLog( @"starting... \n" );	
	
	return UIApplicationMain(argc, argv, [iNewsApp class]);
}
