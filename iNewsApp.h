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
    NSMutableArray * rows;// holds the row objects for our table 
    UINavigationItem * titleItem;//title
//    UITable * table;
//    NewsListView * root;//root view
}

@end


