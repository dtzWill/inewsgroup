//  
//  SubscriptionManagerViewController.h
//  iNG
//
//  Created by William Dietz on 4/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SubscriptionManagerViewController : UITableViewController <UISearchBarDelegate> {

	NSMutableArray * _groups;	//represents the groups we're looking at, possibly result of search filter
	UISearchBar * _search; //search bar ui element
	UIBarButtonItem * searchButton;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  searchPressed
 *  Description:  takes appropriate search-related action 
 * =====================================================================================
 */
- (void) searchPressed;

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  updateGroupListWithFilter
 *  Description:  applies specified filter
 * =====================================================================================
 */
- (void) updateGroupListWithFilter: (NSString *) filter;


- (void)closeSearchBar;


/*-----------------------------------------------------------------------------
 *  UISearchBarDelegate methods
 *-----------------------------------------------------------------------------*/

- (void) searchBarSearchButtonClicked: (UISearchBar *) searchBar;

- (void) searchBarCancelButtonClicked: (UISearchBar *) searchBar;


@end
