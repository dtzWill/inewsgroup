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
#import "ViewController.h"

static iNewsApp * sharedInstance = nil;


@implementation iNewsApp
- (id)_initWithArgc:(int)fp8 argv:(const char **)fp12
{
	
	return (sharedInstance = [super _initWithArgc: fp8 argv: fp12 ] );	

}

+ (iNewsApp *) sharedInstance
{
	if ( sharedInstance )
	{
		return sharedInstance;
	}
	NSLog( @"ERROR: sharedInstance called /before/ obj init'd.." );

	return nil;//we /want/ things to die, this shouldn't ever happen
}

- (void) applicationDidFinishLaunching: (id) unused
{
	
	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin. x = rect.origin.y = 0;
	_window = [[UIWindow alloc] initWithContentRect: rect];


	_mainView = [[UIView alloc] initWithFrame: rect];
	[ [ViewController sharedInstance ] addSubview: _mainView ];	
	[ [ViewController sharedInstance ] setCurView: _mainView ];
	[_window setContentView: [ ViewController sharedInstance ] ];

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

	_count = 0;//clear out the count

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

	[_mainView addSubview:  _navTop ];
	[_mainView addSubview: _table ];
	[_mainView addSubview: buttonBar ];

	NSLog( @"Done with applicationDidFinishLaunching" ); 
}


- (void)tableRowSelected:(NSNotification *)notification {
//  NSLog(@"tableRowSelected!");
	//just set selectedRow for use elsewhere
	_selectedRow = [_table selectedRow];


}

//handle various buttons:
- (void)buttonBarItemTapped:(id) sender {
	int button = [ sender tag ];
	switch (button) {
		case 1://subscription manager
			NSLog( @"showing subs" );

			[ [ ViewController sharedInstance] setView: [ SubscriptionView sharedInstance ] slideFromLeft: NO ];

			NSLog( @"loading sub settings" );
			[ self saveConfig ];//commit it to the newsrc, b/c subs might change it, then reload, losing all data (namely read/unread status)
			[ [ SubscriptionView sharedInstance ] refreshMe ];
		
			break;

        case 2://mark selected group read
			if( _selectedRow >= 0 )
			{
				markGroupRead( _selectedRow );	
				[ self refreshTable ];
			}
			break;
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
	[_connect presentSheetInView: [ViewController sharedInstance ] ];	 

	[NSTimer scheduledTimerWithTimeInterval: REFRESH_TIME target:self selector:@selector(delayedInit) userInfo:nil repeats:NO];	
//	NSLog( @" set timer....%d", self );

}

- (UIView *) mainView
{
	return _mainView;
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
	[self performSelectorOnMainThread: @selector(delayedInitSel) withObject: nil waitUntilDone: YES];
}

- (void) delayedInitSel
{
	if(	!init_server() )
	{//if fail.. just go to prefs page
		NSLog( @"connection failed... showing prefs view" );
		[ [ViewController sharedInstance] setView: [PrefsView sharedInstance ] slideFromLeft: NO ];
	
	}
	else
	{
		[NSTimer scheduledTimerWithTimeInterval: SAVE_TIME target:self selector:@selector(saveConfig) userInfo:nil repeats:YES];	
		updateData();
		[self refreshTable ];

	}
	[ _connect dismiss ];
	[ [PrefsView sharedInstance ] loadSettings ];
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

	//disclosure clicked on..... go there!
	if( _selectedRow >= 0 ) //if valid group number
	{
		[ [GroupView sharedInstance ] setGroupNum: _selectedRow ];
	

		[ [ViewController sharedInstance] setView: [GroupView sharedInstance] slideFromLeft: YES ];
	
		[ [GroupView sharedInstance ] refreshMe ];
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
		[ [ViewController sharedInstance] setView: [PrefsView sharedInstance] slideFromLeft: NO ];

	}

}

@end

