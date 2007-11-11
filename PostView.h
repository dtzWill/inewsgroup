//Will Dietz
//PostView.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import <UIKit/UITextView.h>

//Show a given post.  Assumes article header is loaded, and located at arts[i] 

#define FROM_ROW 0
#define SUBJECT_ROW ( FROM_ROW + 1 )
#define DATE_ROW ( SUBJECT_ROW + 1 )
#define CONTENT_ROW ( DATE_ROW + 1 )

@interface PostView: UIView
{
	int _postnum, _groupnum;

	UITextView * _textView;
    NSMutableArray * _rows;// holds the row objects for our table 
    UINavigationItem * _titleItem;//title
    UITable * _table;
	UIAlertSheet * _message;
	id _delegate;
}

- (id) initWithFrame: (CGRect) rect;

- (void) setArticleNum: (int) artnum andGroupnum: (int) groupnum;

- (void) refresh;

- (void) setDelegate: (id) delegate; //are YOU my mommmy?

@end


