//
//  AccountViewController.m
//  iNG
//
//  Created by Will Dietz on 3/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AccountViewController.h"


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
	UITableView *view = [ [ UITableView alloc ] initWithFrame:[ UIScreen mainScreen ].applicationFrame ];
	self.view = view;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;

	[ view setDelegate: self ];
	[ view setDataSource: self ];

	//create account
	_account = [ nntp_account sharedInstance ];
	

	if ( [ _account connect ] && [ _account authenticate: NO ] )
	{
		NSLog( @"Connected!!" );
		[ _account updateSubscribedGroups ];
		NSData * subs = [ _account subscribedGroups ];
		_subs = (NNTPGroup *)[ subs bytes ];		
		_subs_count = [ subs length ] / sizeof( NNTPGroup );

	}
	else
	{
		NSLog( @"error connecting or auth!" );
	}

	[ view reloadData ];

	[ view release ];
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
	//[ view release ];
//	[ _subs release ];
	
	[ _account release ];

	[super dealloc];
}

- (void) didRotateFromInterfaceOrientation: (UIInterfaceOrientation) orientation{
	//NSLog( @"Rotated!" );
	
	/* if we have less rows than shown, I can't seem
	 * to figure out how one is supposed to get the
	 * non-content-containing cells to resize, since they
	 * aren't created by us.
	 * So here we reload the data, which has the desired effect.
	 */
	
	[ (UITable *)self.view reloadData ];
}

/*-----------------------------------------------------------------------------
 *  Table delegate methods: (data source and delegate )
 *-----------------------------------------------------------------------------*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Only one section
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _subs_count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withAvailableCell:(UITableViewCell *)availableCell
{
	// Create a cell if necessary
	UISimpleTableViewCell * cell = nil;
	if (availableCell != nil)
	{
		cell = (UISimpleTableViewCell *)availableCell;
	}
	else
	{
		CGRect frame = CGRectMake(0, 0, 300, 44);
		cell = [[[UISimpleTableViewCell alloc] initWithFrame:frame] autorelease];
		[ cell setAutoresizingMask: UIViewAutoresizingFlexibleWidth ]; 

	}
	// Set up the text for the cell
	cell.text = [ NSString stringWithFormat: @"%s (%d)",
					_subs[ [ indexPath row ] ].name,
					_subs[ [ indexPath row ] ].count ];
	return cell;
}
@end
