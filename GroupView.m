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
	[super initWithFrame: rect];

	UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(
	    0.0f, 0.0f, 320.0f, 48.0f)];

	_connect = [[UIAlertSheet alloc]initWithTitle:@"Refreshing..." buttons:nil defaultButtonIndex:1 delegate:self context:nil];

	
	[_connect setDimsBackground:YES];
	
	_threadView = [[ThreadView alloc] initWithFrame: rect];
	[ _threadView setDelegate: self ];

	_postView = [[PostView alloc] initWithFrame: rect];
	[ _postView setDelegate: self ];
	_postView = [[PostView alloc] initWithFrame: rect];
	[ _postView setDelegate: self ];

	_titleItem = [ [UINavigationItem alloc] initWithTitle: @"GroupView" ];
	[nav showButtonsWithLeftTitle: @"Back" rightTitle: @"Refresh" leftBack: YES ]; 
	[nav pushNavigationItem: _titleItem];
	[nav setDelegate: self];	
	[nav setBarStyle: 0];

	_rows = [ [ NSMutableArray alloc] init ];

	_table = [[UITable alloc] initWithFrame: CGRectMake(0.0f, 48.0f,
	    320.0f, 480.0f - 16.0f - 48.0f)];
	UITableColumn *col = [[UITableColumn alloc] initWithTitle: @"articles"
	    identifier: @"articles" width: 320.0f];
	
	[_table addTableColumn: col]; 
	[_table setDataSource: self];
	[_table setDelegate: self];
	[_table reloadData];

	[self addSubview: nav];
	[self addSubview: _table];
	
	return self;
}


- (void) refreshMe
{

	[_connect presentSheetInView: self ];
	[_rows removeAllObjects];
	[_table reloadData ]; 
    [NSTimer scheduledTimerWithTimeInterval: REFRESH_TIME target:self selector:@selector(getArticles) userInfo:nil repeats:NO];	

}

- (void) setGroupNum: (int) groupnum
{
	_groupnum = groupnum;
	[ _rows removeAllObjects];//ignoring cases where re-entering same group, we don't care about old articles (reload anyway.. stupid user shouldnt've left in the first place ;-))

	[ _titleItem setTitle: [NSString stringWithCString: active[ my_group[ _groupnum ] ].name ]];	
	
}

- (void) getArticles
{
	loadGroup( _groupnum );


	[ _connect dismiss ];

	//build rows....

	int i;
	GroupItem * row;
	[_rows removeAllObjects];
	for ( i = 0; i < grpmenu.max; i++ )
	{
		row = [[GroupItem alloc] initWithThreadNum: i ];

		
	//	[row setTitleColor: CGColorCreate(colorSpace, col_gray)];

		if ( artsInThread( i ) > 1 )
		{
			[row setDisclosureStyle: 1];
			[row setShowDisclosure: YES];
		}
		[ _rows addObject: row ];
	}
	[self refreshTitles];

	[ _table reloadData ];

}

- (void) refreshTitles
{
	int i = 0, threadnum;
	GroupItem * cell;
	for(; i < [ _rows count ]; i++)
	{
//		NSLog( @"refreshing cell %d\n", i );
		cell = [ _rows objectAtIndex: i ];
		threadnum = [cell threadNum];
//		struct __GSFont * cell_font = GSFontCreateWithName("Helvetica", 1, 14.0f);
//        [ [ cell titleTextLabel ] setFont: cell_font ];
  //      float forecolor[4] = { 0.0, 0.0, 0.0, 1.0 };
  //      [ [ cell titleTextLabel ] setBackgroundColor: CGColorCreate(colorSpace, col_bkgd)];
    //    [ [cell titleTextLabel ] setHighlightedColor: CGColorCreate(colorSpace, col_gray)];
  //      [ [cell titleTextLabel ] setColor: CGColorCreate(colorSpace, forecolor)];
//		CFRelease( cell_font );

/*		[ [ cell titleTextLabel ] setText: [NSString stringWithFormat: @"%s%s",
			isThreadRead( threadnum ) ? " ": "*",//star if unread (or other non-read status)
			arts[ base[threadnum] ].subject ] ];*/

		UIImage * img = [UIImage applicationImageNamed:
				isThreadRead( threadnum ) ?
					@"ReadIndicator.png" : @"UnreadIndicator.png" ];  


		[ cell setTitle: [NSString stringWithFormat: @"%s\n", arts[ base[ threadnum ] ].subject ] ];

		[ cell setImage: img ];

		//artsInThread( threadnum ) ] ] ; //write # unread articles at some point..?
		
	}
	

}

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


- (void) setDelegate: (id) delegate
{

	_delegate = delegate;

}

- (void) returnToPage
{
	[self refreshTitles ];
	[ _delegate setView: self];

}

- (void) setView: (UIView *) view
{

	[ _delegate setView: view ];
}
@end

@implementation GroupItem

- (id) initWithThreadNum: (int) threadnum
{
	[super initWithFrame: CGRectMake(0.0f,0.0f, 320.0f, 64.0f)];
//	smaller_font = GSFontCreateWithName("Helvetica", 2, 24.0f);
//	[ [self titleTextLabel ] setFont: smaller_font ];
//	float forecolor[4] = { 1.0, 1.0, 1.0, 1.0 };
//	[ [self titleTextLabel ] setBackgroundColor: CGColorCreate(colorSpace, col_bkgd)];
//	[ [self titleTextLabel ] setHighlightedColor: CGColorCreate(colorSpace, col_gray)];
//	[ [self titleTextLabel ] setColor: CGColorCreate(colorSpace, forecolor)];
	[ [self titleTextLabel]setFont: GSFontCreateWithName("Helvetica", kGSFontTraitBold,14) ];	
	[ self setTitle: @"News item" ];
	[ [ self titleTextLabel ]setWrapsText: YES ]; //doesn't seem to do anything
	_threadnum = threadnum;
	return self;
}

- (int) threadNum
{

	return _threadnum;
}

@end
