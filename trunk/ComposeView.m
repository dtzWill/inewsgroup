//Will Dietz
//ComposeView.m

#import "ComposeView.h"
#import "ViewController.h" 
#import <UIKit/UIKit.h>
#import <UIKit/UISimpleTableCell.h>
#import "newsfunctions.h"

static ComposeView * sharedInstance = nil;

@implementation ComposeView

+ (ComposeView *)sharedInstance
{
	if ( sharedInstance )
		return sharedInstance;

	//else

	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin. x = rect.origin.y = 0;
	sharedInstance = [[ComposeView alloc] initWithFrame: rect ]; 

	return sharedInstance;
}

- (id) initWithFrame: (CGRect) rect
{

	[super initWithFrame: rect];

	UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(
	    0.0f, 0.0f, 320.0f, 48.0f)];

	//set title to some default until we load the first article, and that'll overwrite it
	_titleItem = [ [UINavigationItem alloc] initWithTitle: @"Compose" ];//better name?? lol
	
	//setup the nav bar
	[nav showButtonsWithLeftTitle: @"Cancel" rightTitle: @"Send" leftBack: YES ];
	[nav pushNavigationItem: _titleItem];
	[nav setDelegate: self];	
	[nav setBarStyle: 0];

	//set up the ui message telling the user we're loading... but also preventing the user from using the ui :)
	_message = [[UIAlertSheet alloc]initWithTitle:@"Sending Message..." buttons:nil defaultButtonIndex:1 delegate:self context:self];
	[_message setDimsBackground:YES];
	
	//create our array...
	_rows = [ [ NSMutableArray alloc] init ];

	//create our table...
	_table = [[UITable alloc] initWithFrame: CGRectMake(0.0f, 48.0f,
	    320.0f, 48.0f + 80.0f )];//480.0f - 16.0f - 48.0f - 350.0f)];
	//col_subj
	UITableColumn * col = [[UITableColumn alloc] initWithTitle: @"msg"
	    identifier: @"msg" width: 320.0f];
	//finish initializing our table...
	[_table addTableColumn: col]; 
	[_table setDataSource: self];
	[_table setDelegate: self];
	[_table reloadData];

	
	//text view to show the message data...
	_textView = [[UITextView alloc] initWithFrame: CGRectMake(0.0f, 48.0f + 80.0f,
		320.0f, 480.0f - 16.0f - 48.0f - 80.0f )]; 
	[ _textView setEditable: YES ];

	//add the various views to ourself..
	[self addSubview: nav];
	[self addSubview: _table];
	[self addSubview: _textView];
	
	//done!
	return self;




}


- (void) startNewMessage: (NSDictionary *) items;
{
//	NSLog( @"clearing old message data..." );
	[self emptyOldMessage ];
	
//	NSLog( @"getting subject" );
	_subject = [ items objectForKey: kSubject ];
	if ( !_subject) _subject = @"";

//	NSLog( @"getting newsgroup" );
	_newsgroup = [ items objectForKey: kNewsGroup ];
	if ( !_newsgroup ) _newsgroup = @"";

	_references = nil;

//	NSLog( @"Getting quote" );
	NSString * quote = [ items objectForKey: kQuoteContent ];

	//process quote and add the '>'s and tack to the end of 'content'


	PlainTextDocument * ptd = [ [ PlainTextDocument alloc] init ];
//	NSLog( @"adding quote" );
	if ( quote )
	{
		[ ptd appendString: quote withQuoteLevel: 1 ];	
	}
//	NSLog( @"printing string:" );
	NSLog( [ ptd string ] );	

	UISimpleTableCell * row;

//	NSLog( @"preparing from row" );
	//from
	row = [[UISimpleTableCell alloc] init ];
	[ row setTitle: getFromString() ];
	[ _rows addObject: row]; 

	NSLog( @"preparing subject row" );
	//subject	
	row = [[UISimpleTableCell alloc] init];
	[ row setTitle: _subject ];
	[ _rows addObject: row];

	[ _table reloadData];

	[ _textView setTextSize: 12 ];
	[ _textView setText: [ptd string ] ];
	[ _textView recalculateStyle ]; //TODO: needed? what does this DO? 

	[ptd release ];
	
}

- (void) emptyOldMessage
{
//	[_subject release];
//	[_newsgroup release];
//	[_references release];

	NSLog( @"removing rows" );
	while( [_rows count] > 0 )
	{
		id element= [ _rows lastObject ];
		[ element release ];
		[ _rows removeLastObject ];
	}

}

////////////////////////////////////////////////////////////////////////////////////////////////
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

////////////////////////////////////////////////////////////////////////////////////////////////
//nav bar button handler
- (void)navigationBar:(UINavigationBar*)bar buttonClicked:(int) which;
{
//	NSLog( @"button pressed, which: %d", which );
	if ( which == 0 ) //right
	{
	//nothing for now.... there /is/ no right button :)
	}
	else
	{

		//Go back to previous view.. whichever called us, and in the opposite direction

		[ [ ViewController sharedInstance ] 
				setView: [ [ViewController sharedInstance ] getPrevView ]
				slideFromLeft: ![ [ ViewController sharedInstance] getPrevDir ] ];
	}

}






@end

