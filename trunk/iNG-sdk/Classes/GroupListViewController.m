//
//  GroupListViewController.m
//  iNG
//
//  Created by William Dietz on 4/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GroupListViewController.h"

#import "NNTPAccount.h"


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
	if ( [ [ NNTPAccount sharedInstance ] connect ] && [ [ NNTPAccount sharedInstance ] authenticate: NO ] )
	{
		NSLog( @"Connected!!" );
		[ [ NNTPAccount sharedInstance ] updateSubscribedGroups ];
//		[ [ [ NNTPAccount sharedInstance ] subscribedGroups ];

	//	NSEnumerator * enumer = [ subs objectEnumerator ];
	//	NNTPGroupBasic * sub;
	//	while ( sub = [ enumer nextObject ] )
	//	{
	//		NSLog( sub.name );
	//	}

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
	if ( [ [ NNTPAccount sharedInstance ] subscribedGroups ] )
	{
		return [ [ [ NNTPAccount sharedInstance ] subscribedGroups ] count ];
	}
	else
	{
		return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	// Create a cell if necessary
	UITableViewCell * cell = [ (UITableView *)self.view dequeueReusableCellWithIdentifier: @"TableViewCell" ];
	if ( cell == nil)
	{
		CGRect frame = CGRectMake( 0, 0, 0, 0 );
		cell = [[UITableViewCell alloc] initWithFrame:frame reuseIdentifier: @"TableViewCell" ];
		[ cell setAutoresizingMask: UIViewAutoresizingFlexibleWidth ]; 

		[ cell setAutoresizesSubviews: YES ];
	}
	// Set up the text for the cell
	if ( [ indexPath row ] >= 0 && [ indexPath row ] < [ [ [ NNTPAccount sharedInstance ] subscribedGroups ] count ] )
	{
		NNTPGroupBasic * sub = [ [ [ NNTPAccount sharedInstance ] subscribedGroups ] objectAtIndex: [ indexPath row ]  ];
		NSLog( sub.name );
		cell.text = [ NSString stringWithFormat: @"%@ (%d)",
						sub.name,
						sub.high ];
	}
	else
	{
		cell.text = @"Invalid row!";
	}
	return cell;

}

@end
