//Will Dietz
//NewsListView.h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UINavigationItem.h>

@interface NewsListView : UIView
{
	NSString * _path;
	NSMutableArray * _items;
	int _rowcount; 
	UITable * _table;
	UINavigationItem * _titleItem;
	id _delegate;
	UIView * _parent;
}

- (void)refresh; //refresh the viewing....after a news update, for example
 
- (id)initWithFrame: (struct CGRect) rect withRoot: (NSString *) root andDelegate: (id) delegate;
//private:
- (id)initWithFrame:(struct CGRect)rect withRoot:(NSString *) root andDepth: (int) depth andDelegate: (id) delegate andParent: (UIView *) parent;

@end

