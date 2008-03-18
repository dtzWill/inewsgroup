//
//  StartView.h
//  iNG
//
//  Created by Will Dietz on 3/16/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

#import "nntp_account.h"

@interface StartView : UIView {
	UITableView * _table;//table of accounts ( for now, just one, but that's not the point )
	nntp_account * _account;//just one for now :)
	NNTPGroup * _subs;//just a pointer to make things easier
	int _subs_count;//length of above array
}

- (void) loadView;


/*-----------------------------------------------------------------------------
 *  Table delegate methods: (data source and delegate )
 *-----------------------------------------------------------------------------*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withAvailableCell:(UITableViewCell *)availableCell;
@end
