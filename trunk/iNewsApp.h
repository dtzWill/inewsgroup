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
	UINavigationBar * _navTop;

	int _count, _selectedRow;

	UIWindow * _window;
	UIView * _mainView;
    UITable * _table;
	UIAlertSheet * _connect;
//    NewsListView * root;//root view
}
- (id)_initWithArgc:(int)fp8 argv:(const char **)fp12;	// IMP=0x323b6ab0

+ (iNewsApp *) sharedInstance;

- (void) connect;

- (UIView *) mainView;

- (void) exitMe;

@end


