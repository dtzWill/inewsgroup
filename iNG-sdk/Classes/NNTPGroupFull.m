//
//  NNTPGroupFull.m
//  iNG
//
//  Created by William Dietz on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NNTPGroupFull.h"


@implementation NNTPGroupFull

//load ourselves from the cache, else create blank information.
- (id) initWithName: (NSString *) name
{
	if ( self = [ super init ] )
	{
		//TODO: load from file, using 'name' as key!
		_name = [ NSString stringWithString: name ];
		_lastUpdateTime = nil;
		_articles = nil;
		_delegate = nil;
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
