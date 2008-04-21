//
//  SubscriptionManagerViewController.m
//  iNG
//
//  Created by William Dietz on 4/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SubscriptionManagerViewController.h"

#import "NNTPAccount.h"


@implementation SubscriptionManagerViewController

- (id)init
{
	if (self = [super init]) {
		// Initialize your view controller.
		self.title = @"Subscriptions";
	}
	return self;
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
	if ( [ [ NNTPAccount sharedInstance ] isConnected ] &&
			[ [ NNTPAccount sharedInstance ] getGroupList: NO ] )
	{
		return [ [ [ NNTPAccount sharedInstance ] getGroupList: NO ] count ];
	}
	else
	{
		return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	// Create a cell if necessary
	UITableViewCell * cell = [ self.tableView dequeueReusableCellWithIdentifier: @"SubViewCell" ];
	if ( cell == nil)
	{
		cell = [ [ [UITableViewCell alloc] initWithFrame: CGRectZero reuseIdentifier: @"SubViewCell" ] autorelease ];
	}
	//
	// Set up the text for the cell
	if ( [ indexPath row ] >= 0 && [ indexPath row ] < [ [ [ NNTPAccount sharedInstance ] getGroupList: NO ] count ] )
	{
		cell.text = [ [ [ NNTPAccount sharedInstance ] getGroupList: NO ] objectAtIndex: [ indexPath row ] ];
		if ( [ [ NNTPAccount sharedInstance ] isSubscribedTo: cell.text ] )
		{
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
		else
		{
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	else
	{
		cell.text = @"Invalid row!";
	}
	return cell;

}

- (void) tableView: (UITableView *) tableView selectionDidChangeToIndexPath: (NSIndexPath *) newIndexPath fromIndexPath: (NSIndexPath *) oldIndexPath
{

	NSString * group = [ [ [ NNTPAccount sharedInstance ] getGroupList: NO ] objectAtIndex: [ newIndexPath row ] ];
	if ( [ [ NNTPAccount sharedInstance ] isSubscribedTo: group ] )
	{
		[ [ NNTPAccount sharedInstance ] unsubscribeFrom: group ];
	}
	else
	{
		[ [ NNTPAccount sharedInstance ] subscribeTo: group ];
	}

	[ self.tableView reloadData ];
//	NNTPGroupBasic * sel = [ [ [ NNTPAccount sharedInstance ] subscribedGroups ] objectAtIndex: [ newIndexPath row ]  ];
//	ArticleListViewController * alvc = [ [ [ ArticleListViewController alloc ] initWithGroupNamed: sel.name ] autorelease ];
//	[ (UINavigationController *)self.parentViewController pushViewController: alvc animated: YES ];

}

- (void) viewWillDisappear: (bool) animated
{
	//XXX do this in a different thread of a different place....!
	[ [ NNTPAccount sharedInstance ] updateSubscribedGroups ];	

}

@end
