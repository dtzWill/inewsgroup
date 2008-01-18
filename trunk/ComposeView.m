//Will Dietz
//ComposeView.m
//Compose a message, and sent it.

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

#import "ComposeView.h"
#import "ViewController.h" 
#import <UIKit/UIKit.h>
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UISimpleTableCell.h>
#import "newsfunctions.h"
#import "EditableRowCell.h" 
#import "consts.h"
#import "iNewsApp.h"

static ComposeView * sharedInstance = nil;

@implementation ComposeView

//singleton
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

	_nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(
	    0.0f, 0.0f, 320.0f, 48.0f)];

	//set title to some default until we load the first article, and that'll overwrite it
	_titleItem = [ [UINavigationItem alloc] initWithTitle: L_COMPOSE ];
	
	//setup the nav bar
	[ _nav showLeftButton: L_CANCEL withStyle: BUTTON_BACK rightButton: L_SEND withStyle: BUTTON_BLUE ];	
	[ _nav pushNavigationItem: _titleItem];
	[ _nav setDelegate: self];	
	[ _nav setBarStyle: 0];

	//'sending...' alert on the bottom
	_sending = [[UIAlertSheet alloc]initWithTitle: L_SEND_MSG buttons:nil defaultButtonIndex:1 delegate:self context:self];
	[_sending setDimsBackground:YES];

	_result = [[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 240, 200, 240)];
	[ _result addButtonWithTitle: L_OK ];
	[ _result setDelegate:self];
	
	NSArray *btnArry = [ _result buttons];
	
	[ _result setDefaultButton: [btnArry objectAtIndex: 0]];
	
	[ _result setAlertSheetStyle: 1];
	
	_keyboardTransitioning = false;
	_editingMessage = false;

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
	[ _table setAllowsRubberBanding: NO ];	


	//go below the headers, no keyboard
	_rectBig = CGRectMake(0.0f, 48.0f + 96.0f,
		320.0f, 480.0f - 16.0f - 48.0f - 96.0f );

	//cover up the header table, keyboard
	_rectSmall = CGRectMake(0.0f, 48.0f ,
		320.0f, 480.0f - 16.0f - 48.0f -220.0f );

	NSLog( @"small: %d, big: %d", _rectSmall.size.height, _rectBig.size.height );
	
	//text view to show the message data...
	_textView = [[EditTextView alloc] initWithFrame: _rectBig ];
	[ _textView setTextSize: 20 ];
	[ _textView setDelegate: self ];
	[ _textView setAllowsRubberBanding: YES ];	

	//Keyboard:
    _keyboard = [[EditorKeyboard alloc]
		    initWithFrame:CGRectMake(0.0f, 480.0f, 320.0f, 480.0f ) ];


	//add the various views to ourself..
	[ self addSubview: _nav];
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

	NSString * tmp;
	
//	NSLog( @"getting subject" );
	_subject = [ NSString stringWithString: ( ( tmp = [ items objectForKey: kSubject ] ) ? tmp : @"" ) ];

//	NSLog( @"getting newsgroup" );
	_newsgroup = [ [ NSString stringWithString: ( ( tmp = [ items objectForKey: kNewsGroup ]) ? tmp : @"" ) ] retain ];

	_references = [ [ NSString stringWithString: ( ( tmp = [ items objectForKey: kReferences ] ) ? tmp : @"" ) ] retain ];


//	NSLog( @"Getting quote" );

	NSMutableString * quote = [ items objectForKey: kQuoteContent ];

	if ( quote )
	{
	//process quote and add the '>'s and tack to the end of 'content'
		NSArray * lines = [ quote componentsSeparatedByString: @"\n" ];
		quote = [ NSMutableString stringWithString: L_QUOTE ];
		NSEnumerator * enumerator = [ lines objectEnumerator ];
		NSString * obj;
		NSLog( @"Count: %d", [ lines count ] );
		while ( obj = [ enumerator nextObject ] )
		{
			[ quote appendFormat: L_QUOTE_FORMAT, obj ]; 
		}


	}

	UISimpleTableCell * row;
	EditableRowCell * rowEdit;

//	NSLog( @"preparing from row" );
	//from
	row = [[UISimpleTableCell alloc] init ];
	[ row setTitle: getFromString() ];
	[ row setFont: GSFontCreateWithName( HEADER_FONT , kGSFontTraitBold, HEADER_SIZE ) ];	
	[ _rows addObject: row]; 

///	NSLog( @"preparing subject row" );
	//subject	
	rowEdit = [[EditableRowCell alloc] init];
	[ rowEdit setTitle: L_SUBJ ];
	[ rowEdit setValue: _subject ];
	[ rowEdit setDelegate: self ];
	[ [ rowEdit textField] setFont: GSFontCreateWithName( HEADER_FONT , kGSFontTraitBold, HEADER_SIZE ) ];	
	[ _rows addObject: rowEdit ];

//	NSLog( @"preparing newsgroup row" );
	//newsgroup
	row = [[UISimpleTableCell alloc] init];
	[ row setTitle: [NSString stringWithFormat: L_NEWSGROUP_FORMAT, _newsgroup ] ];
	[ row setFont: GSFontCreateWithName( HEADER_FONT , kGSFontTraitBold, HEADER_SIZE ) ];	
	[ _rows addObject: row];
	

	[ _table reloadData];

	if ( quote )
	{
		[ _textView setText: quote ];
		[ _textView setSelectionToStart ];	
	}

//	NSLog( @"done with textField" );
	
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

	[ _textView setText: @"" ];
	
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
		if ( _editingMessage) //'done', we should close the keyboard and go back to normal view
		{

			[ self toggleKeyboardFor: self ];	
		}
		else
		{ //send! try to send this message.....
			//gui timer so the thing actually displays
			[NSTimer scheduledTimerWithTimeInterval: REFRESH_TIME target:self selector:@selector(sendMessage) userInfo:nil repeats:NO];	
				
			//show 'Sending...' message
			[ _sending presentSheetInView: self ];

			

		}


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
//Alert handling:

//callback method to send the message
- (void) sendMessage
{
	[ _sending dismiss ];
	NSString * msg;

	if ( !sendMessage( _newsgroup, _references, [ [ _rows objectAtIndex: 1 ] value ] , [ _textView text ] ) )
	{
		switch( ppa_err ) //what happened?
		{
			case PPA_ERR_NO_MAIL: //no mail was found to send
			case PPA_ERR_FAILED_ART_FETCH://couldn't fetch the article, possibly malformed, etc
				//send error regarding bad article
				msg = L_ERROR_PROCESSING_MAIL;
				break;
			case PPA_ERR_SERVER:
				//server denied
				msg = L_ERROR_SERVER_DENIED;
				break;
			case PPA_ERR_GLOBAL_ERR:
			default:
				//application error... not sure what to do here
				msg = L_ERROR_APPLICATION_ERROR;
				break;
		}

	}
	else
	{
		msg = L_SENT;
	}
	NSLog( @"ppa_err: %d", ppa_err );
	[ _result setTitle: msg ];
	[ _result presentSheetFromAboveView: self ];

}

- (void)alertSheet: (UIAlertSheet *)sheet buttonClicked: (int)button
{
	if ( sheet == _result )
	{
		[ _result dismiss ];
			//go back!
			[ [ ViewController sharedInstance ] 
					setView: [ [ ViewController sharedInstance ] getPrevView ]
					slideFromLeft: NO ];
	
	}
	else
	{
		NSLog ( @"FIXME: Got to buttonClicked, and it wasn't one of the sheets we expected" );
	}

}

///////////////////////////////////////////////////////////////////////////////////////////////
//textfield:

- (void)adjustForShownKeyboard
{
	//adjust the message container to cover the headers, as well as move for the keyboard
	[_textView setBottomBufferHeight:(5.0f)];
	[_textView setFrame: _rectSmall ]; 

	//change navigationbar buttons
	
	[ _nav showLeftButton: nil withStyle: BUTTON_NORMAL rightButton: L_DONE withStyle: BUTTON_RED ];	// IMP=0x323d7894
	_editingMessage = true;	

	[ self keyboardTransitionOver ];
}

- (void)adjustForHiddenKeyboard
{
	//move back to where it was originally
	[_textView setFrame: _rectBig ];
	[ self keyboardTransitionOver ];

	//revert the buttons
	[ _nav showLeftButton: L_CANCEL withStyle: BUTTON_BACK rightButton: L_SEND withStyle: BUTTON_BLUE ];	// IMP=0x323d7894
	_editingMessage = false;


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
			return;	//don't let the user's tapping in the message dialog close it
		}
    	else if ( sender == self )
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

