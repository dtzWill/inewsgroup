//
//  AccountViewController.h
//  iNG
//
//  Created by Will Dietz on 3/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nntp_account.h"

@interface AccountViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {

	nntp_account * _account;//just one for now :)
	NNTPGroup * _subs;//just a pointer to make things easier
	int _subs_count;//length of above array

}

@end
