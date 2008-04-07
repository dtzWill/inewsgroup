//
//  AccountView.h
//  iNG
//
//  Created by William Dietz on 4/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * -------------------------
 *                          *
 *           iNG            *
 *        Will Dietz        *
 *                          *
 *          0.0.1           *
 *                          *
 *                          *
 *         Account:         *
 *        news.URL          *
 *                          *
 * ------------------------ *
 *
 */


@interface AccountView : UIView {
	UILabel * _iNG_label;
	UILabel * _author_label;
	UILabel * _version_label;
	UILabel * _account_label;
	UILabel * _server_label;
	UIButton * _connect;
	UIButton * _offline;
	id _delegate;
}

- (void) createSubviews;
- (void) resizeSubviewsWithFrame: (CGRect) frame;
- (void) setSubviewsText;

- (void) connectPressed;
- (void) offlinePressed;

- (void) setDelegate: (id) delegate;


@end
