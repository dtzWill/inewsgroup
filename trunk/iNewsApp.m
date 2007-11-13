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
#import <UIKit/UIAlertSheet.h>
#import "iNewsApp.h"
//#import "NewsListView.h"
#import "newsfunctions.h"


@implementation iNewsApp

- (void) applicationDidFinishLaunching: (id) unused
{
	
	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin. x = rect.origin.y = 0;
	_window = [[UIWindow alloc] initWithContentRect: rect];

	_mainView = [[UIView alloc] initWithFrame: rect];
	[_window setContentView: _mainView];


	UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(
	    0.0f, 0.0f, 320.0f, 48.0f)];
	_titleItem = [ [UINavigationItem alloc] initWithTitle: @"iNewsGroup" ];
	[nav showButtonsWithLeftTitle: @"Prefs" rightTitle: @"Quit" leftBack: YES ]; 
	[nav pushNavigationItem: _titleItem];
	[nav setDelegate: self];	
	[nav setBarStyle: 0];



	
	init();

	_count = 0;//1;

	_connect = [[UIAlertSheet alloc]initWithTitle:@"Connecting..." buttons:nil defaultButtonIndex:1 delegate:self context:nil];
	
	[_connect setDimsBackground:YES];

//	NSLog( @"Subcribed to: %d\nTotal Groups: %d\n", numSubscribed(), numActive() );
	//build tree of current news.... and create views
//	root = [ [NewsListView alloc] initWithFrame: rect andDelegate: window ];

//	NSLog( @"Created views!" );

	_rows = [ [ NSMutableArray alloc] init ];
/*	int i;
	UIImageAndTextTableCell * row;
	row = [[UIImageAndTextTableCell alloc] init];
	[row setTitle: @"Connecting... (Please Wait)" ];
	[ _rows addObject : row ];
*/	
	[self connect ];

	_table = [[UITable alloc] initWithFrame: CGRectMake(0.0f, 48.0f,
	    320.0f, 480.0f - 16.0f - 48.0f)];
	UITableColumn *col = [[UITableColumn alloc] initWithTitle: @"subscribedgroups"
	    identifier: @"subscribedgroups" width: 320.0f];

	[_window orderFront: self];
	[_window makeKey: self];
	[_window _setHidden: NO];
	
	[_table addTableColumn: col]; 
	[_table setDataSource: self];
	[_table setDelegate: self];
	[_table reloadData];

	
 	smaller_font = [NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:12];


	
//	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
//	rect.origin.x = rect.origin.y = 0.0f;
	_prefs = [[PrefsView alloc] initWithFrame: rect];
	[_prefs setDelegate: self];
	
	_group = [[GroupView alloc] initWithFrame: rect];
	[_group setDelegate: self];

	_subs = [[SubscriptionView alloc] initWithFrame: rect];
	[_subs setDelegate: self];

	
	[_mainView addSubview:  nav ];
	[_mainView addSubview: _table ];

//	[window setContentView: root];
	NSLog( @"Done with applicationDidFinishLaunching" ); 
}


- (void)tableRowSelected:(NSNotification *)notification {
//  NSLog(@"tableRowSelected!");
	//build url....

	int groupnum = [_table selectedRow];
	if ( groupnum == [ _rows count] - 1 )//the more/less bar...
	{
		[ _subs loadSettings ];
		[ self setView : _subs ];
	}
	else
	{
		[ _group setGroupNum: groupnum ];
	
		[_window setContentView: _group ];
	
		[_group refreshMe ];
	}
}



//Methods to make table work...:
- (int) numberOfRowsInTable: (UITable *)table
{
	return  [ _rows count] ;
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

- (void) connect
{
	[_connect presentSheetInView: _mainView ];	 
    [NSTimer scheduledTimerWithTimeInterval: REFRESH_TIME target:self selector:@selector(delayedInit) userInfo:nil repeats:NO];	
//	NSLog( @" set timer....%d", self );

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

- (void) returnToMain
{
	
	[ self refreshTable ];//TODO: only do this when needed
	[ _window setContentView: _mainView ]; 
}

- (void) setView: (UIView *) view
{


	[ _window setContentView: view];

}


- (void) delayedInit
{
	if(	!init_server() )
	{//if fail.. just go to prefs page
		NSLog( @"connection failed... showing prefs view" );
		[ _window setContentView: _prefs];	
	}
	else
	{
//		readNewsRC();
		updateData();
		[self refreshTable ];
	}
	[ _connect dismiss ];
	[_prefs loadSettings ];
}

- (void) refreshTable
{
	_count = numSubscribed();
	if ( _rows)
		[_rows release ];//TODO: why not just empty it...?
	_rows = [ [ NSMutableArray alloc] init ];//TODO: why malloc /every/ time here??
	int i;
	UIImageAndTextTableCell * row;
	for( i=0; i < _count; i++ )
	{
		row = [[UIImageAndTextTableCell alloc] init];
		
		[row setTitle: [NSString stringWithFormat: @"%s%s",
			active[ my_group[i] ].newsrc.num_unread > 0 ? "*":" " , //put "*" if unread arts
			active[my_group[i]].name ] ];
		//[row addTarget:self action:@selector(go) ];

	//TODO: WHY DOESNT THIS WORK???
/*
		[row disclosureStyle: 2];
		[row showDisclosure: YES];
*/ 
		[ _rows addObject : row ];
	}


	row = [[UIImageAndTextTableCell alloc] init];
	[ row setTitle: @"Add/Remove"];
//	[ row setAlignment: 2 ];
	
	[_rows addObject: row ];	

	[ _table reloadData ];
}

- (void)navigationBar:(UINavigationBar*)bar buttonClicked:(int) which;
{
//	NSLog( @"button pressed, which: %d", which );
	if ( which == 0 ) //right
	{
		write_config_file(local_config_file);
		tin_done(EXIT_SUCCESS); //doesn't close the app gracefully.... o_O
		//TODO: close the app gracefully.
	}
	else
	{
		[ _window setContentView: _prefs];
		[_prefs setDelegate: self];

	}

}

@end

