//
//  GroupListViewController.m
//  iNG
//
//  Created by William Dietz on 4/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GroupListViewController.h"

#import "NNTPAccount.h"
#import "ArticleListViewController.h"
#import "SubscriptionManagerViewController.h"


@implementation GroupListViewController

- (id)init
{
	if (self = [super init]) {
		// Initialize your view controller.
		self.title = @"Groups";
		_hasInitialized = false;
		UIButton * subButton = [ UIButton buttonWithType: UIButtonTypeNavigation ];
		[ subButton setTitle: @"Manage" forState: UIControlStateNormal ];
		[ subButton addTarget: self action: @selector(showSubManager) forControlEvents: UIControlEventTouchUpInside ];
		self.navigationItem.customRightView = subButton;
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

- (void) reallyConnect: (NSTimer *) timer
{
	if ( [ [ NNTPAccount sharedInstance ] connect ] && [ [ NNTPAccount sharedInstance ] authenticate: NO ] )
	{
		NSLog( @"Connected!!" );
		[ [ NNTPAccount sharedInstance ] updateSubscribedGroups ];
		
		[ [ self tableView ] reloadData ];


	}
	else
	{
		NSLog( @"error connecting or auth!" );
	}

}

- (void)viewWillAppear: (bool) animated
{
	if ( !_hasInitialized )
	{
		_hasInitialized = true;
		[ self connect ];
	}
	[ self.tableView reloadData ];
}

- (void)connect
{
	//ouch :(
	[ NSTimer scheduledTimerWithTimeInterval: (NSTimeInterval)0.01 target: self selector: @selector(reallyConnect:) userInfo: nil repeats: NO ];
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  showSubManager
 *  Description:  transitation to the subscription manager view
 * =====================================================================================
 */
- (void) showSubManager
{
	SubscriptionManagerViewController * smvc = [ [ [ SubscriptionManagerViewController alloc ] init ] autorelease ];
	[ (UINavigationController *)self.parentViewController pushViewController: smvc animated: YES ];

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
		[ [ NNTPAccount sharedInstance ] subscribedGroups ] )
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
	UITableViewCell * cell = [ self.tableView dequeueReusableCellWithIdentifier: @"GroupListViewCell" ];
	if ( cell == nil)
	{
		cell = [ [ [UITableViewCell alloc] initWithFrame: CGRectZero reuseIdentifier: @"GroupListViewCell" ] autorelease ];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	// Set up the text for the cell
	if ( [ indexPath row ] >= 0 && [ indexPath row ] < [ [ [ NNTPAccount sharedInstance ] subscribedGroups ] count ] )
	{
		NNTPGroupBasic * sub = [ [ [ NNTPAccount sharedInstance ] subscribedGroups ] objectAtIndex: [ indexPath row ]  ];
		//XXX: Change this to show group and number of unread in parens (possibly gray text)
		cell.text = sub.name;
	}
	else
	{
		cell.text = @"Invalid row!";
	}
	return cell;

}

- (void) tableView: (UITableView *) tableView selectionDidChangeToIndexPath: (NSIndexPath *) newIndexPath fromIndexPath: (NSIndexPath *) oldIndexPath
{

	NNTPGroupBasic * sel = [ [ [ NNTPAccount sharedInstance ] subscribedGroups ] objectAtIndex: [ newIndexPath row ]  ];
	ArticleListViewController * alvc = [ [ [ ArticleListViewController alloc ] initWithGroupNamed: sel.name ] autorelease ];
	[ (UINavigationController *)self.parentViewController pushViewController: alvc animated: YES ];

}
    

@end
