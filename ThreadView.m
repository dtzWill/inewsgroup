//Will Dietz
//ThreadView.m

/*
    This file is part of iNewsGroup.

    iNewsGroup is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    iNewsGroup is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with iNewsGroup.  If not, see <http://www.gnu.org/licenses/>.

*/

#import "ThreadView.h"

//TODO: move any functionality that needs this into newsfunctions where it belongs!
#import "tin.h"
#import <GraphicsServices/GraphicsServices.h>
#import "ViewController.h"
#import "GroupView.h"
#import "consts.h"

static ThreadView * sharedInstance = nil;

@implementation ThreadView

+ (ThreadView *) sharedInstance
{
	if ( sharedInstance )
		return sharedInstance;

	//else

	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin. x = rect.origin.y = 0;
	sharedInstance = [[ThreadView alloc] initWithFrame: rect ]; 

	return sharedInstance;
}

- (id) initWithFrame: (CGRect) rect
{
	[super initWithFrame: rect];

	UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(
		0.0f, 0.0f, 320.0f, 48.0f)];

	_titleItem = [ [UINavigationItem alloc] initWithTitle: L_THREADVIEW ];//better name?? lol
	[nav showButtonsWithLeftTitle: L_BACK rightTitle: nil leftBack: YES ];
	//'Next' button in the nav bar to browse threads??
	//(maybe put prev/next in a bottom bar....?)
	 
	[nav pushNavigationItem: _titleItem];
	[nav setDelegate: self];	
	[nav setBarStyle: 0];

	_rows = [ [ NSMutableArray alloc] init ];

	_table = [[UITable alloc] initWithFrame: CGRectMake(0.0f, 48.0f,
		320.0f, 480.0f - 16.0f - 48.0f)];
	//col_subj
	UITableColumn * col = [[UITableColumn alloc] initWithTitle: @"thread"
		identifier: @"thread" width: 320.0f]; //200.0f or so
	
	[_table addTableColumn: col]; 
	[_table setDataSource: self];
	[_table setDelegate: self];
	[_table setSeparatorStyle: 1];
	[_table reloadData];


	[self addSubview: nav];
	[self addSubview: _table];
	
	return self;
}


- (void)tableRowSelected:(NSNotification *)notification {
//  NSLog(@"tableRowSelected!");
	int i = [ _table selectedRow ], j, k=0;

	if ( i != MAX_INT )
  	{

//		NSLog( @" looking for: %d", i );
		for_each_art_in_thread( j, _threadnum )
		{
	//		NSLog( @"considering article: %d\n\n", j );
			if ( i == k ) break;
			k++;
		}
		if ( i == k )
		{
			NSLog ( @"opening article : %d\n\n", j );	
			[ [ PostView sharedInstance ]  setArticleNum: j  andGroupnum: _groupnum ];
			[ [ViewController sharedInstance ] setView: [ PostView sharedInstance ] slideFromLeft: YES ];
			[ [ PostView sharedInstance ] refresh ];
		}
		else
		{
			NSLog ( @"Error finding article in thread! :-(" );
		}
	}

}

- (void) refresh
{
//	NSLog( @"refreshing thread view..." );
	int i;
	ThreadViewItem * row;
	while( [ _rows count ]> 0 )
	{
		id rowobj = [ _rows objectAtIndex: 0 ];
		[ _rows removeObjectAtIndex: 0 ];
		[ rowobj release ];

	}
	for_each_art_in_thread( i, _threadnum )
	{
		row = [[ThreadViewItem alloc] initWithArticle: i ];
		[ row setDisclosureStyle: 2 ];
		[ row setShowDisclosure: YES ];
		[ _rows addObject: row ];
	}
	[ _titleItem setTitle: [NSString stringWithCString: arts[ base[ _threadnum ] ].subject ] ];
	[ self refreshTitles ];
	
	[ _table reloadData ];

	[ _table selectRow: -1 byExtendingSelection: NO ];

}


- (void) refreshTitles
{
	int i = 0, art;
	ThreadViewItem * cell;
	for(; i < [ _rows count]; i++)
	{
		cell = [ _rows objectAtIndex: i ];
		art = [cell article];
		[ cell setTitle: [NSString stringWithFormat: @"%s", 
				arts[ art ].subject ] ];

		UIImage * img = [UIImage applicationImageNamed:
			arts[ art ].status != ART_READ ?
				IMG_UNREAD : IMG_READ ];
		[ cell setImage: img ];

	}

}



- (void) setGroupNum: (int) groupnum andThreadNum: (int) threadnum
{
	_groupnum = groupnum;
	_threadnum = threadnum;
	while( [ _rows count ] > 0 )
	{
		id row = [ _rows objectAtIndex: 0 ];
		[ _rows removeObjectAtIndex: 0 ];
		[ row release ];

	}
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

- (float)table:(UITable *)aTable heightForRow:(int)row {
	return [ [ _rows objectAtIndex: row ] rowHeight ];
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
		[ [ GroupView sharedInstance ] refreshTitles ];
		[ [ ViewController sharedInstance] setView: [GroupView sharedInstance] slideFromLeft: NO ];
	}

}


@end






@implementation ThreadViewItem

- (id) initWithArticle: (int) artnum
{
	[super initWithFrame: CGRectMake( 0.0f, 0.0f, 320.0f, 128.0f )];

	//set font to use....
	[ [self titleTextLabel]setFont: GSFontCreateWithName( THREAD_FONT , kGSFontTraitBold, THREAD_SIZE ) ];	
	[ [self titleTextLabel] setWrapsText: YES ];

	_articleID = artnum;

	//prepare the date
	_dateLabel = [[UIDateLabel alloc] initWithFrame: CGRectMake(210.0f, 10.0f, 65.0f, 30.0f)];
	[ _dateLabel setDate: [ NSDate dateWithTimeIntervalSince1970: arts[ artnum ].date ] ];
	[ _dateLabel setCentersHorizontally: YES];

	//prepare the 'from' label
	_fromLabel = [ [UITextLabel alloc] initWithFrame: CGRectMake(210.0f, 40.0f, 65.0f, 25.0f ) ];
	[ _fromLabel setFont: GSFontCreateWithName( THREAD_SENDER_FONT , kGSFontTraitBold, THREAD_SENDER_SIZE ) ];	

	[ _fromLabel setText: (id)getSenderForArt( artnum ) ];
	[ _fromLabel setCentersHorizontally: NO ];


	//prepare colors so it highlights properly... sigh

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	float white[4] = { 1., 1., 1., 1. };
	float transparentWhite[4] = { 1., 1., 1., 0. };

	[ _dateLabel setHighlightedColor:CGColorCreate(colorSpace, white ) ];
	[ _dateLabel setBackgroundColor:CGColorCreate(colorSpace, transparentWhite ) ];
		
	[ _fromLabel setHighlightedColor:CGColorCreate(colorSpace, white ) ];
	[ _fromLabel setBackgroundColor:CGColorCreate(colorSpace, transparentWhite ) ];

	//add the labels to ourself
	[ super addSubview: _dateLabel ];
	[ super addSubview: _fromLabel ];

	return self;
}

- (void) layoutSubviews
{
	[ super layoutSubviews ];
	CGRect rect = CGRectMake( 32.0f, 0.0f, 185.0f, 16.0f * [self numLines ] );
	//center it vertically
	rect.origin.y = ( (64.0f - 16.0f * [self numLines ])/ 2.0f  );	
 
	[ [ self titleTextLabel] setFrame: rect ];	

	[ _dateLabel setFrame: CGRectMake( 210.0f, 10.0f, 65.0f, 30.0f ) ];
	[ _fromLabel setFrame: CGRectMake( 210.0f, 40.0f, 65.0f, 25.0f ) ];
}


- (int) article
{
	return _articleID;
}

- (int) numLines
{
	return 1 + ( [_titleTextLabel textSize].width ) / 180;
}

- (float) rowHeight
{
	return 64.0f;

}

- (void) updateHighlightColors
{

//	NSLog( @"updateHighlightColors" );
	[ super updateHighlightColors ];

	[ _dateLabel setHighlighted: [ [ self titleTextLabel ] isHighlighted ] ];

}


@end
