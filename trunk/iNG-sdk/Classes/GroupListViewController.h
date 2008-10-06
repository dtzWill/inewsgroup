//
//  GroupListViewController.h
//  iNG
//
//  Created by William Dietz on 4/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NNTPGroupBasic.h"

@interface GroupListViewController : UITableViewController<UIAlertViewDelegate> {

	bool _hasInitialized;
	UIToolbar * _toolbar;

	UIAlertView * _alert;
	UIAlertView * _errorAlert;
}

- (void) connect;


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  showSubManager
 *  Description:  transitation to the subscription manager view
 * =====================================================================================
 */
- (void) showSubManager;

@end
