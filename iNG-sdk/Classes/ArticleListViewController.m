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

#import "ArticleViewController.h"

@implementation ArticleListViewController

- (ArticleListViewController *)initWithGroupNamed: (NSString *) groupname;
{
	if (self = [super init]) {
		// Initialize your view controller.
		_groupname = [ [ NSString stringWithString: groupname ] retain ];
		self.title = [ _groupname retain ];//XXX???
		_hasInitialized = false;
		_unreadImage = [ [ UIImage alloc ] initWithContentsOfFile: [ [ NSBundle mainBundle ] pathForResource: @"UnreadIndicator" ofType: @"png" ] ];
		NSString * readPath = [ [ NSBundle mainBundle ] pathForResource: @"ReadIndicator" ofType: @"png" ];
		NSLog( @"Read path: %@", readPath );
		_readImage = [ [ UIImage alloc ] initWithContentsOfFile: readPath ];

		_alert = [[UIAlertView alloc] initWithTitle: @"Loading..."
												   message: @"Please wait..."
												  delegate: nil
										 cancelButtonTitle: nil
										 otherButtonTitles: nil];
		
		UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		activityView.frame = CGRectMake(139.0f-18.0f, 80.0f, 37.0f, 37.0f);
		[ _alert addSubview:activityView];
		//XXX: does the following have a bad effect?
		[activityView startAnimating];

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
	[ _unreadImage release ];
	[ _readImage release ];
	[ _alert release ];
}

- (void)viewWillAppear: (bool) animated
{
	if ( !_hasInitialized )
	{
		_hasInitialized = true;
		[ self refresh ];
	}
	[ self.tableView reloadData ];
	[ [ NNTPAccount sharedInstance ] updateGroupUnread ];
}

- (void) reallyRefresh: (NSTimer *) timer
{
	[ [ NNTPAccount sharedInstance ] setGroupAndFetchHeaders: _groupname ];
	[ self.tableView reloadData ];
	[ _alert dismiss ];

}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  refresh
 *  Description:  Gets the headers (launches a new thread to handle it)
 * =====================================================================================
 */
- (void) refresh
{
	[ _alert show ];
	[ self.tableView reloadData ];
	[ NSTimer scheduledTimerWithTimeInterval: (NSTimeInterval)0.01 target: self selector: @selector( reallyRefresh: ) userInfo: nil repeats: NO ];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations.
//	return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
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

- (NNTPArticle *) getArtForIndexPath: ( NSIndexPath * ) indexPath
{
	//TODO change this logic based on a setting
	NSArray * arts = [ [ NNTPAccount sharedInstance ] getArts ];
	if ( arts )
	{
		return [ arts objectAtIndex: ( [ arts count ] - [ indexPath row ] -1 ) ];
	}
	//else
	return nil;
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
	// if (  [ [ NNTPAccount sharedInstance ] getArts ] && [ indexPath row ] >= 0 && [ indexPath row ] < [ [ [ NNTPAccount sharedInstance ] getArts ] count ] )
	{
		NNTPArticle * art = [ self getArtForIndexPath: indexPath ];
		[ cell useArticle: art ];
	//	cell.text = art.subject;
		cell.image = art.read ? _readImage : _unreadImage; 
	}
//	else
//	{
//		cell.text = @"Invalid row!";
//	}
	return cell;

}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{

	NNTPArticle * art = [ self getArtForIndexPath: indexPath ];
	ArticleViewController * alvc = [ [ [ ArticleViewController alloc ] initWithArt: art  ] autorelease ];
	[ (UINavigationController *)self.parentViewController pushViewController: alvc animated: YES ];

}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
	return 70;
}

@end
