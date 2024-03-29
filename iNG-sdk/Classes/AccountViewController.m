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

		_authAlert = [[UIAlertView alloc] initWithTitle: @"Authentication Error!"
												message: nil
											   delegate: self
									  cancelButtonTitle: @"Okay"
									  otherButtonTitles: nil];
	}
	return self;
}


- (void) loadView
{
	NSLog( @"loading view" );
	//XXX
	//Remove this before any real build--this is so I don't have to set these
	//values by hand every time I wanna debug
	//XXX
	[ [ NNTPAccount sharedInstance ] setServer: @"news.cs.uiuc.edu" ];
	[ [ NNTPAccount sharedInstance ] setPort: 119 ];
	[ [ NNTPAccount sharedInstance ] setUser: @"wdietz2" ];
	[ [ NNTPAccount sharedInstance ] setPassword: MY_PASS ];//would rather not check my pass into svn :)
	[ [ NNTPAccount sharedInstance ] setAuthFailDelegate: self ];

	AccountView *view = [ [ AccountView alloc ] initWithFrame:[ UIScreen mainScreen ].applicationFrame ];
	self.view = view;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	[ view setDelegate: self ];


	[ view release ];
}
- (void) offlinePressed
{
	[ [ NNTPAccount sharedInstance ] setOffline: YES ];
	[ self connectPressed ];
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
	[ _authAlert release ];
}



- (void) authFail: (NSString *) response
{
	NSLog( @"Auth failed! %@", response );
	[ _authAlert show ];
}
@end
