//Will Dietz
//iNewsApp.m
// The heart of the application 
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UIThreePartButton.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UITable.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UITableColumn.h>
#import "iNewsApp.h"
//#import "NewsListView.h"
#import "newsfunctions.h"

@implementation iNewsApp

- (void) applicationDidFinishLaunching: (id) unused
{
	UIWindow *window;
	
	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin. x = rect.origin.y = 0;
	window = [[UIWindow alloc] initWithContentRect: rect];

	init();
	_count = 1;

	NSLog( @"Subcribed to: %d\nTotal Groups: %d\n", numSubscribed(), numActive() );
	//build tree of current news.... and create views
//	root = [ [NewsListView alloc] initWithFrame: rect andDelegate: window ];

//	NSLog( @"Created views!" );

	_rows = [ [ NSMutableArray alloc] init ];
	int i;
	UIImageAndTextTableCell * row;
	row = [[UIImageAndTextTableCell alloc] init];
	[row setTitle: @"Connecting... (Please Wait)" ];
	[ _rows addObject : row ];

    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(delayedInit) userInfo:nil repeats:NO];	

	_table = [[UITable alloc] initWithFrame: CGRectMake(0.0f, 48.0f,
	    320.0f, 480.0f - 16.0f - 32.0f)];
	UITableColumn *col = [[UITableColumn alloc] initWithTitle: @"subscribedgroups"
	    identifier: @"subscribedgroups" width: 320.0f];

	[window orderFront: self];
	[window makeKey: self];
	[window _setHidden: NO];
	
	[_table addTableColumn: col]; 
	[_table setDataSource: self];
	[_table setDelegate: self];
	[_table reloadData];

	
	UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(
	    0.0f, 0.0f, 320.0f, 48.0f)];
	_titleItem = [ [UINavigationItem alloc] initWithTitle: @"iNewsGroup" ];
	[nav showButtonsWithLeftTitle: @"Exit" rightTitle: nil leftBack: YES ]; 
	[nav pushNavigationItem: _titleItem];
	
	[nav setBarStyle: 0];

	
//	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
//	rect.origin.x = rect.origin.y = 0.0f;
	UIView *mainView;
	mainView = [[UIView alloc] initWithFrame: rect];

	[mainView addSubview:  nav ];
	[mainView addSubview: _table ];

	[window setContentView: mainView];
//	[window setContentView: root];
	NSLog( @"Done with applicationDidFinishLaunching" ); 
/*
	if ( init_server() )
	{
		NSLog( @"Subcribed to: %d\nTotal Groups: %d\n", numSubscribed(), numActive() );
		//[root refresh];
	}
	else
	{//error!
		NSLog( @"Error connecting. If this is your frist time using iNewsGroup make suer to set your user/pass/server correctly" );
	
	}
*/
/*
	init_server();
	readNewsRC();
	NSLog( @"Subcribed to: %d\nTotal Groups: %d\n", numSubscribed(), numActive() );

*/
}

/*
- (void)tableRowSelected:(NSNotification *)notification {
//  NSLog(@"tableRowSelected!");
	//build url....
	char url[200];
	strcpy( url, "maps:q=");//prefix
	strncat( url, uiucBuildings[[table selectedRow]].location, 200-strlen(url) );
	
	//go there!
	[self openURL:[[NSURL alloc] initFileURLWithPath:[NSString stringWithCString:url]]];
}
*/
//Methods to make table work...:
- (int) numberOfRowsInTable: (UITable *)table
{
	return  _count ;
}

- (UITableCell *) table: (UITable *)table cellForRow: (int)row column: (int)col
{
	return [_rows objectAtIndex: row];
}

- (UITableCell *) table: (UITable *)table cellForRow: (int)row column: (int)col
	reusing: (BOOL) reusing
{
	return [ _rows objectAtIndex: row]; 
}



- (void)dealloc {
	//TODO: MAKE THIS DO WHAT IT'S SUPPOSED TO  
      /*
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_path release];
	[_files release];
	[_extensions release];
	[_table release];
	_delegate = nil;
*/
	[super dealloc];

}
- (void) delayedInit
{
	init_server();
//	readNewsRC();
//	readNewsRC();
	updateData();
	[self refreshTable ];
}
- (void) refreshTable
{
	_count = numSubscribed();
	if ( _rows)
		[_rows release ];
	_rows = [ [ NSMutableArray alloc] init ];
	int i;
	UIImageAndTextTableCell * row;
	for( i=0; i < _count; i++ )
	{
		row = [[UIImageAndTextTableCell alloc] init];
		[row setTitle: [NSString stringWithCString:active[my_group[i]].name ] ];
		//[row addTarget:self action:@selector(go) ];

	//TODO: WHY DOESNT THIS WORK???
/*
		[row disclosureStyle: 2];
		[row showDisclosure: YES];
*/ 
		[ _rows addObject : row ];
	}
	[ _table reloadData ];
}

- (void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)which;
{
	if ( which == 1 ) //left
	{
		write_config_file(local_config_file);
		tin_done(EXIT_SUCCESS);
	}
	/*
	else
	{
		tinCheckForMessages();


	}
*/
}

@end

