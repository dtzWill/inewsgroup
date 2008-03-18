//
//  iNGAppDelegate.h
//  iNG
//
//  Created by Will Dietz on 3/16/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyView;

@interface iNGAppDelegate : NSObject {
    UIWindow *window;
    MyView *contentView;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) MyView *contentView;

@end
