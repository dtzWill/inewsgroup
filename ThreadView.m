//Will Dietz
//ThreadView.m

#import "ThreadView.h"

//TODO: move any functionality that needs this into newsfunctions where it belongs!
#import "tin.h"

@implementation ThreadView

- (id) initWithFrame: (CGRect) rect
{
	[super initWithFrame: rect];

	UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(
	    0.0f, 0.0f, 320.0f, 48.0f)];

	_titleItem = [ [UINavigationItem alloc] initWithTitle: @"ThreadView" ];//better name?? lol
	[nav showButtonsWithLeftTitle: @"Back" rightTitle: nil leftBack: YES ];
	//'Next' button in the nav bar to browse threads??
	//(maybe put prev/next in a bottom bar....?)
	 
	[nav pushNavigationItem: _titleItem];
	[nav setDelegate: self];	
	[nav setBarStyle: 0];

	_rows = [ [ NSMutableArray alloc] init ];

	_table = [[UITable alloc] initWithFrame: CGRectMake(0.0f, 48.0f,
	    320.0f, 480.0f - 16.0f - 48.0f)];
	UITableColumn *col = [[UITableColumn alloc] initWithTitle: @"thread"
	    identifier: @"thread" width: 320.0f];
	
	[_table addTableColumn: col]; 
	[_table setDataSource: self];
	[_table setDelegate: self];
	[_table reloadData];

	[self addSubview: nav];
	[self addSubview: _table];
	
	return self;
}


- (void) refresh
{

	int i;
	ThreadViewItem * row;
	[_rows removeAllObjects];
	for_each_art_in_thread( i, _threadnum )
	{
		row = [[ThreadViewItem alloc] initWithArticle: i ];
		[row setTitle: [NSString stringWithCString: arts[ i ].subject ] ];
		[ _rows addObject: row ];
	}
	
	[ _table reloadData ];

}

- (void) setGroupNum: (int) groupnum andThreadNum: (int) threadnum
{
	_groupnum = groupnum;
	_threadnum = threadnum;
	[ _rows removeAllObjects];//ignoring cases where re-entering same group, we don't care about old articles
//	[ _titleItem setTitle: [NSString stringWithCString: active[ my_group[ _groupnum ] ].name ]];	
	//something cool here??	
}

- (void) getArticles
{
	loadGroup( _groupnum );


	//build rows....


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
//		[ self refreshMe ];
	}
	else
	{
		[ _delegate returnToGroup ];	
	}

}


- (void) setDelegate: (id) delegate
{

	_delegate = delegate;

}
@end


@implementation ThreadViewItem

- (id) initWithArticle: (id) artnum
{
	[super init];

	_articleID = artnum;

	return self;
}

- (int) article
{
	return _articleID;
}
@end
