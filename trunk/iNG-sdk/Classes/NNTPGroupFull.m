//
//  NNTPGroupFull.m
//  iNG
//
//  Created by William Dietz on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NNTPGroupFull.h"

#import "NNTPAccount.h"

#define RESOURCEPATH [ [ NSBundle mainBundle ] resourcePath ]

#define K_NNTPGROUPFULL_ARTS @"GF_ARTS"
#define K_NNTPGROUPFULL_TIME @"GF_TIME"

@implementation NNTPGroupFull

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
		NSString * groupfile = [ RESOURCEPATH stringByAppendingPathComponent: [ NSString stringWithFormat: @"%@.data", name ] ];
		
		_name = [ NSString stringWithString: name ];
		_parent = basicParent;

		if ( [ [ NSFileManager defaultManager ] fileExistsAtPath: groupfile ] )
		{
			NSDictionary * rootObject = [ NSKeyedUnarchiver unarchiveObjectWithFile: groupfile ];
			_articles = [ rootObject valueForKey: K_NNTPGROUPFULL_ARTS ];
			_lastUpdateTime = [ rootObject valueForKey: K_NNTPGROUPFULL_TIME ];
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

	//TODO: coolness
	int i;//iter var

	if ( _lastUpdateTime )//if we've ever updated before
	{
		//XXX: coolness
		//[ [ NNTPAccount sharedInstance ] sendCommand: @"NEWNEWS" withArg: [ self newnewsArg ] ];
		_lastUpdateTime = [ NSDate date ];//now 

		//NEWNEWS the server, get list of articles
		
		//remove articles not in 'keeping' threshold (newest 100?)
		
		//set lastUpdateTime

	}
	else
	{
		[ [ NNTPAccount sharedInstance ] sendCommand: @"LISTGROUP" withArg: _name ]; 
		if ( [ [ NNTPAccount sharedInstance ] isSuccessfulCommand: [ [ NNTPAccount sharedInstance ] getLine ] ] )
		{
			_lastUpdateTime = [ [ NSDate date ] retain ];//now
			NSArray * lines = [ [ NNTPAccount sharedInstance ] getResponse ];

			int MAXARTS = 10;//TODO make '10' a parameter/global
			int begin = 0;	
			if ( [ lines count ] > MAXARTS )
			{
				begin = [ lines count ] - ( MAXARTS + 1 );
			}

			int end = begin + MAXARTS;
			if ( end >= [ lines count ] )
			{
				end = [ lines count ];
			}

			//_articles is empty b/c lastUpdateTime wasn't set
			_articles = [ NSMutableArray arrayWithCapacity: end- begin + 1 ];

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
	NSString * groupfile = [ RESOURCEPATH stringByAppendingPathComponent: [ NSString stringWithFormat: @"%@.data", _name ] ];
	NSLog( @"woo: %@, %@", _name, groupfile );

	NSMutableDictionary * rootObject;
	rootObject = [ [ [ NSMutableDictionary alloc ] init ] autorelease ];
	NSLog( @"articles length: %d", [ _articles count ] );

	if ( _articles )
	{
		[ rootObject setValue: _articles forKey: K_NNTPGROUPFULL_ARTS ];
	}
	if ( _lastUpdateTime )
	{
		[ rootObject setValue: _lastUpdateTime forKey: K_NNTPGROUPFULL_TIME ];
	}
	NSLog( @"save NNTPGroupFull %d", [ NSKeyedArchiver archiveRootObject: rootObject toFile: groupfile ] );

}

//clean up!
- (void) dealloc
{
	//XXX is this saving redundant?? (do we care?)
	//[ self save ];
	[ _articles release ];
	[ _lastUpdateTime release ];
	[ _name release ];
	
	[ super dealloc ];
}

@end
