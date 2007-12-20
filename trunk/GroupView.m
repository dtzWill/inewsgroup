//Will Dietz
//GroupView.m

#import "GroupView.h"

#import "newsfunctions.h"
#import <GraphicsServices/GraphicsServices.h>
#import "iNewsApp.h"
#import "ViewController.h"
#import "ComposeView.h"
//TODO: move any functionality that needs this into newsfunctions where it belongs!
#import "tin.h"

static GroupView * sharedInstance = nil;

@implementation GroupView

+ (GroupView *) sharedInstance
{
	if ( sharedInstance )
		return sharedInstance;

	//else

	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin. x = rect.origin.y = 0;
	sharedInstance = [[GroupView alloc] initWithFrame: rect ]; 

	return sharedInstance;
}

- (id) initWithFrame: (CGRect) rect
{
	//TODO: actually use the rect! :-/.

	[super initWithFrame: rect];

	//Build navigation bar....
	UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(
	    0.0f, 0.0f, 320.0f, 48.0f)];
	[nav setDelegate: self];	
	[nav setBarStyle: 0];

	//Build alertshet used to display message to user while we're getting the headers
	_connect = [[UIAlertSheet alloc]initWithTitle:@"Refreshing..." buttons:nil defaultButtonIndex:1 delegate:self context:self];
	[_connect setDimsBackground:YES];

	//create title bar
	_titleItem = [ [UINavigationItem alloc] initWithTitle: @"GroupView" ];
	//assign title bar to nav bar
	[nav showLeftButton: @"Back" withStyle: BUTTON_BACK rightButton: @"Refresh" withStyle: BUTTON_BLUE ];
	[nav pushNavigationItem: _titleItem];

	//create array to store the rows
	_rows = [ [ NSMutableArray alloc] init ];

	//create table used to display the rows
	_table = [[UITable alloc] initWithFrame: CGRectMake(0.0f, 48.0f,
	    320.0f, 480.0f - 16.0f - 48.0f*2)];
	//our table has a single column...
	UITableColumn *col = [[UITableColumn alloc] initWithTitle: @"articles"
	    identifier: @"articles" width: 320.0f];

	//finish initializing the table	
	[_table addTableColumn: col]; 
	[_table setDataSource: self];
	[_table setDelegate: self];
	[_table setSeparatorStyle: 1];
	[_table reloadData];

	_selectedRow = -1; //invalid


	//bottom bar:

	//create buttons...
    NSDictionary *btnCompose = [NSDictionary dictionaryWithObjectsAndKeys:
            //self, kUIButtonBarButtonTarget,
            @"buttonBarItemTapped:", kUIButtonBarButtonAction,
            [NSNumber numberWithUnsignedInt:1], kUIButtonBarButtonTag,
            [NSNumber numberWithUnsignedInt:3], kUIButtonBarButtonStyle,
            [NSNumber numberWithUnsignedInt:1], kUIButtonBarButtonType,
            @"New Message...", kUIButtonBarButtonInfo,
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

	NSArray *items = [NSArray arrayWithObjects:btnCompose,btnMarkRead, nil];
	UIButtonBar *buttonBar = [[UIButtonBar alloc] initInView: self withFrame:CGRectMake(0.0f, 480.0f-16.0f-48.0f, 320.0f, 48.0f) withItemList:items];
	
	int buttons[2] = { 1, 2,};
	[buttonBar registerButtonGroup:1 withButtons:buttons withCount:2];
	[buttonBar showButtonGroup:1 withDuration:0.];
	[buttonBar setDelegate: self];
//    [buttonBar setBarStyle:2];
    [buttonBar setButtonBarTrackingMode: 2];

	[ [ buttonBar viewWithTag: 2 ]//2='mark read' button
            setFrame:CGRectMake( 320.0f	-80.0f, 0.0f, 64.0f, 48.0f) //right-align
        ]; 
	




	//add views to ourself
	[self addSubview: nav];
	[self addSubview: _table];
	
	//done!
	return self;
}

//handle various buttons:
- (void)buttonBarItemTapped:(id) sender {
	int button = [ sender tag ];
	int i;
	switch (button) {
		case 1://compose a new message in this group
			NSLog( @"Compose!" );
			NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				[ [NSString stringWithCString: active[ my_group[ _groupnum ] ].name ] retain ], kNewsGroup,		
					nil];
			NSLog( @"dict created!" );
			[ [ ComposeView sharedInstance ] startNewMessage: dict ];

			[ [ ViewController sharedInstance ] setView: [ ComposeView sharedInstance] slideFromLeft: YES ];

		
			break;

        case 2://mark selected group read
			if( _selectedRow >= 0 )
			{
				for_each_art_in_thread( i ,
					[ [ _rows objectAtIndex: [_rows count] - 1 - _selectedRow ] threadNum ] )
				{
					markArticleRead( _groupnum, i );	
				}

				[ self refreshTitles ];
			}
			break;
	}
   
}

- (void)view:(UIView *)view handleTapWithCount:(int)count event:(GSEvent *)event {
//This should only be called from the disclosures of the rows!

	//disclosure clicked on..... go there!
	if ( _selectedRow >= 0 )
	{
	
		int i = [ [ _rows objectAtIndex: [_rows count] - 1 - _selectedRow ] threadNum ];
		if ( artsInThread( i ) > 1 ) //if actually is /in/ a thead
		{
			[ [ThreadView sharedInstance] setGroupNum: _groupnum andThreadNum: i ];
			[ [ ViewController sharedInstance] setView: [ThreadView sharedInstance] slideFromLeft: YES ];
			[ [ThreadView sharedInstance] refresh ];
		}
		else
		{
			[ [PostView sharedInstance ] setArticleNum: base[ i ] andGroupnum: _groupnum ];
			[ [ ViewController sharedInstance] setView: [PostView sharedInstance] slideFromLeft: YES ];
			[ [PostView sharedInstance ] refresh ];
		}
	}
}


//method used to refresh the contents of the groupView--displays message and then does the refreshing.
- (void) refreshMe
{

	//display the message
	[_connect presentSheetInView: self ];

	//clear the array, and dealloc'ing each along the way....
	while( [_rows count] > 0 )
	{
		id row = [_rows objectAtIndex: 0 ];
		[_rows removeObjectAtIndex: 0 ];
		[row release ];	
	}

	//tell the gui to refresh the rows
	[_table reloadData ]; 

	//call us back in a bit--this is used to allow the gui to update itself (in particular, to render _connect ) before continuing
    [NSTimer scheduledTimerWithTimeInterval: REFRESH_TIME target:self selector:@selector(getArticles) userInfo:nil repeats:NO];	

}

//used to set the groupnum (index in my_group) for use throughout this instance
//particularly in the refreshing and getArticles
- (void) setGroupNum: (int) groupnum
{
	_groupnum = groupnum;

	//clear the array, dealloc'ing each along the way...
	while( [_rows count] > 0 )
	{
		id row = [_rows objectAtIndex: 0 ];
		[_rows removeObjectAtIndex: 0 ];
		[row release ];	
	}

	//update title to reflect the new group's name
	[ _titleItem setTitle: [NSString stringWithCString: active[ my_group[ _groupnum ] ].name ]];	
	
}


//Uses the appropriate newsfunctions to load the articles headers into memory
- (void) getArticles
{


	//issue 'group GROUPNAME' command to nntp server...
	loadGroup( _groupnum );

	//clear the array, dealloc'ing each along the way...
	while( [_rows count] > 0 )
	{
		id row = [_rows objectAtIndex: 0 ];
		[_rows removeObjectAtIndex: 0 ];
		[row release ];	
	}

	//build rows....
	int i;
	GroupItem * row;
	for ( i = 0; i < grpmenu.max; i++ )
	{
		row = [[GroupItem alloc] initWithThreadNum: i ];

		if ( artsInThread( i ) > 1 )
		{
			[row setDisclosureStyle: 1];
		}
		else
		{
			[row setDisclosureStyle: 2];
		}
		[row setShowDisclosure: YES];
		[row setDisclosureClickable: YES];
		[ [ row _disclosureView ] setTapDelegate: self ];

		[ _rows addObject: row ];
	}

	//update read/unread status...
	[self refreshTitles];

	[ _table reloadData ];

	//remove the message, we're done now
	[ _connect dismiss ];

}

//updates/assigns the titles for each row (the subject of the thread)
//any the read/unread status indicator
- (void) refreshTitles
{
	int i = 0, threadnum;
	GroupItem * cell;
	for(; i < [ _rows count ]; i++)
	{
//		NSLog( @"refreshing cell %d\n", i );
		cell = [ _rows objectAtIndex: i ];
		threadnum = [cell threadNum];

		UIImage * img = [UIImage applicationImageNamed:
				isThreadRead( threadnum ) ?
					@"ReadIndicator.png" : @"UnreadIndicator.png" ];
//					( ( artCount > 1 )? @"ThReadIndicator.png" : @"ReadIndicator.png" )
//					: ( ( artCount > 1 ) ? @"ThUnreadIndicator.png" : @"UnreadIndicator.png" ) ];  


		[ cell setTitle: [NSString stringWithFormat: @"%s", arts[ base[ threadnum ] ].subject ] ];

		[ cell setImage: img ];

		//TODO: would be cool, throughout app, to display the number of unread like in
		//the mail app....
		//artsInThread( threadnum ) ] ] ; //write # unread articles at some point..?
		
	}
	

}

////////////////////////////////////////////////////////////////////////////////////
//Methods to make table work...:
- (int) numberOfRowsInTable: (UITable *)table
{
	return  [ _rows count] ;
}

- (UITableCell *) table: (UITable *)table cellForRow: (int)row column: (int)col
{
	return [_rows objectAtIndex: [ _rows count ] - 1 - row ];
}

- (UITableCell *) table: (UITable *)table cellForRow: (int)row column: (int)col
	reusing: (BOOL) reusing
{
	return [ _rows objectAtIndex: [ _rows count ] - 1 - row ]; 
}

- (void)tableRowSelected:(NSNotification *)notification {
//  NSLog(@"tableRowSelected: %d", [ _table selectedRow ]);

	_selectedRow = [ _table selectedRow ];
/*	
*/
}

- (float)table:(UITable *)aTable heightForRow:(int)row {
	return [ [ _rows objectAtIndex: row ] rowHeight ];
}

///////////////////////////////////////////////////////////////////////////////////
//nav bar button handler
- (void)navigationBar:(UINavigationBar*)bar buttonClicked:(int) which;
{
//	NSLog( @"button pressed, which: %d", which );
	if ( which == 0 ) //right
	{
		[ self refreshMe ];
	}
	else
	{
		[ [ iNewsApp sharedInstance ] refreshTable ];
		[ [ ViewController sharedInstance ] setView: [ [iNewsApp sharedInstance] mainView ] slideFromLeft: NO ];
	}

}
@end

//class representing an element in the table--basically just a subclass of a normal
//table row, but stores the threadnumber in with it for easy access
@implementation GroupItem

- (id) initWithThreadNum: (int) threadnum
{
	[super initWithFrame: CGRectMake(0.0f,0.0f, 320.0f, 128.0f)];

	//set font to use....
	[ [self titleTextLabel]setFont: GSFontCreateWithName("Helvetica", kGSFontTraitBold,14) ];	
	[ [self titleTextLabel] setWrapsText: YES ];
	//remember our threadnum....
	_threadnum = threadnum;
	return self;
}

- (void) layoutSubviews
{
	[ super layoutSubviews ];
	CGRect rect = CGRectMake( 32.0f, 0.0f, 260.0f, 16.0f * [self numLines ] );
	//center it vertically
	rect.origin.y = ( (64.0f - 16.0f * [self numLines ])/ 2.0f  );	
 
	[ [ self titleTextLabel] setFrame: rect ];	
//	[ [ self titleTextLabel ] setWrapsText: YES ];
//	NSLog( @"Size: x: %f, y: %f", [ _titleTextLabel textSize ].width, [_titleTextLabel textSize].height ); 
}

//accessor method..
- (int) threadNum
{

	return _threadnum;
}


- (int) numLines
{
	return 1 + ( [_titleTextLabel textSize].width ) / 250;
}

- (float) rowHeight
{
	return 64.0f;

}
@end
