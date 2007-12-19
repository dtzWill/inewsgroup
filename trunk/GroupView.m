//Will Dietz
//GroupView.m

#import "GroupView.h"
#import "newsfunctions.h"
#import <GraphicsServices/GraphicsServices.h>
#import "iNewsApp.h"
#import "ViewController.h"
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
	[nav showButtonsWithLeftTitle: @"Back" rightTitle: @"Refresh" leftBack: YES ]; 
	[nav pushNavigationItem: _titleItem];

	//create array to store the rows
	_rows = [ [ NSMutableArray alloc] init ];

	//create table used to display the rows
	_table = [[UITable alloc] initWithFrame: CGRectMake(0.0f, 48.0f,
	    320.0f, 480.0f - 16.0f - 48.0f)];
	//our table has a single column...
	UITableColumn *col = [[UITableColumn alloc] initWithTitle: @"articles"
	    identifier: @"articles" width: 320.0f];

	//finish initializing the table	
	[_table addTableColumn: col]; 
	[_table setDataSource: self];
	[_table setDelegate: self];
	[_table setSeparatorStyle: 1];
	[_table reloadData];

	//add views to ourself
	[self addSubview: nav];
	[self addSubview: _table];
	
	//done!
	return self;
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
			[row setShowDisclosure: YES];
		}
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
//  NSLog(@"tableRowSelected!");
	int i = [ [ _rows objectAtIndex: [_rows count] - 1 - [ _table selectedRow ] ] threadNum ];
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

//	int height = 64.0f+ 32.0f*([self numLines]); 
//	NSLog( @"rowHeight called! %d", height );
//	return height;
}
@end
