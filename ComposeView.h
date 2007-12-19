//Will Dietz
//ComposeView.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import <UIKit/UITextView.h>
#import <Message/PlainTextDocument.h>

//Compose a message, and send it

//globals:

//keys for passing us information to start the message with
static NSString * kSubject = @"subj";//editable
static NSString * kNewsGroup = @"groups";//set
static NSString * kQuoteContent = @"quote";//hmmm
static NSString * kReferences = @"ref";//set


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

	UITextView * _textView;
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

