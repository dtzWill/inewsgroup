//Will Dietz
//PrefsView.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UIPreferencesTextTableCell.h>

#define SERVER_ROW 0
#define USER_ROW 1
#define PASS_ROW 2

@interface PrefsView: UIView
{
	UIPreferencesTable * _prefTable;
	UIPreferencesTableCell * _prefHeader;
	NSMutableArray * _rows;
	UINavigationItem * _titleItem;
	id _delegate; //go back to main view! :)
} 

- (id) initWithFrame: (CGRect) rect;

- (void) setDelegate: (id) delegate;


- (void) loadSettings;

- (void) saveSettings;


@end
