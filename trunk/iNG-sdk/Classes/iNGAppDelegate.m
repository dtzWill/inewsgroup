//
//  iNGAppDelegate.m
//  iNG
//
//  Created by Will Dietz on 3/16/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "iNGAppDelegate.h"
#import "ViewController.h"
#import "StartView.h"

@implementation iNGAppDelegate

@synthesize window;
@synthesize contentView;

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	// Create window
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	
    // Set up starting view (StartView)
	self.contentView = [[[StartView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];

	[ contentView loadView ];

	[ [ ViewController sharedInstance ] addSubview: (StartView *)contentView ];
	[ [ ViewController sharedInstance ] setCurView: (StartView *)contentView ];
    
	// Add ViewController as our primary content...
	[window addSubview: [ ViewController sharedInstance ] ];
    
	// Show window
	[window makeKeyAndVisible];
}

- (void)dealloc {
	[contentView release];
	[window release];
	[super dealloc];
}

@end
