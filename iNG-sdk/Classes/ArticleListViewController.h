//
//  ArticleListViewController.h
//  iNG
//
//  Created by William Dietz on 4/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NNTPArticle.h"


@interface ArticleListViewController : UITableViewController {
	NSString * _groupname;
	bool _hasInitialized;
	UIImage * _unreadImage;
	UIImage * _readImage;
	UIAlertView * _alert;

}

- (ArticleListViewController *) initWithGroupNamed: (NSString *) groupname;

- (NNTPArticle *) getArtForIndexPath: ( NSIndexPath * ) indexPath;

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  refresh
 *  Description:  Gets the headers (launches a new thread to handle it)
 * =====================================================================================
 */
- (void) refresh;

@end
