//
//  NNTPGroupBasic.h
//  iNG
//
//  Created by William Dietz on 4/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NNTPGroupFull.h"

@interface NNTPGroupBasic : NSObject <NSCoding> {
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

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  initWithName
 *  Description:  creates a basic group entry
 * =====================================================================================
 */
- (id) initWithName: (NSString *) name;


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  initWithCoder
 *  Description:  Creates an instance of an object from archived state information
 * =====================================================================================
 */
- (id) initWithCoder: (NSCoder *) decoder;


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  encodeWithCoder
 *  Description:  save state information of this object to the specified NSCoder
 * =====================================================================================
 */
- (void) encodeWithCoder: (NSCoder *) coder;


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  enterGroup
 *  Description:  create the corresponding NNTPGroupFull for this group and return it
 * =====================================================================================
 */
- (NNTPGroupFull *) enterGroup;


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  leaveGroup
 *  Description:  leave the NNTPGroupFull stored in _fullGroup if it exists
 * =====================================================================================
 */
- (void) leaveGroup;


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  updateWithGroupLine
 *  Description:  update state information using the data contained in the group line
 * =====================================================================================
 */
- (void) updateWithGroupLine: (NSString *) line;


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  compareGroupName
 *  Description:  compares two groups by their name 
 * =====================================================================================
 */
- (NSComparisonResult) compareGroupName: (NNTPGroupBasic *) basic;
@end
