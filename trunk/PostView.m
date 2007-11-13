//Will Dietz
//PostView.m

#import "PostView.h"

#import <UIKit/UISimpleTableCell.h>
#import "newsfunctions.h"

@implementation PostView

- (id) initWithFrame: (CGRect) rect
{
	[super initWithFrame: rect];

	UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(
	    0.0f, 0.0f, 320.0f, 48.0f)];

	_titleItem = [ [UINavigationItem alloc] initWithTitle: @"PostView" ];//better name?? lol
	[nav showButtonsWithLeftTitle: @"Back" rightTitle: nil leftBack: YES ];
	 
	[nav pushNavigationItem: _titleItem];
	[nav setDelegate: self];	
	[nav setBarStyle: 0];

	_message = [[UIAlertSheet alloc]initWithTitle:@"Loading Message..." buttons:nil defaultButtonIndex:1 delegate:self context:nil];
	
	[_message setDimsBackground:YES];
	
	_rows = [ [ NSMutableArray alloc] init ];

	_table = [[UITable alloc] initWithFrame: CGRectMake(0.0f, 48.0f,
	    320.0f, 48.0f + 80.0f )];//480.0f - 16.0f - 48.0f - 350.0f)];
	//col_subj
	UITableColumn * col = [[UITableColumn alloc] initWithTitle: @"post"
	    identifier: @"post" width: 320.0f];

	_textView = [[UITextView alloc] initWithFrame: CGRectMake(0.0f, 48.0f + 80.0f,
		320.0f, 480.0f - 16.0f - 48.0f - 80.0f )]; 
	//later show more information via multiple columns..

//	UITableColumn * col_from = [[UITableColumn alloc] initWithTitle: @"from"
//		identifier: @"from" width: 50.0f ];
//	UITableColumn * col_date = [[UITableColumn alloc	
	
	[_table addTableColumn: col]; 
	[_table setDataSource: self];
	[_table setDelegate: self];
	[_table reloadData];

	[self addSubview: nav];
	[self addSubview: _table];
	[self addSubview: _textView];
	
	return self;
}


- (void) refresh
{
	[_message presentSheetInView: self ];	
	[_rows removeAllObjects ];
	[_titleItem setTitle: @"Loading..." ];
	[_table reloadData ];
	[_textView setText: @""];
    [NSTimer scheduledTimerWithTimeInterval: REFRESH_TIME target:self selector:@selector(getPost) userInfo:nil repeats:NO];	
}
- (void) getPost
{
	NSLog( @" trying to open article %d of group %d", _postnum, _groupnum );


	openArticle( _groupnum, _postnum );
	
	NSString * body = readArticleContent();
 
	UISimpleTableCell * row;

	//from
	row = [[UISimpleTableCell alloc] init ];
	[ row setTitle: articleFrom() ];
	[ _rows addObject: row]; 

	//subject	
	row = [[UISimpleTableCell alloc] init];
	[ row setTitle: articleSubject() ];
	[ _rows addObject: row];

	[ _table reloadData];

	[ _textView setTextSize: 12 ];
	[ _textView setText: body ];
	//doesn't seem to have any effect...???
	//	[ _textView setTextFont: @"Helvetica 10"];//smaller_font ];
	[ _textView recalculateStyle ];
	[_message dismiss ];

	[ _titleItem setTitle: articleSubject() ];

	closeArticle();

	markArticleRead( _groupnum, _postnum );

/*
	int i;
	UISimpleTableCell * row;
	[_rows removeAllObjects];
	for_each_art_in_thread( i, _threadnum )
	{
		row = [[UISimpleTableCell alloc] initWithArticle: i ];
		[row setTitle: [NSString stringWithCString: arts[ i ].subject ] ];
		[ _rows addObject: row ];
	}
	
	[ _table reloadData ];
*/
}

- (void) setArticleNum: (int) artnum andGroupnum: (int) groupnum
{
		_postnum = artnum;
		_groupnum = groupnum;
		[_rows removeAllObjects];
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
	//
	}
	else
	{
		[ _delegate returnToPage ];	
	}

}


- (void) setDelegate: (id) delegate
{

	_delegate = delegate;

}
/*
- (void) returnToPage
{
	[_delegate setView: self ];


}
*/

@end
