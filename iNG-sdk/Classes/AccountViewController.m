//
//  AccountViewController.m
//  iNG
//
//  Created by Will Dietz on 3/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountView.h"


@implementation AccountViewController

- (id)init
{
	if ( self = [ super init ] )
	{
		self.title = @"iNG -- Account";
	}
	return self;
}


- (void) loadView
{
	NSLog( @"loading view" );
	AccountView *view = [ [ AccountView alloc ] initWithFrame:[ UIScreen mainScreen ].applicationFrame ];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;

	view.autoresizesSubviews = YES;
	self.view = view;
	[view release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations.
	return YES;// (interfaceOrientation == UIInterfaceOrientationPortrait);
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
