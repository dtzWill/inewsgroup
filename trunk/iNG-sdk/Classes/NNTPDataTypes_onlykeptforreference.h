/*
 *  NNTPDataTypes.h
 *  iNG
 *
 *  Created by Will Dietz on 3/17/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */


typedef struct
{
	//			FIELD			MEANING/VALUE
	NSString * from;//		user-reported name
	NSString * subject;//		..subject
	NSString * newsgroups;//	list of groups this is posted to
	NSString * references;//	list of references
	NSString * date;//			NSDate ?
	NSString * messageID;//	uniq id for this
	NSString * sender;//		username@senderip
	//TODO: MIME type, etc
} NNTPHeader;



typedef struct
{
	NNTPHeader hdr;
	NSString * body;
	/* if/when supporting MIME type
	 * might wanna change body's type to NSData or some such
	 */
} NNTPArticle;

typedef struct
{
	char name[80];
	long high;
	long low;
	bool hasUnread;//if hi/low changes from last time, this will be true.
	int count;//only valid if a subscribed group (via GROUP command)

} NNTPGroup;
