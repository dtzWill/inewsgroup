//
//  ArticleListViewController.h
//  iNG
//
//  Created by William Dietz on 4/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ArticleListViewController : UITableViewController {
	NSString * _groupname;
	bool _hasInitialized;

}

- (ArticleListViewController *) initWithGroupNamed: (NSString *) groupname;


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  refresh
 *  Description:  Gets the headers (launches a new thread to handle it)
 * =====================================================================================
 */
- (void) refresh;

@end
