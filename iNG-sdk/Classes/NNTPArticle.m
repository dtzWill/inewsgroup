//
//  NNTPArticle.m
//  iNG
//
//  Created by William Dietz on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NNTPArticle.h"

#import "NNTPAccount.h"


@implementation NNTPArticle

- (NNTPAccount *) init
{
	if ( self = [ super init ] )
	{
		//unread
		_read = false;	
		//initialize to containing nothing
		_from = _subject = _newsgroups = _references = _date = nil;
		_messageID = _sender = _body = nil;


	}

	return self;

}

- (void) getBodyIfNeeded
{
	if ( !_body )
	{
		NNTPAccount * account = [ NNTPAccount sharedInstance ];

		[ account sendCommand: @"BODY" withArg: _messageID ];
		if ( [ account isSuccessfulCommand: [ account getLine ] ] )
		{
			_body = [ [ NSMutableString alloc ] init ];
			NSArray * lines = [ account getResponse ];	
			NSEnumerator * enumer = [ lines objectEnumerator ];
			NSString * line;

			//combine array of lines to one long body string
			while  ( line = [ enumer nextObject ] )
			{
				[ _body appendFormat: @"%s\n", line ];
			}

			[ lines release ];

		}

	}
}

@end
