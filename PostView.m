//Will Dietz
//PostView.m

#import "PostView.h"

#import <UIKit/UISimpleTableCell.h>
#import <GraphicsServices/GraphicsServices.h>
#import "newsfunctions.h"
#import "ViewController.h"
#import "ComposeView.h"

static PostView * sharedInstance = nil;

@implementation PostView

+ (PostView *) sharedInstance
{
	if ( sharedInstance )
		return sharedInstance;

	//else

	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin. x = rect.origin.y = 0;
	sharedInstance = [[PostView alloc] initWithFrame: rect ]; 

	return sharedInstance;
}


- (id) initWithFrame: (CGRect) rect
{
	[super initWithFrame: rect];

	UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(
	    0.0f, 0.0f, 320.0f, 48.0f)];

	//set title to some default until we load the first article, and that'll overwrite it
	_titleItem = [ [UINavigationItem alloc] initWithTitle: L_POSTVIEW ];//better name?? lol
	
	//setup the nav bar
	[nav showLeftButton: L_BACK withStyle: BUTTON_BACK rightButton: L_REPLY withStyle: BUTTON_BLUE ];
//	[ nav setButton: 1 enabled: force_no_post ];
	[nav pushNavigationItem: _titleItem];
	[nav setDelegate: self];	
	[nav setBarStyle: 0];

	//set up the ui message telling the user we're loading... but also preventing the user from using the ui :)
	_message = [[UIAlertSheet alloc]initWithTitle: L_LOADING_MSG buttons:nil defaultButtonIndex:1 delegate:self context:self];
	[_message setDimsBackground:YES];
	
	_prevView = nil;
	_prevDir = NO;

	//create our array...
	_rows = [ [ NSMutableArray alloc] init ];

	//create our table...
	_table = [[UITable alloc] initWithFrame: CGRectMake(0.0f, 48.0f,
	    320.0f, 64.0f )];//480.0f - 16.0f - 48.0f - 350.0f)];
	//col_subj
	UITableColumn * col = [[UITableColumn alloc] initWithTitle: @"post"
	    identifier: @"post" width: 320.0f];
	//finish initializing our table...
	[_table addTableColumn: col]; 
	[_table setDataSource: self];
	[_table setDelegate: self];
	[_table reloadData];

	
	//text view to show the message data...
	_textView = [[UITextView alloc] initWithFrame: CGRectMake(0.0f, 48.0f + 64.0f,
		320.0f, 480.0f - 16.0f - 48.0f - 64.0f )]; 
	

	//add the various views to ourself..
	[self addSubview: nav];
	[self addSubview: _table];
	[self addSubview: _textView];
	
	//done!
	return self;
}


//call this to have us fetch the actual article information and update the gui accordingly
- (void) refresh
{
	//show the message
	[_message presentSheetInView: self ];	
	//clear the rows... TODO: do we have to dealloc each of the rows...? god i hate obj-c
	[_rows removeAllObjects ];
	//does this actually update the title? (does navbar need to be refreshed or something...?)
	[_titleItem setTitle: L_LOADING ];
	//tell the ui to re-get it's row data
	[_table reloadData ];
	//empty the textView
	[_textView setText: @""];

	//set timer to call us back on getPost--allow the gui to update itself
    [NSTimer scheduledTimerWithTimeInterval: REFRESH_TIME target:self selector:@selector(getPost) userInfo:nil repeats:NO];	
}

- (void) getPost
{
//	NSLog( @" trying to open article %d of group %d", _postnum, _groupnum );

	//tell the server which article we want
	if ( openArticle( _groupnum, _postnum ) )
	{
		
		//actually go get all the data and parse it.... 
		NSString * body = readArticleContent();
 
		UISimpleTableCell * row;

		//from
		row = [[UISimpleTableCell alloc] init ];
		[ row setTitle: articleFrom() ];
		[ row setFont: GSFontCreateWithName("Helvetica", kGSFontTraitBold,16) ];	
		[ _rows addObject: row]; 

		//subject	
		row = [[UISimpleTableCell alloc] init];
		[ row setTitle: ( _subject = articleSubject() ) ];
		[ row setFont: GSFontCreateWithName("Helvetica", kGSFontTraitBold,16) ];	
		[ _rows addObject: row];

		[ _table reloadData];

		//display subject as our title
		[ _titleItem setTitle: articleSubject() ];

		[ _textView setTextSize: 14 ];
		[ _textView setText: body ];
//		[ _textView recalculateStyle ]; //TODO: needed? what does this DO? 

		_references = [ getReferences( _postnum ) retain ];
	//	NSLog( @"refs: %@", _references );

		//no longer need the article....
		closeArticle();
	}

	//begin fix the 'starts not viewing top' bug
	CGRect r = CGRectMake( 0 , 0, 1, 1 );

	[ _textView scrollRectToVisible: r ]; 
	//end fix
	[ _textView setSelectionToStart ];


	//no longer need the message.. allow the user to use the UI again
	[_message dismiss ];


	//since we're displaying it, assume the user has read it
	markArticleRead( _groupnum, _postnum );

}

//specify the article number and the groupnumber we're an article in
- (void) setArticleNum: (int) artnum andGroupnum: (int) groupnum
{
		_postnum = artnum;
		_groupnum = groupnum;
		//TODO: dealloc each row?
		[_rows removeAllObjects];
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
			NSLog ( @"Reply to message!" );

			NSString * subject;

			if ( !strncmp( [ _subject cString ], "Re:", 3 ) ) //if it started with "Re:" already 
			{
				subject = [NSString stringWithString: _subject ]; //just pass it through
			}
			else
			{
				subject = [NSString stringWithFormat: @"Re: %@", _subject ];
			}


			NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				[ subject retain ], kSubject,
				[ [NSString stringWithCString: active[ my_group[ _groupnum ] ].name ] retain ], kNewsGroup,		
				[ _textView text ], kQuoteContent,
				_references, kReferences,	
					nil];
			//NSLog( @"dict created!" );

			[ [ ComposeView sharedInstance ] startNewMessage: dict ];

			if ( !_prevView )
			{//if we don't already 'know' where we came from.. save it
				_prevView = [ [ ViewController sharedInstance ] getPrevView ];
				_prevDir = [ [ ViewController sharedInstance ] getPrevDir ];
			}
			[ [ ViewController sharedInstance ] setView: [ ComposeView sharedInstance] slideFromLeft: YES ];


	}
	else
	{

		//Go back to previous view.. whichever called us, and in the opposite direction
		if( !_prevView)
		{
			UIView<TitleRefresher> * view = [ [ ViewController sharedInstance ] getPrevView ];
			[ view refreshTitles ];
			[ [ ViewController sharedInstance ] 
					setView: view
					slideFromLeft: ![ [ ViewController sharedInstance] getPrevDir ] ];
		}
		else
		{
			[ _prevView refreshTitles ];
			[ [ ViewController sharedInstance] setView: _prevView slideFromLeft: !_prevDir ];
			_prevView = nil;//reset

		}
	}

}

@end
