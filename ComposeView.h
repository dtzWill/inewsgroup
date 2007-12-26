//Will Dietz
//ComposeView.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import <UIKit/UITextField.h>
#import "EditTextView.h"
#import "EditorKeyboard.h"
#import "EditableRowCell.h" 
//Compose a message, and send it



//#define SUBJECT_ROW 0
//#define  
//#define CONTENT_ROW ( SUBJECT_ROW + 1 )

@interface ComposeView: UIView <KeyboardToggler>
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
	NSString * _references;
	

}

+ (ComposeView *)sharedInstance;

- (id) initWithFrame: (CGRect) rect;

- (void) startNewMessage: (NSDictionary *) items;

- (void) emptyOldMessage;

- (void) toggleKeyboardFor: (id) sender;

- (void) keyboardTransitionOver;

@end

