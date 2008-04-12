//
//  NNTPGroupFull.h
//  iNG
//
//  Created by William Dietz on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NNTPGroupFull : NSObject {
	NSArray * _articles;//NNTPArticle's
	NSDate * _lastUpdateTime;
	id _delegate;
	NSString * _name;
}

//load ourselves from the cache, else create blank information.
- (id) initWithName: (NSString *) name;

- (void) setDelegate: (id) delegate;

- (void) refresh;

- (void) save;
@end
