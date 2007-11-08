//Will Dietz
//iNewsApp.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UIImageAndTextTableCell.h>

#import "datastructures.h"
#import "iNewsApp.h"

@interface iNewsApp : UIApplication {
    NSMutableArray * _rows;// holds the row objects for our table 
    UINavigationItem * _titleItem;//title
	int _count;
    UITable * _table;
//    NewsListView * root;//root view
}

@end


