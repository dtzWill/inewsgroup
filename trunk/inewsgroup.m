//Will Dietz
//inewsgroup.m --wrapper/launcher for main application
#import <UIKit/UIKit.h>
#import "consts.h"
#import "iNewsApp.h"

//run the main app!
int main(int argc, char **argv)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSLog( @"starting... \n" );	

	//make sure this directory exists!
	mkdir( TIN_DIR, S_IRUSR | S_IWUSR | S_IXUSR | S_IRGRP | S_IWGRP | S_IXGRP ); 

	
	return UIApplicationMain(argc, argv, [iNewsApp class]);
}
