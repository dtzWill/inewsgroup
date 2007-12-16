//Will Dietz
//GroupView.m

#import "GroupView.h"
#import "newsfunctions.h"
#import <GraphicsServices/GraphicsServices.h>

//TODO: move any functionality that needs this into newsfunctions where it belongs!
#import "tin.h"



@implementation GroupView

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

	//Create /the/ threadView instance
	_threadView = [[ThreadView alloc] initWithFrame: rect];
	[ _threadView setDelegate: self ];

	//Create /the/ postView instance
	_postView = [[PostView alloc] initWithFrame: rect];
	[ _postView setDelegate: self ];

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


		[ cell setTitle: [NSString stringWithFormat: @"%s\n", arts[ base[ threadnum ] ].subject ] ];

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
		[ _threadView setGroupNum: _groupnum andThreadNum: i ];
		[ _threadView refresh ];
		[ _delegate setView: _threadView ];
	}
	else
	{
		[ _postView setArticleNum: base[ i ] andGroupnum: _groupnum ];
		[ _delegate setView: _postView ];
		[ _postView refresh ];
		//
	}
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
		[ _delegate returnToMain ];	
	}

}

//set parent to call when need to take actions like changing views, etc
- (void) setDelegate: (id) delegate
{

	_delegate = delegate;

}

//method our children call to return to us....update ourselves in case any changes
//have been made (in particular read/unread status) and pass the necessary
//view request along to delegate
- (void) returnToPage
{
	[self refreshTitles ];
	[ _delegate setView: self];

}

//method our children call to change a view.. we just pass it along :)
- (void) setView: (UIView *) view
{

	[ _delegate setView: view ];
}
@end



//class representing an element in the table--basically just a subclass of a normal
//table row, but stores the threadnumber in with it for easy access
@implementation GroupItem

- (id) initWithThreadNum: (int) threadnum
{
	[super initWithFrame: CGRectMake(0.0f,0.0f, 320.0f, 64.0f)];

	//set font to use....
	[ [self titleTextLabel]setFont: GSFontCreateWithName("Helvetica", kGSFontTraitBold,14) ];	
	//remember our threadnum....
	_threadnum = threadnum;
	return self;
}


//accessor method..
- (int) threadNum
{

	return _threadnum;
}

@end
