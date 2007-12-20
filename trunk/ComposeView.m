//Will Dietz
//ComposeView.m

#import "ComposeView.h"
#import "ViewController.h" 
#import <UIKit/UIKit.h>
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UISimpleTableCell.h>
#import "newsfunctions.h"
#import "EditableRowCell.h" 

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
	    320.0f, 96.0f )];
	//col_subj
	UITableColumn * col = [[UITableColumn alloc] initWithTitle: @"msg"
	    identifier: @"msg" width: 320.0f];
	//finish initializing our table...
	[_table addTableColumn: col]; 
	[_table setDataSource: self];
	[_table setDelegate: self];
	[_table reloadData];


	//go below the headers, no keyboard
	_rectBig = CGRectMake(0.0f, 48.0f + 96.0f,
		320.0f, 480.0f - 16.0f - 48.0f - 96.0f );

	//cover up the header table, keyboard
	_rectSmall = CGRectMake(0.0f, 48.0f ,
		320.0f, 480.0f - 16.0f - 48.0f -220.0f );

	NSLog( @"small: %d, big: %d", _rectSmall.size.height, _rectBig.size.height );
	
	//text view to show the message data...
	_textView = [[EditTextView alloc] initWithFrame: _rectBig ];
	[ _textView setDelegate: self ];

	//Keyboard:
    _keyboard = [[EditorKeyboard alloc]
		    initWithFrame:CGRectMake(0.0f, 480.0f, 320.0f, 480.0f ) ];


	//add the various views to ourself..
	[ self addSubview: nav];
	[ self addSubview: _table];
	[ self addSubview: _textView];
    [ self addSubview:_keyboard];

	[ self setOpaque: YES ];
	[ self setBackgroundColor: [ _textView backgroundColor ] ]; 
	
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


//	PlainTextDocument * ptd = [ [ PlainTextDocument alloc] init ];
//	NSLog( @"adding quote" );
//	if ( quote )
//	{
//		[ ptd appendString: quote withQuoteLevel: 1 ];	
//	}
//	NSLog( @"printing string:" );
//	NSLog( [ ptd string ] );	

	UISimpleTableCell * row;
	EditableRowCell * rowEdit;

//	NSLog( @"preparing from row" );
	//from
	row = [[UISimpleTableCell alloc] init ];
	[ row setTitle: getFromString() ];
	[ row setFont: GSFontCreateWithName("Helvetica", kGSFontTraitBold,16) ];	
	[ _rows addObject: row]; 

//	NSLog( @"preparing subject row" );
	//subject	
	rowEdit = [[EditableRowCell alloc] init];
	[ rowEdit setTitle: @"Subj:" ];
	[ rowEdit setValue: _subject ];
	[ rowEdit setDelegate: self ];
	[ [ rowEdit textField] setFont: GSFontCreateWithName("Helvetica", kGSFontTraitBold,16) ];	
	[ _rows addObject: rowEdit ];

//	NSLog( @"preparing newsgroup row" );
	//newsgroup
	row = [[UISimpleTableCell alloc] init];
	[ row setTitle: [NSString stringWithFormat: @"Newsgroup: %@", _newsgroup ] ];
	[ row setFont: GSFontCreateWithName("Helvetica", kGSFontTraitBold,16) ];	
	[ _rows addObject: row];
	
	_keyboardTransitioning = false;

	[ _table reloadData];
	NSLog( @"preparing textField" );
//	NSLog( @"Quote: %@", quote );
//	[ _textView setTextSize: 12 ];
	[ _textView setText: quote ];
//	[ _textField recalculateStyle ]; //TODO: needed? what does this DO? 
//	[ _textField setDelegate: self ];
//	[ _textField setEditable: YES ];
//	[ _textField performBecomeEditableTasks ];
	NSLog( @"done with textField" );

//	[ptd release ];
	
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

- (float)table:(UITable *)aTable heightForRow:(int)row {
	return 32.0f;
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

///////////////////////////////////////////////////////////////////////////////////////////////
//textfield:
/*
- (BOOL)textFieldShouldStartEditing: (UITextField *) view
{
	return YES;

}

- (BOOL)textFieldShouldEndEditing: (UITextField *) view
{
	return YES;
}
*/

- (void)adjustForShownKeyboard
{
	[_textView setBottomBufferHeight:(5.0f)];
	[_textView setFrame: _rectSmall ]; 
	[ self keyboardTransitionOver ];
}

- (void)adjustForHiddenKeyboard
{
	[_textView setFrame: _rectBig ];
	[ self keyboardTransitionOver ];
}

- (void)showKeyboard
{
    if( ! _keyboardShown && !_keyboardTransitioning )
    {
	[_keyboard show];

	_keyboardShown = YES;
	_keyboardTransitioning = YES;
    }
}


- (void)hideKeyboard
{
    if( _keyboardShown && !_keyboardTransitioning )
    {
	[_keyboard hide];

	_keyboardShown = NO;
	_keyboardTransitioning = YES;
    }
}

- (void)keyboardTransitionOver
{
	_keyboardTransitioning = false;
}

- (void)toggleKeyboardFor: (id) sender
{
    if( _keyboardShown )
    {
		if ( sender == _textView )
		{
		   [NSTimer scheduledTimerWithTimeInterval: KEYBOARD_DELAY target:self selector:@selector(adjustForHiddenKeyboard) userInfo:nil repeats:NO];	
		} else
		{
		   [NSTimer scheduledTimerWithTimeInterval: KEYBOARD_DELAY target:self selector:@selector(keyboardTransitionOver) userInfo:nil repeats:NO];	
		}
		[self hideKeyboard];
    }
    else
    {
    	if ( sender == _textView )
		{
			[NSTimer scheduledTimerWithTimeInterval: KEYBOARD_DELAY target:self selector:@selector(adjustForShownKeyboard) userInfo:nil repeats:NO];	
		} else
		{
		   [NSTimer scheduledTimerWithTimeInterval: KEYBOARD_DELAY target:self selector:@selector(keyboardTransitionOver) userInfo:nil repeats:NO];	
		}
		[self showKeyboard];
    }
}





- (BOOL)respondsToSelector:(SEL)aSelector
{
//	NSLog(@"COMPOSE: respondsToSelector: %@", NSStringFromSelector(aSelector));
    return [super respondsToSelector: aSelector];
}


@end

