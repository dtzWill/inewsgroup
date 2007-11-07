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

@implementation iNewsApp

- (void) applicationDidFinishLaunching: (id) unused
{
	UIWindow *window;
	
	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin. x = rect.origin.y = 0;
	window = [[UIWindow alloc] initWithContentRect: rect];

	//build tree of current news.... and create views
//	root = [ [NewsListView alloc] initWithFrame: rect withRoot: NEWSROOT andDelegate: window ];

//	NSLog( @"Created views!" );
/*
	rows = [ [ NSMutableArray alloc] init ];
	int i;
	UIImageAndTextTableCell * row;
	for( i=0; i< BUILDING_COUNT; i++ )
	{
		row = [[UIImageAndTextTableCell alloc] init];
		[row setTitle: [NSString stringWithCString:uiucBuildings[i].name ] ];
		//[row addTarget:self action:@selector(go) ]; 
		[ rows addObject : row ];
	}
	
	table = [[UITable alloc] initWithFrame: CGRectMake(0.0f, 48.0f,
	    320.0f, 480.0f - 16.0f - 32.0f)];
	UITableColumn *col = [[UITableColumn alloc] initWithTitle: @"buildings"
	    identifier: @"buildings" width: 320.0f];
*/	
	[window orderFront: self];
	[window makeKey: self];
	[window _setHidden: NO];
/*	
	[table addTableColumn: col]; 
	[table setDataSource: self];
	[table setDelegate: self];
	[table reloadData];
*/
/*	
	UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(
	    0.0f, 0.0f, 320.0f, 48.0f)];
	titleItem = [ [UINavigationItem alloc] initWithTitle: @"UIUC Buildings" ];
	[nav pushNavigationItem: titleItem];
	
	[nav setBarStyle: 0];
*/
/*	
	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;
	UIView *mainView;
	mainView = [[UIView alloc] initWithFrame: rect];
*/

//	[window setContentView: root];
//	NSLog( @"Done with applicationDidFinishLaunching" ); 
	
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

@end

