//Will Dietz
//GroupView.h

//We're only going to have one instance of this, and just change what it represents on the fly.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>

@interface GroupView: UIView
{
	int _groupnum;//index in my_group
	
    NSMutableArray * _rows;// holds the row objects for our table 
    UINavigationItem * _titleItem;//title
    UITable * _table;
	id _delegate;
	UIAlertSheet * _connect;

}

- (id) initWithFrame: (CGRect) rect;

- (void) setGroupNum: (int) groupnum;

- (void) refreshMe;

- (void) getArticles; 

- (void) setDelegate: (id) delegate;

@end
