//
//  GroupListViewController.m
//  iNG
//
//  Created by William Dietz on 4/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GroupListViewController.h"


@implementation GroupListViewController

- (id)init
{
	if (self = [super init]) {
		// Initialize your view controller.
		self.title = @"Groups";
	}
	return self;
}


- (void)loadView
{
	// Create a custom view hierarchy.
	UITableView *view = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	self.view = view;

	[ view setDelegate: self ];
	[ view setDataSource: self ];

	[view release];
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

- (void) reallyConnect: (NSTimer *) timer
{
	if ( [ [ nntp_account sharedInstance ] connect ] && [ [ nntp_account sharedInstance ] authenticate: NO ] )
	{
		NSLog( @"Connected!!" );
		[ [ nntp_account sharedInstance ] updateSubscribedGroups ];
		NSData * subs = [ [ nntp_account sharedInstance ] subscribedGroups ];
		_subs = (NNTPGroup *)[ subs bytes ];		
		_subs_count = [ subs length ] / sizeof( NNTPGroup );
		[ (UITableView *)self.view reloadData ];

	}
	else
	{
		NSLog( @"error connecting or auth!" );
	}

}

//TODO: viewWillAppear?
- (void)connect
{
	[ NSTimer scheduledTimerWithTimeInterval: (NSTimeInterval)0.1 target: self selector: @selector(reallyConnect:) userInfo: nil repeats: NO ];
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
	return _subs_count;//we only have 1 row, the account name
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
		//CGRect frame = CGRectMake(0, 0, 300, 44);
		CGRect frame = CGRectMake( 0, 0, 0, 0 );
		cell = [[[UISimpleTableViewCell alloc] initWithFrame:frame] autorelease];
		[ cell setAutoresizingMask: UIViewAutoresizingFlexibleWidth ]; 

		[ cell setAutoresizesSubviews: YES ];
	}
	cell.text = @"Account information goes here!";
	// Set up the text for the cell
	cell.text = [ NSString stringWithFormat: @"%s (%d)",
					_subs[ [ indexPath row ] ].name,
					_subs[ [ indexPath row ] ].high ];
	return cell;
}

@end
