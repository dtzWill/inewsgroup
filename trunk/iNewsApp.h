//Will Dietz
//iNewsApp.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UIImageAndTextTableCell.h>

#import "iNewsApp.h"
#import "PrefsView.h"
#import "GroupView.h"
#import "SubscriptionView.h"

@interface iNewsApp : UIApplication {
    NSMutableArray * _rows;// holds the row objects for our table 
    UINavigationItem * _titleItem;//title
	int _count;
	UIWindow * _window;
	UIView * _mainView;
	PrefsView * _prefs; 
	GroupView * _group;
	SubscriptionView * _subs;
    UITable * _table;
	UIAlertSheet * _connect;
//    NewsListView * root;//root view
}

- (void) returnToMain;

- (void) setView: (UIView *) view;

- (void) connect;

@end


