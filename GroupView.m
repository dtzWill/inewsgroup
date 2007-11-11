//Will Dietz
//GroupView.m

#import "GroupView.h"
#import "datastructures.h"

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
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getArticles) userInfo:nil repeats:NO];	

}

- (void) setGroupNum: (int) groupnum
{
	_groupnum = groupnum;
	[ _rows removeAllObjects];//ignoring cases where re-entering same group, we don't care about old articles
	[ _titleItem setTitle: [NSString stringWithCString: active[ my_group[ _groupnum ] ].name ]];	
	
}

- (void) getArticles
{
	loadGroup( _groupnum );

	[ _connect dismiss ];

	//build rows....

	int i;
	UISimpleTableCell * row;
	[_rows removeAllObjects];
	for ( i = 0; i < grpmenu.max; i++ )
	{
		row = [[UISimpleTableCell alloc] init];
		[row setTitle: [ NSString stringWithFormat: @"%s%s" , 
			arts[ base[i] ].status == ART_READ ? " ": "*",//star if unread (or other non-read status)
			arts[ base[i] ].subject , artsInThread( i ) ] ] ;
	//	[row setFont: smaller_font ];
		if ( artsInThread( i ) > 1 )
		{
			[row setDisclosureStyle: 1];
			[row setShowDisclosure: YES];
		}
		[ _rows addObject: row ];
	}

	[ _table reloadData ];

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

- (void)tableRowSelected:(NSNotification *)notification {
//  NSLog(@"tableRowSelected!");
	int i = [ _table selectedRow ];
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
		//remove the '*' part of it.. right now /attempting/ to view it counts as 'read'
		[ [ _rows objectAtIndex: i ] setTitle: [NSString stringWithCString: arts[ base[i] ].subject ] ];
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

	[ _delegate setView: self];

}

- (void) setView: (UIView *) view
{

	[ _delegate setView: view ];
}
@end
