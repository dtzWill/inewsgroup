//
//  NNTPArticle.m
//  iNG
//
//  Created by William Dietz on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NNTPArticle.h"

#import "NNTPAccount.h"

//for debugging header parsing (when adding support for more of them later)
//#define DEBUG_HEADERS
//for debugging encoding/saving
//#define DEBUG_ENCODING

//for switching on the header type
#define FROM        1
#define SUBJECT     2
#define NEWSGROUPS  3
#define REFERENCES  4
#define DATE        5
#define MESSAGEID   6
#define SENDER      7
#define CONTENTTYPE 8
#define HEADERS_DICT [ [ NSDictionary alloc ] initWithObjectsAndKeys: \
			[ NSNumber numberWithInt: FROM ], @"FROM", \
			[ NSNumber numberWithInt: SUBJECT ], @"SUBJECT", \
			[ NSNumber numberWithInt: NEWSGROUPS ], @"NEWSGROUPS", \
			[ NSNumber numberWithInt: REFERENCES ], @"REFERENCES", \
			[ NSNumber numberWithInt: DATE ], @"DATE", \
			[ NSNumber numberWithInt: MESSAGEID ], @"MESSAGE-ID", \
			[ NSNumber numberWithInt: SENDER ], @"SENDER", \
			[ NSNumber numberWithInt: CONTENTTYPE ], @"CONTENT-TYPE", \
			nil ];

//NSCoder keys
#define K_NNTPARTICLE_FROM @"NA_FROM"
#define K_NNTPARTICLE_SUBJECT @"NA_SUBJECT"
#define K_NNTPARTICLE_NEWSGROUPS @"NA_NEWSGROUPS"
#define K_NNTPARTICLE_REFERENCES @"NA_REFERENCES"
#define K_NNTPARTICLE_DATE @"NA_DATE"
#define K_NNTPARTICLE_MESSAGEID @"NA_MESSAGEID"
#define K_NNTPARTICLE_SENDER @"NA_SENDER"
#define K_NNTPARTICLE_BODY @"NA_BODY"
#define K_NNTPARTICLE_READ @"NA_READ"
#define K_NNTPARTICLE_CONTENTTYPE @"NA_CONTENTTYPE"

@implementation NNTPArticle

@synthesize from=_from, subject=_subject, newsgroups=_newsgroups,
	references=_references, date=_date, messageID=_messageID,
	sender=_sender, body=_body, read=_read, contentType=_contentType;

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  initWithResponse
 *  Description:  use 'HEAD id' response to create an instance of ourselves
 * =====================================================================================
 */
- (NNTPArticle *) initWithResponse: (NSArray *) headers;
{
	unsigned int i;//iter var
	if ( self = [ super init ] )
	{
		//unread
		_read = false;	
		//initialize to containing nothing
		_from = _subject = _newsgroups = _references = _date = nil;
		_messageID = _sender = _body = nil;

		//first we 'unfold' the headers jic they're multi-line
		NSMutableArray * headers_unfolded = [ [ NSMutableArray alloc ] init ];
		NSCharacterSet * whitespace = [ NSCharacterSet whitespaceCharacterSet ];
		for ( NSString * header in headers )
		{
			if ( [ header rangeOfCharacterFromSet: whitespace options: NSLiteralSearch ].location == 0 )
			{
				//if this header starts with whitespace....
				//then we append to previous header
				if ( [ headers_unfolded count ] > 0 )
				{
					NSMutableString * new_header = [ NSMutableString stringWithString: [ headers_unfolded objectAtIndex: [ headers_unfolded count ] - 1 ] ];
					[ new_header appendString: header ];
					[ headers_unfolded replaceObjectAtIndex: [ headers_unfolded count ] - 1 withObject: new_header ];
				}
				else
				{
					NSLog( @"Invalid header on first line!" );
				}
			}
			else
			{
				[ headers_unfolded addObject: header ];
			}
		}
			
		
		
		//parse headers

		NSEnumerator * enumer = [ headers_unfolded objectEnumerator ];
		NSString * hdr;

		//TODO: global?!
		NSDictionary * headersDict = HEADERS_DICT; 

		while  ( hdr = [ enumer nextObject ] )
		{
			//TODO: redo this to find the first :, and create substrings from that
			//not this significantly more expensive approach of splitting on :
			//then joining all but the first part
			NSArray * parts = [ hdr componentsSeparatedByString: @": " ];	
			if ( [ parts count ] < 2 )//need at least "header: value"
			{
				continue;//next!
			}

			//combine the rest, just in case the contain ": "s
			NSMutableString * value = [ [ NSMutableString stringWithString: [ parts objectAtIndex: 1 ] ] retain ];
			for ( i = 2; i < [ parts count ]; i++ )
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
					//TODO: parse references into something more useful, like an array or some such
					//so that isArtReply method doesn't have to do it every time, and can
					//reduce to a strcmp in a loop
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
				case CONTENTTYPE:
					_contentType = value;
					break;
				default:
#ifdef DEBUG_HEADERS
					NSLog( @"Unknown header: %@", hdr ); 
#endif
					//[ value release ];
					break;
			}

			//[ parts release ];

			
		}
	}

#ifdef DEBUG_HEADERS
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
	if ( _contentType )
		NSLog( @"Content-Type: %@", _contentType );
#endif



	return self;

}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  isArtReply
 *  Description:  returns true iff argument is a direct reply to /this/ article
 * =====================================================================================
 */
- (bool) isArtReply: (NNTPArticle *) replyCandidate
{
	//TODO: implement me!
	//find first (or is it last? check RFC) reference in references list
	//and compare that messageID to the one of this present artlce
	//return replyCandidate.references != nil && 
	// [ _messageID compareTo: [ replyCandidate._references getObjectAtIndex: 0 ] ];
	//or so
	return false;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  initWithCoder
 *  Description:  Creates an instance of an object from archived state information
 * =====================================================================================
 */
- (id) initWithCoder: (NSCoder *) decoder
{
	if ( self = [ super init ] )
	{
		_from = [ [ decoder decodeObjectForKey: K_NNTPARTICLE_FROM ] retain ];
		_subject = [ [ decoder decodeObjectForKey: K_NNTPARTICLE_SUBJECT ] retain ];
		_newsgroups = [ [ decoder decodeObjectForKey: K_NNTPARTICLE_NEWSGROUPS ] retain ];
		_references = [ [ decoder decodeObjectForKey: K_NNTPARTICLE_REFERENCES ] retain ];
		_date = [ [ decoder decodeObjectForKey: K_NNTPARTICLE_DATE ] retain ];
		_messageID = [ [ decoder decodeObjectForKey: K_NNTPARTICLE_MESSAGEID ] retain ];
		_sender = [ [ decoder decodeObjectForKey: K_NNTPARTICLE_SENDER ] retain ];
		_body = [ [ decoder decodeObjectForKey: K_NNTPARTICLE_BODY ] retain ];
		_read = [ [ decoder decodeObjectForKey: K_NNTPARTICLE_READ ] boolValue ];
		_contentType = [ [ decoder decodeObjectForKey: K_NNTPARTICLE_CONTENTTYPE ] retain ];
	}

	return self;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  encodeWithCoder
 *  Description:  save state information of this object to the specified NSCoder
 * =====================================================================================
 */
- (void) encodeWithCoder: (NSCoder *) coder
{
#ifdef DEBUG_ENCODING	
	NSLog( @"Encoding!" );
#endif
	if ( _from )
	{
#ifdef DEBUG_ENCODING
		NSLog( @"From: %@", _from );
#endif
		[ coder encodeObject: _from forKey: K_NNTPARTICLE_FROM ];
	}
	if ( _subject )
	{
		[ coder encodeObject: _subject forKey: K_NNTPARTICLE_SUBJECT ];
	}
	if ( _newsgroups )
	{
		[ coder encodeObject: _newsgroups forKey: K_NNTPARTICLE_NEWSGROUPS ];
	}
	if ( _references )
	{
		[ coder encodeObject: _references forKey: K_NNTPARTICLE_REFERENCES ];
	}
	if ( _date )
	{
		[ coder encodeObject: _date forKey: K_NNTPARTICLE_DATE ];
	}
	if ( _messageID )
	{
		[ coder encodeObject: _messageID forKey: K_NNTPARTICLE_MESSAGEID ];
	}
	if ( _sender )
	{
		[ coder encodeObject: _sender forKey: K_NNTPARTICLE_SENDER ];
	}
	if ( _body )
	{
		[ coder encodeObject: _body forKey: K_NNTPARTICLE_BODY ];
	}
	if ( _contentType )
	{
		[ coder encodeObject: _contentType forKey: K_NNTPARTICLE_CONTENTTYPE ];
	}

	[ coder encodeObject: [ NSNumber numberWithBool: _read ] forKey: K_NNTPARTICLE_READ ];
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  getBodyIfNeeded
 *  Description:  fetch body contents if we don't already have them
 * =====================================================================================
 */
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

			//combine array of lines to one long body string
			for( NSString * line in lines )
			{
				[ _body appendFormat: @"%@\n", line ];
			}

			[ lines release ];

		}

	}
}

- (void) dealloc
{
	[ _from release ];
	[ _subject release ];
	[ _newsgroups release ];
	[ _references release ];
	[ _date release ];
	[ _messageID release ];
	[ _sender release ];
	
	[ _body release ];
	
	[ super dealloc ];

}
@end
