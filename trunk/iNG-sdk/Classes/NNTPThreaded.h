//
//  NNTPThreaded.h
//  iNG
//
//  Created by Will Dietz on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NNTPArticle.h"
#import <UIKit/UIKit.h>

/*
 facilitates threading by organizing NNTPArticles
 for access that makes sense (traversing down a thread, or
 along the same level in the threading tree)
 */

@interface NNTPThreaded : NSObject <NSCoding> {
	NSMutableArray * _threads;//NNTPThreaded
	NNTPThreaded * _reply;//points to first reply if it exists
}

//TODO: comment with vim
//desc: Returns the index-th article at this threading level
- (NNTPArticle *) getArtAtIndex: (int) index;

//inserts the article--
//the method tries to find what article this is in response to
//and adds it to the appropriate reply list.
//replyOnly tells the method if it should add it
//as new article (not a reply at this level) if it
//can't find the message this is a response to.
//returns true if insert was successful
//(when replyOnly is false, should always return true)
- (bool) insertArt: (NNTPArticle *) art asReplyOnly: (bool) replyOnly;

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
@end