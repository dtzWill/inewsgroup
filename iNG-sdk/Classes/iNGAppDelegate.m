//
//  iNGAppDelegate.m
//  iNG
//
//  Created by Will Dietz on 3/16/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "iNGAppDelegate.h"
#import "AccountViewController.h"
#import "NNTPAccount.h"

@implementation iNGAppDelegate

@synthesize window;
@synthesize contentView;

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	// Create window
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

	//Root viewcontroller:
	AccountViewController * avc = [ [ [ AccountViewController alloc ] init ] autorelease ];
	UINavigationController * nav = [ [ UINavigationController alloc ] initWithRootViewController: avc ];

	contentView = [ nav view ];
	
	// Add ViewController as our primary content...
	[ window addSubview: (UIView *)contentView ];
    
	// Show window
	[window makeKeyAndVisible];

}

- (void)dealloc
{
	[ [ NNTPAccount sharedInstance ] release ];//also closes any open connection
	[ window release ];
	[ super dealloc ];
}

@end
