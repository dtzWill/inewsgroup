//Will Dietz'
//SubscriptionView.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UIPreferencesControlTableCell.h>

@interface SubscriptionView : UIView
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


@interface SubPrefItem: NSObject
{
	UIPreferencesControlTableCell * row; //==0 when invalid/not created yet
	NSString * title;
	int index;//so we know which one this corresponds to after sorting	

}
-(UIPreferencesControlTableCell *) getRow;

- (id) initWithID: (int) subid;

- (bool) isInitialized;

- (bool) switchValue;

- (int) getIndex;

- (NSComparisonResult)compareSubscription:(SubPrefItem *)s;

- (NSString *) getTitle;

@end

