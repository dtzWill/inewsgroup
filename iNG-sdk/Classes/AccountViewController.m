//
//  AccountViewController.m
//  iNG
//
//  Created by Will Dietz on 3/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AccountViewController.h"
#import "GroupListViewController.h"
#import "AccountView.h"
#import "authinfo.h"

#import "NNTPAccount.h"


@implementation AccountViewController

- (id)init
{
	if ( self = [ super init ] )
	{
		self.title = @"iNG";
	}
	return self;
}


- (void) loadView
{
	NSLog( @"loading view" );
	//TEMP UNTIL NSUSERDEFAULTS RESOLVED!
	[ [ NNTPAccount sharedInstance ] setServer: @"news.cs.uiuc.edu" ];
	[ [ NNTPAccount sharedInstance ] setPort: 119 ];
	[ [ NNTPAccount sharedInstance ] setUser: @"wdietz2" ];
	[ [ NNTPAccount sharedInstance ] setPassword: MY_PASS ];//would rather not check my pass into svn :)

	AccountView *view = [ [ AccountView alloc ] initWithFrame:[ UIScreen mainScreen ].applicationFrame ];
	self.view = view;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	[ view setDelegate: self ];


	[ view release ];
}
- (void) offlinePressed
{
	//TODO: implement!!
	NSLog( @"offline pressed!" );
}
- (void) connectPressed
{
	GroupListViewController * glvc = [ [ [ GroupListViewController alloc ] init ] autorelease ];
	[ (UINavigationController *)self.parentViewController pushViewController: glvc animated: YES ];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview.
	// Release anything that's not essential, such as cached data.
}

- (void)dealloc
{
	[super dealloc];
}

@end
