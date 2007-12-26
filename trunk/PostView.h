//Will Dietz
//PostView.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import <UIKit/UITextView.h>
#import "TitleRefresher.h"

//Show a given post.  Assumes article header is loaded, and located at arts[i] 


@interface PostView: UIView
{
	int _postnum, _groupnum; //which article in what group is this??

	UIView<TitleRefresher> * _prevView;
	bool _prevDir;

	UITextView * _textView;//object used to view the text...
    NSMutableArray * _rows;//used to display the header information
    UINavigationItem * _titleItem;//title
	NSString * _subject;
	NSString * _references;
	//the usuals..
    UITable * _table;
	UIAlertSheet * _message;
}

//singleton
+ (PostView *) sharedInstance;

- (id) initWithFrame: (CGRect) rect;

//specify the article number and the groupnumber we're an article in
- (void) setArticleNum: (int) artnum andGroupnum: (int) groupnum;

//call this to have us fetch the actual article information and update the gui accordingly
- (void) refresh;

//do the actual 'getting' of the article, we're called as a callback from a timer set in refresh...
- (void) getPost;

@end


