//Will Dietz
//iNewsApp.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UIImageAndTextTableCell.h>

@interface UIUCMapApp : UIApplication {
    NSMutableArray * rows;// holds the row objects for our table 
    UINavigationItem * titleItem;//title
    UITable * table;
}

@end


