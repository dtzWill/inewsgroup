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
	if (self = [super init])
	{
		// Initialize your view controller.
		self.title = @"Groups";
		_hasInitialized = false;
		
		UIBarButtonItem * subButton = [ [ UIBarButtonItem alloc ]
			initWithTitle: @"Manage"
					style: UIBarButtonItemStylePlain
				   target: self
				   action: @selector(showSubManager)];
		self.navigationItem.rightBarButtonItem = subButton;
		self.navigationItem.hidesBackButton = YES;

		_toolbar = [ [ UIToolbar alloc ] init ];
		_toolbar.barStyle = UIBarStyleDefault;
		[ _toolbar sizeToFit ];
		CGFloat toolbarHeight = 40.0f;
		[ _toolbar setFrame: CGRectMake( CGRectGetMinX( self.tableView.bounds ),
		 CGRectGetMinY( self.tableView.bounds ) + CGRectGetHeight( self.tableView.bounds ) - toolbarHeight,
		 CGRectGetWidth( self.tableView.bounds ), toolbarHeight )];
		[ self.parentViewController.view addSubview: _toolbar ];
	}

	return self;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations.
//	return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
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

- (void) reallyConnect
{
	if ( [ [ NNTPAccount sharedInstance ] connect ] )
	{
		//connected!
		NSLog( @"Connected! Now trying to auth..." );
		//now try to auth...
		if ( [ [ NNTPAccount sharedInstance ] authenticate: NO ] )
		{
			NSLog( @"Connected and Auth'd!!" );
			[ [ NNTPAccount sharedInstance ] updateSubscribedGroups ];
			[ [ NNTPAccount sharedInstance ] saveSubscribedGroups ];
			
			[ [ self tableView ] reloadData ];

		}
		else
		{
			NSLog( @"Auth failed!" );
		}
	}
	else
	{
		NSLog( @"Failed to connect!" );
	}
}

- (void)viewWillAppear: (bool) animated
{
	if ( !_hasInitialized )
	{
		_hasInitialized = true;
		[ self connect ];
	}
	else
	{
		[ [ NNTPAccount sharedInstance ] leaveGroup ];
	}
	[ self.tableView reloadData ];
}

- (void)connect
{
	[ NSThread detachNewThreadSelector: @selector(reallyConnect) toTarget: self withObjects: nil ];
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
		cell.text = [ NSString stringWithFormat: @"%d %@", sub.unreadCount, sub.name ];
	}
	else
	{
		cell.text = @"Invalid row!";
	}
	return cell;

}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{

	NNTPGroupBasic * sel = [ [ [ NNTPAccount sharedInstance ] subscribedGroups ] objectAtIndex: [ indexPath row ]  ];
	ArticleListViewController * alvc = [ [ [ ArticleListViewController alloc ] initWithGroupNamed: sel.name ] autorelease ];
	[ (UINavigationController *)self.parentViewController pushViewController: alvc animated: YES ];

}
    

@end
