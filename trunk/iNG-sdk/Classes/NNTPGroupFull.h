//
//  NNTPGroupFull.h
//  iNG
//
//  Created by William Dietz on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NNTPGroupBasic;

@interface NNTPGroupFull : NSObject {
	NSMutableArray * _articles;//NNTPArticle's
	NSDate * _lastUpdateTime;
	NNTPGroupBasic * _parent;
	NSString * _name;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  initWithName
 *  Description:  load ourselves from the cache, else create blank information
 * =====================================================================================
 */
- (id) initWithName: (NSString *) name andBasic: (NNTPGroupBasic *) basicParent;


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  getParent
 *  Description:  returns the basic corresponding to this group
 * =====================================================================================
 */
- (NNTPGroupBasic *) getParent;




/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  refresh
 *  Description:  get newest articles and update ourselves with it
 * =====================================================================================
 */
- (void) refresh;


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  save
 *  Description:  save ourselves to file for use later
 * =====================================================================================
 */
- (void) save;
@end
