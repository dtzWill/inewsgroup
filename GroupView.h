//Will Dietz
//GroupView.h

//We're only going to have one instance of this, and just change what it represents on the fly.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import "ThreadView.h"
#import "PostView.h"

@interface GroupView: UIView
{
	int _groupnum;//index in my_group
	
    NSMutableArray * _rows;// holds the row objects for our table 
    UINavigationItem * _titleItem;//title
	ThreadView * _threadView;
	PostView * _postView;
    UITable * _table;
	id _delegate;
	UIAlertSheet * _connect;

}

- (id) initWithFrame: (CGRect) rect;

- (void) setGroupNum: (int) groupnum;

- (void) refreshMe;

- (void) getArticles; 

- (void) refreshTitles;

- (void) setDelegate: (id) delegate;

- (void) setView: (UIView *) view;

- (void) returnToPage;

@end


@interface GroupItem: UISimpleTableCell
{
	int _threadnum;

}

- (id) initWithThreadNum: (int) threadnum;

- (int) threadNum;
@end
