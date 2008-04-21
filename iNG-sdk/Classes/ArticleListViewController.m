//
//  ArticleListViewController.m
//  iNG
//
//  Created by William Dietz on 4/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ArticleListViewController.h"

#import "NNTPAccount.h"
#import "NNTPArticle.h"
#import "ArticleCell.h"

@implementation ArticleListViewController

- (ArticleListViewController *)initWithGroupNamed: (NSString *) groupname;
{
	if (self = [super init]) {
		// Initialize your view controller.
		_groupname = [ [ NSString stringWithString: groupname ] retain ];
		self.title = [ _groupname retain ];//XXX???
	}
	return self;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview.
	// Release anything that's not essential, such as cached data.
}

- (void)dealloc
{
	[super dealloc];
	[ _groupname release ];
}

- (void)viewWillAppear: (bool) animated
{
	[ self refresh ];
}

- (void) reallyRefresh: (NSTimer *) timer
{
	[ [ NNTPAccount sharedInstance ] setGroupAndFetchHeaders: _groupname ];
	[ self.tableView reloadData ];

}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  refresh
 *  Description:  Gets the headers (launches a new thread to handle it)
 * =====================================================================================
 */
- (void) refresh
{
	//ouch :(
	[ [ NNTPAccount sharedInstance ] leaveGroup ];
	[ self.tableView reloadData ];
	[ NSTimer scheduledTimerWithTimeInterval: (NSTimeInterval)0.01 target: self selector: @selector(reallyRefresh:) userInfo: nil repeats: NO ];
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
	NSArray * arts = [ [ NNTPAccount sharedInstance ] getArts ];
	if ( arts )
	{
		return [ arts count ];
	}
	//else
	
	return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	// Create a cell if necessary
	ArticleCell * cell = (ArticleCell *)[ self.tableView dequeueReusableCellWithIdentifier: @"ArticleCell" ];
	if ( cell == nil)
	{
		cell = [ [ [ ArticleCell alloc] initWithFrame: CGRectZero reuseIdentifier: @"ArticleCell" ] autorelease ];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	// Set up the text for the cell
//	if ( [ indexPath row ] >= 0 && [ indexPath row ] < [ [ [ NNTPAccount sharedInstance ] getArts ] count ] )
	{
		NNTPArticle * art = [ [ [ NNTPAccount sharedInstance ] getArts ] objectAtIndex: [ indexPath row ] ]; 
	//	[ cell useArticle: art ];
		cell.text = art.subject;
	}
//	else
//	{
//		cell.text = @"Invalid row!";
//	}
	return cell;

}

- (void) tableView: (UITableView *) tableView selectionDidChangeToIndexPath: (NSIndexPath *) newIndexPath fromIndexPath: (NSIndexPath *) oldIndexPath
{

//	NNTPGroupBasic * sel = [ [ [ NNTPAccount sharedInstance ] subscribedGroups ] objectAtIndex: [ newIndexPath row ]  ];
//	ArticleListViewController * alvc = [ [ [ ArticleListViewController alloc ] initWithGroupNamed: sel.name ] autorelease ];
//	[ (UINavigationController *)self.parentViewController pushViewController: alvc animated: YES ];
//
}
@end
