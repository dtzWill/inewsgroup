//
//  StartView.m
//  iNG
//
//  Created by Will Dietz on 3/16/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "StartView.h"
#import "ViewController.h"

#import "nntp_account.h"

@implementation StartView

- (void) loadView
{
	_table = [ [UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];

//	UITableColumn *col = [[UITableColumn alloc] initWithTitle: @"accounts"
//		identifier: @"accounts" width: 320.0f];

	
	[ _table setDelegate: self ];
	[ _table setDataSource: self ];

	[ self addSubview: _table ];
	_account = [ [ nntp_account alloc ] init ];
	//put actual auth information here! (obviously this is just for testing)
	[ _account setServer: @"news.cs.uiuc.edu" ];
	[ _account setPort: 119 ];
	[ _account setUser: @"" ];
	[ _account setPassword: @"" ];

	if ( [ _account connect ] && [ _account authenticate: NO ] )
	{
		NSLog( @"Connected!!" );
		[ _account updateSubscribedGroups ];
		NSData * subs = [ _account subscribedGroups ];
		_subs = (NNTPGroup *)[ subs bytes ];		
		_subs_count = [ subs length ] / sizeof( NNTPGroup );

	}
	else
	{
		NSLog( @"error connecting or auth!" );
	}
	[ _table reloadData ];
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
	return _subs_count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withAvailableCell:(UITableViewCell *)availableCell
{
	// Create a cell if necessary
	UISimpleTableViewCell * cell = nil;
	if (availableCell != nil)
	{
		cell = (UISimpleTableViewCell *)availableCell;
	}
	else
	{
		CGRect frame = CGRectMake(0, 0, 300, 44);
		cell = [[[UISimpleTableViewCell alloc] initWithFrame:frame] autorelease];
	}
	// Set up the text for the cell
	cell.text = [ NSString stringWithFormat: @"%s: %d-%d (%d)",
					_subs[ [ indexPath row ] ].name,
					_subs[ [ indexPath row ] ].low,
					_subs[ [ indexPath row ] ].high,
					_subs[ [ indexPath row ] ].count ];
	return cell;
}

@end
