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

//load ourselves from the cache, else create blank information.
- (id) initWithName: (NSString *) name
{
	if ( self = [ super init ] )
	{
		NSString * groupfile = [ RESOURCEPATH stringByAppendingPathComponent: [ NSString stringWithFormat: @"%@.data", name ] ];
		
		_name = [ NSString stringWithString: name ];

		if ( [ [ NSFileManager defaultManager ] fileExistsAtPath: groupfile ] )
		{
			NSDictionary * rootObject = [ NSKeyedUnarchiver unarchiveObjectWithFile: groupfile ];
			_articles = [ rootObject valueForKey: K_NNTPGROUPFULL_ARTS ];
			_lastUpdateTime = [ rootObject valueForKey: K_NNTPGROUPFULL_TIME ];
		}
		else
		{
			_lastUpdateTime = nil;
			_articles = nil;
			_delegate = nil;
		}
	}
	return self;
}

- (void) setDelegate: (id) delegate
{
	_delegate = delegate;
}

//use NNTPAccount to update our group information
- (void) refresh
{

	//TODO: coolness

	if ( _lastUpdateTime )//if we've ever updated before
	{
		//XXX: coolness
		//[ [ NNTPAccount sharedInstance ] sendCommand: @"NEWNEWS" withArg: [ self newnewsArg ] ];
		_lastUpdateTime = [ NSDate date ];//now 

	}
	else
	{
		[ [ NNTPAccount sharedInstance ] sendCommand: @"LISTGROUP" withArg: _name ]; 
		if ( [ [ NNTPAccount sharedInstance ] isSuccessfulCommand: [ [ NNTPAccount sharedInstance ] getLine ] ] )
		{
			_lastUpdateTime = [ NSDate date ];//now
			NSArray * lines = [ [ NNTPAccount sharedInstance ] getResponse ];

			int MAXARTS = 100;//TODO make '100' a parameter/global
			int begin = 0;	
			if ( [ lines count ] > MAXARTS )
			{
				begin = [ lines count ] - ( MAXARTS + 1 );
			}

			int end = begin + MAXARTS;
			if ( end >= [ lines count ] )
			{
				end = [ lines count ] - 1;
			}

			//_articles is empty b/c lastUpdateTime wasn't set
			_articles = [ NSMutableArray arrayWithCapacity: end- begin + 1 ];

			//go through the response and get the headers for the articles mentioned
			for ( int i = begin; i <= end; i++ )
			{
				[ [ NNTPAccount sharedInstance ] sendCommand: @"HEAD" withArg: [ lines objectAtIndex: i ] ];
			}

			for ( int i = begin; i <= end; i++ )
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

	//NEWNEWS the server, get list of articles
	
	//remove articles not in 'keeping' threshold (newest 100?)
	
	//set lastUpdateTime
	
	//send update message to delegate
	
}

//save state information of this object back to file.
- (void) save
{
	//TODO: save!

}

//clean up!
- (void) dealloc
{
	[ self save ];
	[ _articles release ];
	[ _lastUpdateTime release ];
	[ _name release ];
	
	[ super dealloc ];
}

@end
