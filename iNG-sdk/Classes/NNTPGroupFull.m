//
//  NNTPGroupFull.m
//  iNG
//
//  Created by William Dietz on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NNTPGroupFull.h"

#import "NNTPAccount.h"

#define RESOURCEPATH [ NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) objectAtIndex: 0 ]

#define K_NNTPGROUPFULL_ARTS @"GF_ARTS"
#define K_NNTPGROUPFULL_TIME @"GF_TIME"

#define MAX_ARTS 50

@implementation NNTPGroupFull

@synthesize articles = _articles;

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  initWithName
 *  Description:  load ourselves from the cache, else create blank information
 * =====================================================================================
 */
- (id) initWithName: (NSString *) name andBasic: (NNTPGroupBasic *) basicParent
{
	if ( self = [ super init ] )
	{
		NSString * groupfile = [ RESOURCEPATH stringByAppendingPathComponent: [ NSString stringWithFormat: @"iNG.%@.data", name ] ];
		
		_name = [ NSString stringWithString: name ];
		_parent = basicParent;

		if ( [ [ NSFileManager defaultManager ] fileExistsAtPath: groupfile ] )
		{
			NSDictionary * rootObject = [ NSKeyedUnarchiver unarchiveObjectWithFile: groupfile ];
			_articles = [ [ rootObject valueForKey: K_NNTPGROUPFULL_ARTS ] retain ];
			_lastUpdateTime = [ [ rootObject valueForKey: K_NNTPGROUPFULL_TIME ] retain ];
		}
		else
		{
			_articles = nil;
			_lastUpdateTime = nil;
		}
	}
	return self;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  getParent
 *  Description:  returns the basic corresponding to this group
 * =====================================================================================
 */
- (NNTPGroupBasic *) getParent
{
	return _parent;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  refresh
 *  Description:  get newest articles and update ourselves with it
 * =====================================================================================
 */
- (void) refresh
{
	//XXX Move to initialization

	int i;//iter var

	if ( _lastUpdateTime )//if we've ever updated before
	{
		NSDateFormatter * dateFormatter = [ [ NSDateFormatter alloc ] init ];
		[ dateFormatter setDateFormat: @"yyMMdd HHmmss" ];
		NSDate * gmtDate = [ _lastUpdateTime addTimeInterval: -[ [ NSTimeZone localTimeZone ] secondsFromGMTForDate: _lastUpdateTime ] ];
		NSString * arg = [ NSString stringWithFormat: @"%@ %@ GMT", _name, [ dateFormatter stringFromDate: gmtDate ] ];
		[ [ NNTPAccount sharedInstance ] sendCommand: @"NEWNEWS" withArg: arg ];
		
		
		if ( [ [ NNTPAccount sharedInstance ] isSuccessfulCommand: [ [ NNTPAccount sharedInstance ] getLine ] ] )
		{
			NSLog( @"NEWNEWS UPDATE!" );
			[ _lastUpdateTime release ];
			_lastUpdateTime = [ NSDate date ];
			[ _lastUpdateTime retain ];

			NSArray * lines = [ [ NNTPAccount sharedInstance ] getResponse ];
			
			//lines should be an array of messageid's of new news in this group

			//send a 'head' command for each msgid we get
			for( NSString * msgid in lines )
			{
				[ [ NNTPAccount sharedInstance ] sendCommand: @"HEAD" withArg: msgid ];
			}

			for ( i = 0; i < [ lines count ]; i++ )
			{
				if ( [ [ NNTPAccount sharedInstance ] isSuccessfulCommand: [ [ NNTPAccount sharedInstance ] getLine ] ] )
				{
					NSArray * headers = [ [ NNTPAccount sharedInstance ] getResponse ];
					NNTPArticle * art = [ [ NNTPArticle alloc ] initWithResponse: headers ];
					[ _articles addObject: art ];
				}
			}

			//trim article array
			if ( [ _articles count ] > MAX_ARTS )
			{
				[ _articles removeObjectsInRange: NSMakeRange( 0, [ _articles count ] - MAX_ARTS ) ];
			}

			[ lines release ];

		}

	}
	else
	{
		[ [ NNTPAccount sharedInstance ] sendCommand: @"LISTGROUP" withArg: _name ]; 
		if ( [ [ NNTPAccount sharedInstance ] isSuccessfulCommand: [ [ NNTPAccount sharedInstance ] getLine ] ] )
		{
			_lastUpdateTime = [ NSDate date ];//now
			[ _lastUpdateTime retain ];
			NSArray * lines = [ [ NNTPAccount sharedInstance ] getResponse ];

			int begin = 0;	
			if ( [ lines count ] > MAX_ARTS )
			{
				begin = [ lines count ] - ( MAX_ARTS + 1 );
			}

			int end = begin + MAX_ARTS;
			if ( end >= [ lines count ] )
			{
				end = [ lines count ];
			}

			//_articles is empty b/c lastUpdateTime wasn't set
			_articles = [ NSMutableArray arrayWithCapacity: end - begin + 1 ];

			//go through the response and get the headers for the articles mentioned
			for ( i = begin; i < end; i++ )
			{
				[ [ NNTPAccount sharedInstance ] sendCommand: @"HEAD" withArg: [ lines objectAtIndex: i ] ];
			}

			for ( i = begin; i < end; i++ )
			{
				if ( [ [ NNTPAccount sharedInstance ] isSuccessfulCommand: [ [ NNTPAccount sharedInstance ] getLine ] ] )
				{
					NSArray * headers = [ [ NNTPAccount sharedInstance ] getResponse ];
					NNTPArticle * art = [ [ NNTPArticle alloc ] initWithResponse: headers ];
					[ _articles addObject: art ];
				}

			}


			[ lines release ];

		}

	}
	
	//we've made changes... store them!
	[ self save ];

	//send update message to delegate
	
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  save
 *  Description:  save ourselves to file for use later
 * =====================================================================================
 */
- (void) save
{
	NSString * groupfile = [ RESOURCEPATH stringByAppendingPathComponent: [ NSString stringWithFormat: @"iNG.%@.data", _name ] ];
	NSLog( @"woo: %@, %@", _name, groupfile );

	NSMutableDictionary * rootObject;
	rootObject = [ [ [ NSMutableDictionary alloc ] init ] autorelease ];
	NSLog( @"articles length: %d", [ _articles count ] );

	if ( _articles )
	{
		[ _articles retain ];
		[ rootObject setValue: _articles forKey: K_NNTPGROUPFULL_ARTS ];
	}
	if ( _lastUpdateTime )
	{
		[ _lastUpdateTime retain ];
		[ rootObject setValue: _lastUpdateTime forKey: K_NNTPGROUPFULL_TIME ];
	}
	NSLog( @"save NNTPGroupFull %d", [ NSKeyedArchiver archiveRootObject: rootObject toFile: groupfile ] );

}

//clean up!
- (void) dealloc
{
	//XXX
	//[ self save ];
	
	[ super dealloc ];

	[ _articles release ];
	[ _lastUpdateTime release ];
	[ _name release ];
}

@end