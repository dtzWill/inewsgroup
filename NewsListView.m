//Will Dietz
//NewsListView.m

#import "NewsListView.h"
#import "datastructures.h"

@implementation NewsListView

- (id)initWithFrame: (struct CGRect) rect withRoot: (NSString *) root andDelegate: (id) delegate;
{
	return [self initWithFrame: rect withRoot: root andDepth: 0 andDelegate: delegate andParent: self];	
}
//@private
- (id)initWithFrame:(struct CGRect)rect withRoot:(NSString *) root andDepth: (int) depth andDelegate: (id) delegate andParent: (UIView *) parent;
{
	[super initWithFrame: rect ];

	_delegate = delegate;
	_parent = parent;

	NSFileManager *fileManager = [ NSFileManager defaultManager ];

	//if our directory doesn't exist... we're done
	if ([fileManager fileExistsAtPath: root] == NO) {
		return;
	}
	_path  = root;
	NSArray *dirContents = [ [NSArray alloc] initWithArray:[fileManager directoryContentsAtPath: root] ];

	_items = [ [NSMutableArray alloc] init ];
	
	NSString * dirEnt;
	NewsItem * item;
	NSEnumerator *dirEnum = [dirContents objectEnumerator];
	_rowcount = 0;
	while ( dirEnt = [dirEnum nextObject] )
	{
		if ( [dirEnt characterAtIndex:0] != (unichar)'.' ) 
		{  
			BOOL isDir;
			NSString * full_path = [_path stringByAppendingPathComponent:dirEnt];
			[fileManager fileExistsAtPath: full_path isDirectory:&isDir];
			if (isDir )
			{
			
				UIView * view = [[ NewsListView alloc] initWithFrame:rect withRoot:full_path andDepth: depth + 1 andDelegate: delegate andParent: self ];	
				item = [ [NewsItem alloc] initWithFilename: dirEnt isThatADir: true andNextView: view ];
				[ _items addObject: item];
				_rowcount++;
			}
			else
			{ 
				item = [ [NewsItem alloc] initWithFilename: dirEnt isThatADir: isDir andNextView: self];
				[ _items addObject: item];
				_rowcount++;
			} 
		}

 	}


//	NSLog ( @"Added %d items to NewsListView %@", _rowcount, _path );
	
	UINavigationBar * nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(
	    0.0f, 0.0f, 320.0f, 48.0f)];
	_titleItem = [ [UINavigationItem alloc] initWithTitle: _path ];
	[nav pushNavigationItem: _titleItem];
	[nav showButtonsWithLeftTitle:@"Back" rightTitle: nil leftBack:YES ];
	[nav setBarStyle: 0];
	[nav setDelegate: self];

	_table = [[UITable alloc] initWithFrame: CGRectMake(0.0f, 48.0f,
	    320.0f, 480.0f - 16.0f - 32.0f)];
	UITableColumn *col = [[UITableColumn alloc] initWithTitle: @"fileslist"
	    identifier: @"fileslist" width: 320.0f];
	
	[_table addTableColumn: col]; 
	[_table setDataSource: self];
	[_table setDelegate: self];
	[_table reloadData];

	[self addSubview: nav];

	[self addSubview: _table];

	return self;
}

-(void)refresh
{
//nothing useful for now
	[_table reloadData];
}; 


//Methods to make table work...:
- (int) numberOfRowsInTable: (UITable *)table
{
	NSLog ( @"numRows called: %d", _rowcount );
    return  _rowcount ;
}

- (UITableCell *) table: (UITable *)table cellForRow: (int)row column: (int)col
{
	return [_items objectAtIndex: row];
}

- (UITableCell *) table: (UITable *)table cellForRow: (int)row column: (int)col
    reusing: (BOOL) reusing
{
    return [ _items objectAtIndex: row]; 
}


- (void)tableRowSelected:(NSNotification *)notification {
//  NSLog(@"tableRowSelected!");

	UIView * view = [ [ _items objectAtIndex: [ _table selectedRow ] ] getView ];
	[ _delegate setContentView: view ];
}
/*
	//build url....
	char url[200];
	strcpy( url, "maps:q=");//prefix
	strncat( url, uiucBuildings[[table selectedRow]].location, 200-strlen(url) );
	
	//go there!
	[self openURL:[[NSURL alloc] initFileURLWithPath:[NSString stringWithCString:url]]];
*/
- (void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)which;
{
	if ( which == 1 ) //left
	{
		if ( _parent != self ) //we're not root
		{
			[ _delegate setContentView: _parent ];
		}
	}
}

@end
