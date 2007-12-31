//Will Dietz
//PrefsView.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UIPreferencesTextTableCell.h>

//View to allow the user to set/update/modify their preferences


//local defines for our rows...
#define SERVER_ROW 0
#define USER_ROW 1
#define PASS_ROW 2
#define EMAIL_ROW 3
#define NAME_ROW 4

@interface PrefsView: UIView
{
	UIPreferencesTable * _prefTable;
	UIPreferencesTableCell * _prefHeader;
	UIPreferencesTableCell * _prefAboutHeader;

	//array holding the preferences entries
	NSMutableArray * _rows;

	//array holding the arrays displaying the 'about' information
	NSMutableArray * _rowsAbout;
	UINavigationItem * _titleItem;
	id _delegate; //go back to main view! :)
} 

//singleton
+ (PrefsView *) sharedInstance;

- (id) initWithFrame: (CGRect) rect;

- (void) setDelegate: (id) delegate;

//call this to tell us to fetch/loud our values
- (void) loadSettings;

//call this to tell us to commmit/save our values
- (void) saveSettings;


@end
