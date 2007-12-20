//Will Dietz
//ComposeView.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import <UIKit/UITextField.h>
#import <Message/PlainTextDocument.h>
#import "EditTextView.h"
#import "EditorKeyboard.h"

//Compose a message, and send it

//globals:

//keys for passing us information to start the message with
static NSString * kSubject = @"subj";//editable
static NSString * kNewsGroup = @"groups";//set
static NSString * kQuoteContent = @"quote";//hmmm
static NSString * kReferences = @"ref";//set

//HORRIBLE HACK :-/
static const float KEYBOARD_DELAY=0.5f;


//#define SUBJECT_ROW 0
//#define  
//#define CONTENT_ROW ( SUBJECT_ROW + 1 )

@interface ComposeView: UIView
{

	/*All messages need the following:
	
		-From --NOT editable
		-Newsgroup(s) to post to (for now, just one)
		-Subject
		-Message content
	*/
	int _postnum, _groupnum;

	CGRect _rectSmall;
	CGRect _rectBig;
	bool _keyboardShown;
	bool _editingMessage;
	bool _keyboardTransitioning;
	EditTextView * _textView;
	UINavigationBar * _nav;
	EditorKeyboard * _keyboard;
    NSMutableArray * _rows;// holds the row objects for our table 
    UINavigationItem * _titleItem;//title
    UITable * _table;
	UIAlertSheet * _message;

	//message-specific
	NSString * _subject;
	NSString * _newsgroup;
	NSMutableArray * _references;
	

}

+ (ComposeView *)sharedInstance;

- (id) initWithFrame: (CGRect) rect;

- (void) startNewMessage: (NSDictionary *) items;

- (void) emptyOldMessage;

@end

