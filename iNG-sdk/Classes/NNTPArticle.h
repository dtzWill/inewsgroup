//
//  NNTPArticle.h
//  iNG
//
//  Created by William Dietz on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NNTPArticle : NSObject {

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

- (NNTPArticle *) initWithResponse: (NSArray *) headers;

- (void) getBodyIfNeeded;
@end
