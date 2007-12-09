//Will Dietz
//ComposeView.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import <UIKit/UITextView.h>

//Prepare a post

#define SUBJECT_ROW 0
#define CONTENT_ROW ( SUBJECT_ROW + 1 )

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

- (void) getPost;

- (void) setDelegate: (id) delegate; //are YOU my mommmy?

//- (void) returnToPage;


@end

