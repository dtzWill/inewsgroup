//
//  NNTPArticle.m
//  iNG
//
//  Created by William Dietz on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NNTPArticle.h"

#import "NNTPAccount.h"

#define FROM 1
#define SUBJECT 2
#define NEWSGROUPS 3
#define REFERENCES 4
#define DATE 5
#define MESSAGEID 6
#define SENDER 7

@implementation NNTPArticle

- (NNTPArticle *) initWithResponse: (NSArray *) headers;
{
	if ( self = [ super init ] )
	{
		//unread
		_read = false;	
		//initialize to containing nothing
		_from = _subject = _newsgroups = _references = _date = nil;
		_messageID = _sender = _body = nil;

		//parse headers

		NSEnumerator * enumer = [ headers objectEnumerator ];
		NSString * hdr;

		//TODO: global?!
		NSDictionary * headersDict = [ [ NSDictionary alloc ] initWithObjectsAndKeys:
			//object, key
			[ NSNumber numberWithInt: FROM ], @"FROM",
			[ NSNumber numberWithInt: SUBJECT ], @"SUBJECT",
			[ NSNumber numberWithInt: NEWSGROUPS ], @"NEWSGROUPS",
			[ NSNumber numberWithInt: REFERENCES ], @"REFERENCES",
			[ NSNumber numberWithInt: DATE ], @"DATE",
			[ NSNumber numberWithInt: MESSAGEID ], @"MESSAGE-ID",
			[ NSNumber numberWithInt: SENDER ], @"SENDER",
			nil ];

		while  ( hdr = [ enumer nextObject ] )
		{
			NSArray * parts = [ hdr componentsSeparatedByString: @": " ];	
			if ( [ parts count ] < 2 )//need at least "header: value"
			{
				continue;//next!
			}

			//combine the rest, just in case the contain ": "s
			NSMutableString * value = [ NSMutableString stringWithString: [ parts objectAtIndex: 1 ] ];
			for ( int i = 2; i < [ parts count ]; i++ )
			{
				[ value appendString: @": " ];
				[ value appendString: [ parts objectAtIndex: i ] ];

			}
			switch ( [ [ headersDict objectForKey: [ [ parts objectAtIndex: 0 ] uppercaseString ] ] intValue ] )
			{
				case FROM:
					_from = value; 
					break;
				case SUBJECT:
					_subject = value;
					break;
				case NEWSGROUPS:
					_newsgroups = value;
					break;
				case REFERENCES:
					_references = value;
					break;
				case DATE:
					_date = value;
					break;
				case MESSAGEID:
					_messageID = value;
					break;
				case SENDER:
					_sender = value;
					break;
				default:
					NSLog( @"Unknown header: %@", hdr ); 
					//[ value release ];
			}

			//[ parts release ];

			
		}
	}

	if ( _from )
		NSLog( @"From: %@", _from );
	if ( _subject)
		NSLog( @"Subject: %@", _subject );
	if ( _newsgroups )
		NSLog( @"Newsgroups: %@", _newsgroups );
	if ( _references )
		NSLog( @"References: %@", _references );
	if ( _date )
		NSLog( @"Date: %@", _date );
	if ( _messageID )
		NSLog( @"Message-ID: %@", _messageID );
	if ( _sender )
		NSLog( @"Sender: %@", _sender );


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
