//Will Dietz
//GroupView.m

#import "GroupView.h"

//TODO: move any functionality that needs this into newsfunctions where it belongs!
#import "tin.h"

@implementation GroupView

- (id) initWithFrame: (CGRect) rect
{
	[super initWithFrame: rect];

	UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(
	    0.0f, 0.0f, 320.0f, 48.0f)];

	_connect = [[UIAlertSheet alloc]initWithTitle:@"Connecting..." buttons:nil defaultButtonIndex:1 delegate:self context:nil];
	
	[_connect setDimsBackground:YES];


	_titleItem = [ [UINavigationItem alloc] initWithTitle: @"GroupView" ];
	[nav showButtonsWithLeftTitle: @"Back" rightTitle: @"Refresh" leftBack: YES ]; 
	[nav pushNavigationItem: _titleItem];
	[nav setDelegate: self];	
	[nav setBarStyle: 0];

	_rows = [ [ NSMutableArray alloc] init ];

	_table = [[UITable alloc] initWithFrame: CGRectMake(0.0f, 48.0f,
	    320.0f, 480.0f - 16.0f - 32.0f)];
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
	//clear array...?
}

- (void) getArticles
{
	loadGroup( _groupnum );

	[ _connect dismiss ];

	//build rows....

	//find_base --implement threading later...

	int i;
	UIImageAndTextTableCell * row;
	for ( i = 0; i < top_art; i++ )
	{
		row = [[UIImageAndTextTableCell alloc] init];
		[row setTitle: [NSString stringWithCString: arts[i].subject ] ];
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
@end
