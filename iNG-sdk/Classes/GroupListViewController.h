//
//  GroupListViewController.h
//  iNG
//
//  Created by William Dietz on 4/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NNTPGroupBasic.h"

@interface GroupListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

}

- (void) connect;

@end
