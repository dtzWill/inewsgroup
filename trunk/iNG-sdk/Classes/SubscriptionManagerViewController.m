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
		_groups = nil;
		if ( [ [ NNTPAccount sharedInstance ] isConnected ] )
		{
			_groups = [ [ NSMutableArray alloc ] initWithArray: [ [ NNTPAccount sharedInstance ] getGroupList: NO ] ]; 
		}

		searchButton = [ [ UIBarButtonItem alloc ]
			initWithTitle: @"Search"
					style: UIBarButtonItemStylePlain
				   target: self
				   action: @selector(searchPressed)];
		self.navigationItem.rightBarButtonItem = searchButton;
		
		int height = 43;
		_search = [ [ UISearchBar alloc ] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, height ) ];
		_search.delegate = self;
		_search.showsCancelButton = YES;
	}
	return self;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  searchPressed
 *  Description:  takes appropriate search-related action 
 * =====================================================================================
 */
- (void) searchPressed
{
	self.navigationItem.rightBarButtonItem = nil;
	self.navigationItem.titleView = _search;
	self.navigationItem.hidesBackButton = YES;

	_search.showsCancelButton = YES;
	
	[ ((UITextField *)[ _search.subviews objectAtIndex: 0 ]) becomeFirstResponder ];

}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  updateGroupListWithFilter
 *  Description:  applies specified filter
 * =====================================================================================
 */
- (void) updateGroupListWithFilter: (NSString *) filter
{
	[ _groups release ];
	if ( [ filter compare: @"" ] == NSOrderedSame )
	{
		_groups = [ [ NSMutableArray alloc ] initWithArray: [ [ NNTPAccount sharedInstance ] getGroupList: NO ] ];
	}
	else
	{
		_groups = [ [ NSMutableArray alloc ] init ];
		for ( NSString * group in [ [ NNTPAccount sharedInstance ] getGroupList: NO ] )
		{
			if ( [ group rangeOfString: filter options: NSCaseInsensitiveSearch ].location != NSNotFound )
			{
				[ _groups addObject: group ];
			}
		}

	}

	[ self.tableView reloadData ];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview.
	// Release anything that's not essential, such as cached data.
}

- (void)dealloc
{
	[super dealloc];
	[ _groups release ];
	[ _search release ];
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
	if ( _groups )
	{
		return [ _groups count ];
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
	if ( [ indexPath row ] >= 0 && [ indexPath row ] < [ _groups count ] )
	{
		cell.text = [ _groups objectAtIndex: [ indexPath row ] ];
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

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{

	NSString * group = [ _groups objectAtIndex: [ indexPath row ] ];
	if ( [ [ NNTPAccount sharedInstance ] isSubscribedTo: group ] )
	{
		[ [ NNTPAccount sharedInstance ] unsubscribeFrom: group ];
	}
	else
	{
		[ [ NNTPAccount sharedInstance ] subscribeTo: group ];
	}

	[ self.tableView reloadData ];
//	NNTPGroupBasic * sel = [ [ [ NNTPAccount sharedInstance ] subscribedGroups ] objectAtIndex: [ indexPath row ]  ];
//	ArticleListViewController * alvc = [ [ [ ArticleListViewController alloc ] initWithGroupNamed: sel.name ] autorelease ];
//	[ (UINavigationController *)self.parentViewController pushViewController: alvc animated: YES ];

}

- (void) viewWillDisappear: (bool) animated
{
	//XXX do this in a different thread of a different place....!
	[ [ NNTPAccount sharedInstance ] updateSubscribedGroups ];	

}

- (void) closeSearchBar
{
	self.navigationItem.titleView = nil;
	self.navigationItem.hidesBackButton = NO;
	self.navigationItem.rightBarButtonItem = searchButton;
}

/*-----------------------------------------------------------------------------
 *  UISearchBarDelegate methods
 *-----------------------------------------------------------------------------*/

- (void) searchBarSearchButtonClicked: (UISearchBar *) searchBar
{
	[ self closeSearchBar ];

	[ self updateGroupListWithFilter: _search.text ];
}

- (void) searchBarCancelButtonClicked: (UISearchBar *) searchBar
{
	[ self closeSearchBar ];

	[ self updateGroupListWithFilter: @"" ];
}

@end
