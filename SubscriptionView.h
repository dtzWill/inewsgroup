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
	NSMutableArray * _rows, * _curRows;

	UIAlertSheet * _refresh;
	UIAlertSheet * _search;

	NSMutableArray * _memoryQueue; //simple fix until implement drill-down
	UINavigationItem * _titleItem;
	UINavigationItem * _titleFilter;
} 

//singleton
+ (SubscriptionView *) sharedInstance;

- (id) initWithFrame: (CGRect) rect;

//method called by other views to initiate the sheet being shown, and the proper init'ing being done...
- (void) refreshMe;

- (void) delayedInit; //the actual init process

//call this to have us load our settings
- (void) loadSettings;

//call this to have us commit our settings
//in this case, this means subscribing/unsubscribing according to changes
- (void) saveSettings;


@end


//represents a row in the table, a 'group'
@interface SubPrefItem: NSObject
{
	NSMutableArray * rowArray; //pointer to array that stores all the rows
								//they all should have the same one
							//TODO: change this so they DO use all the same one
	NSString * title;
	bool value;//store value even when row is invalid
	int index;//so we know which one this corresponds to after sorting	

}
-(UIPreferencesControlTableCell *) getRow;

- (id) initWithID: (int) subid withRows: (NSMutableArray *) array;

- (bool) switchValue;

- (int) getIndex;

- (NSComparisonResult)compareSubscription:(SubPrefItem *)s;

- (NSString *) getTitle;

@end

