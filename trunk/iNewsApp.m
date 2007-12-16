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
#import <GraphicsServices/GraphicsServices.h>
#import "iNewsApp.h"
#import "newsfunctions.h"

@implementation iNewsApp

- (void) applicationDidFinishLaunching: (id) unused
{
	
	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin. x = rect.origin.y = 0;
	_window = [[UIWindow alloc] initWithContentRect: rect];

	_mainView = [[UIView alloc] initWithFrame: rect];
	[_window setContentView: _mainView];

	[_window orderFront: self];
	[_window makeKey: self];
	[_window _setHidden: NO];


	//top navigation bar.
	_navTop = [[UINavigationBar alloc] initWithFrame: CGRectMake(
	    0.0f, 0.0f, 320.0f, 48.0f)];
	_titleItem = [ [UINavigationItem alloc] initWithTitle: @"iNewsGroup" ];
	[_navTop showButtonsWithLeftTitle: @"Prefs" rightTitle: @"Quit" leftBack: YES ]; 
	[_navTop pushNavigationItem: _titleItem];
	[_navTop setDelegate: self];	
	[_navTop setBarStyle: 3];

	//bottom bar:
	_selectedRow = -1; //invalid
	//create buttons...
    NSDictionary *btnSubs = [NSDictionary dictionaryWithObjectsAndKeys:
            //self, kUIButtonBarButtonTarget,
            @"buttonBarItemTapped:", kUIButtonBarButtonAction,
            [NSNumber numberWithUnsignedInt:1], kUIButtonBarButtonTag,
            [NSNumber numberWithUnsignedInt:3], kUIButtonBarButtonStyle,
            [NSNumber numberWithUnsignedInt:1], kUIButtonBarButtonType,
            @"Subscriptions...", kUIButtonBarButtonInfo,
            nil
    ];

    NSDictionary *btnMarkRead = [NSDictionary dictionaryWithObjectsAndKeys:
            //self, kUIButtonBarButtonTarget,
            @"buttonBarItemTapped:", kUIButtonBarButtonAction,
            [NSNumber numberWithUnsignedInt:2], kUIButtonBarButtonTag,
            [NSNumber numberWithUnsignedInt:3], kUIButtonBarButtonStyle,
            [NSNumber numberWithUnsignedInt:1], kUIButtonBarButtonType,
            @"Mark Read", kUIButtonBarButtonInfo,
            nil
    ];

	NSArray *items = [NSArray arrayWithObjects:btnSubs,btnMarkRead, nil];
	UIButtonBar *buttonBar = [[UIButtonBar alloc] initInView: _mainView withFrame:CGRectMake(0.0f, 480.0f-16.0f-48.0f, 320.0f, 48.0f) withItemList:items];
	
	int buttons[2] = { 1, 2,};
	[buttonBar registerButtonGroup:1 withButtons:buttons withCount:2];
	[buttonBar showButtonGroup:1 withDuration:0.];
	[buttonBar setDelegate: self];
//    [buttonBar setBarStyle:2];
    [buttonBar setButtonBarTrackingMode: 2];

	[ [ buttonBar viewWithTag: 2 ]//2='mark read' button
            setFrame:CGRectMake( 320.0f	-80.0f, 0.0f, 64.0f, 48.0f) //right-align
        ]; 



	NSLog(@"initing...");
	
	init();
	
	NSLog(@"done with init");

	_count = 0;//1;

	_connect = [[UIAlertSheet alloc]initWithTitle:@"Connecting..." buttons:nil defaultButtonIndex:1 delegate:self context:self];
	[_connect setDimsBackground: YES];

	_rows = [ [ NSMutableArray alloc] init ];

	[self connect ];

	_table = [[UITable alloc] initWithFrame: CGRectMake(0.0f, 48.0f,
	    320.0f, 480.0f - 16.0f - 48.0f*2 )];
	UITableColumn *col = [[UITableColumn alloc] initWithTitle: @"subscribedgroups"
	    identifier: @"subscribedgroups" width: 320.0f];

	
	[_table addTableColumn: col]; 
	[_table setDataSource: self];
	[_table setDelegate: self];
	[_table reloadData];


	//initialize other views...
	_prefs = [[PrefsView alloc] initWithFrame: rect];
	[_prefs setDelegate: self];
	
	_group = [[GroupView alloc] initWithFrame: rect];
	[_group setDelegate: self];

	_subs = [[SubscriptionView alloc] initWithFrame: rect];
	[_subs setDelegate: self];

	
	[_mainView addSubview:  _navTop ];
	[_mainView addSubview: _table ];
	[_mainView addSubview: buttonBar ];

//	[window setContentView: root];
	NSLog( @"Done with applicationDidFinishLaunching" ); 
}


- (void)tableRowSelected:(NSNotification *)notification {
//  NSLog(@"tableRowSelected!");
	//don't do anything, actions are taken via the buttonbar
	_selectedRow = [_table selectedRow];
/*
	int groupnum = [_table selectedRow];
	if ( groupnum == [ _rows count] - 1 )//the more/less bar...
	{
		NSLog( @"loading sub settings" );
		[ _subs loadSettings ];
		NSLog( @"showing subs" );
		[ self setView : _subs ];
	}
	else
	{
		[ _group setGroupNum: groupnum ];
	
		[_window setContentView: _group ];
	
		[_group refreshMe ];
	}
*/
}

//handle various buttons:
- (void)buttonBarItemTapped:(id) sender {
	int button = [ sender tag ];
	switch (button) {
		case 1://subscription manager
			NSLog( @"showing subs" );
			[ self setView : _subs ];

			NSLog( @"loading sub settings" );
			[ self saveConfig ];//commit it to the newsrc, b/c subs might change it, then reload, losing all data (namely read/unread status)
			[ _subs refreshMe ];
		
			break;

        case 2://mark selected group read
			if( _selectedRow >= 0 )
			{
				markGroupRead( _selectedRow );	
				[ self refreshTable ];
			}
			break;
     /*   case 3://view articles in selected group
			if( _selectedRow >= 0 ) //if valid group number
			{
				[ _group setGroupNum: _selectedRow ];
		
				[_window setContentView: _group ];
		
				[_group refreshMe ];
			}
			break;
*/
	}
   
}

- (BOOL)respondsToSelector:(SEL)aSelector {
//    NSLog(@"respondsToSelector: %@", NSStringFromSelector(aSelector));
    return [super respondsToSelector: aSelector];
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
//	[ _connect setBlocksInteraction: NO ];
//	[ _connect setRunsModal: NO ];
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
	[self performSelectorOnMainThread: @selector(delayedInitSel) withObject: nil waitUntilDone: YES];
}

- (void) delayedInitSel
{
	if(	!init_server() )
	{//if fail.. just go to prefs page
		NSLog( @"connection failed... showing prefs view" );
		[ _window setContentView: _prefs];	
	}
	else
	{
//		readNewsRC();
		[NSTimer scheduledTimerWithTimeInterval: SAVE_TIME target:self selector:@selector(saveConfig) userInfo:nil repeats:YES];	
		updateData();
		[self refreshTable ];
		//TODO: set timer to fire every X seconds, saving the newsrc, as follows:
		//write_config_file(local_config_file);
		//long sessions would benefit greatly from this, and it's rather cheap :)
	}
//	[[MessageController sharedInstance] sheetClosed ];
	[ _connect dismiss ];
	[_prefs loadSettings ];
}

- (void) saveConfig
{
	saveNews();
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
		
	/*	[row setTitle: [NSString stringWithFormat: @"%s%s",
			active[ my_group[i] ].newsrc.num_unread > 0 ? "*":" " , //put "*" if unread arts
			active[my_group[i]].name ] ];*/

		bool unread = active[ my_group[i] ].newsrc.num_unread > 0 ;
		UIImage * img = [UIImage applicationImageNamed:
				unread ? @"UnreadIndicator.png" : @"ReadIndicator.png" ];  

		[ row setTitle: [NSString stringWithCString: active[ my_group[i] ].name ] ];

		[ row setImage: img ];

		[ [row titleTextLabel ] setFont: GSFontCreateWithName("Helvetica", kGSFontTraitBold,15) ];

		[ row setDisclosureStyle: 1 ]; //BLUE
		[row setShowDisclosure: YES];
		[row setDisclosureClickable: YES];
 
//		[ row setTapDelegate: self ];
		[ [ row _disclosureView ] setTapDelegate: self ];
		[ _rows addObject : row ];
	}


	[ _table reloadData ];
}

- (void)view:(UIView *)view handleTapWithCount:(int)count event:(GSEvent *)event {
//This should only be called from the disclosures of the rows!

  /* //DEBUG:
	CGRect rect = GSEventGetLocationInWindow(event);
	CGPoint point = rect.origin;
	NSLog(@"view:%@ handleTapWithCount:%i event:(point.x=%f, point.y=%f)",view, count, point.x, point.y);
	NSLog( @"clicked on: %@", [ [_rows objectAtIndex: _selectedRow ] title ] );
*/

	//disclosure clicked on..... go there!
	if( _selectedRow >= 0 ) //if valid group number
	{
		[ _group setGroupNum: _selectedRow ];
	
		[_window setContentView: _group ];
	
		[_group refreshMe ];
	}

}

- (void)navigationBar:(UINavigationBar*)bar buttonClicked:(int) which;
{
//	NSLog( @"button pressed, which: %d", which );
	if ( which == 0 ) //right
	{

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

