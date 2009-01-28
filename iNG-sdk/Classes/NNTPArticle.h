//
//  NNTPArticle.h
//  iNG
//
//  Created by William Dietz on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NNTPArticle : NSObject <NSCoding> {

	//header information
	//			FIELD			MEANING/VALUE
	NSString * _from;//		user-reported name
	NSString * _subject;//		..subject
	NSString * _newsgroups;//	list of groups this is posted to
	NSString * _references;//	list of references
	NSString * _date;//			NSDate ?
	NSString * _messageID;//	uniq id for this
	NSString * _sender;//		username@senderip
	
	//body information
	NSMutableString * _body;
	//TODO: MIME type, etc
	
	bool _read;

}

@property (readonly) NSString * from;
@property (readonly) NSString * subject;
@property (readonly) NSString * newsgroups;
@property (readonly) NSString * references;
@property (readonly) NSString * date;
@property (readonly) NSString * messageID;
@property (readonly) NSString * sender;
@property (readonly) NSString * body;
@property bool read;

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  initWithResponse
 *  Description:  use 'HEAD id' response to create an instance of ourselves
 * =====================================================================================
 */
- (NNTPArticle *) initWithResponse: (NSArray *) headers;

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
 *         Name:  getBodyIfNeeded
 *  Description:  fetch body contents if we don't already have them
 * =====================================================================================
 */
- (void) getBodyIfNeeded;

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  isArtReply
 *  Description:  returns true iff argument is a direct reply to /this/ article
 * =====================================================================================
 */
- (bool) isArtReply: (NNTPArticle *) replyCandidate;

@end
