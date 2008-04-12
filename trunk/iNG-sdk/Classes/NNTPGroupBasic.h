//
//  NNTPGroupBasic.h
//  iNG
//
//  Created by William Dietz on 4/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NNTPGroupFull.h"

@interface NNTPGroupBasic : NSObject {
	NSString * _name;
	long _high;
	long _low;
	long _count;
	long _unreadCount;//can only ever be an estimate

	NNTPGroupFull * _fullGroup;


}

//properties
@property (readonly) NSString * name;
@property long high;
@property long low;
@property long unreadCount;

- (id) initWithActiveLine: (NSString *) line;

- (NNTPGroupFull *) enterGroup;

- (void) leaveGroup;

- (void) updateWithGroupLine: (NSString *) line;



@end
