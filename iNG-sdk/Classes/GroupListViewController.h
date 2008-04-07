//
//  GroupListViewController.h
//  iNG
//
//  Created by William Dietz on 4/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nntp_account.h"

@interface GroupListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	NNTPGroup * _subs;
	int _subs_count;//keeps track of length of above array
}

- (void) connect;

@end
