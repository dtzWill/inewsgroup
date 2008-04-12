//
//  NNTPGroupBasic.m
//  iNG
//
//  Created by William Dietz on 4/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NNTPGroupBasic.h"


@implementation NNTPGroupBasic

//bind the properties to their respective memeber variables
@synthesize name=_name, high=_high, low=_low, unreadCount=_unreadCount;

//creates a basic group entry from "LIST ACTIVE" or similar
- initWithActiveLine: (NSString *) line
{
	if ( self = [ super init ] )
	{
		//groupname high low flags
		NSArray * parts = [ line componentsSeparatedByString: @" " ];
		_name = [ parts objectAtIndex: 0 ];
		_high = [ [ parts objectAtIndex: 1 ] intValue ];
		_low = [ [ parts objectAtIndex: 2 ] intValue ];
		_count = _high - _low; //ESTIMATE
		_unreadCount = _count;//all are unread at the get-go
		_fullGroup = nil;
	}
	return self;

}

- (NNTPGroupFull *) enterGroup
{
	_fullGroup = [ [ NNTPGroupFull alloc ] initWithName: _name ];
	return _fullGroup;
}

- (void) leaveGroup
{
	//TODO: [ fullGroup save ];
	[ _fullGroup release ];
	_fullGroup = nil;
}

- (void) updateWithGroupLine: (NSString *) line;
{

	//responsecode number low high group
	NSArray * parts = [ line componentsSeparatedByString: @" " ];
	//TODO: verify 'group' matches ours!
	long high = [ [ parts objectAtIndex: 1 ] intValue ];
	long low = [ [ parts objectAtIndex: 2 ] intValue ];
	//TODO: count??!

	if ( high > _high )	
	{
		_unreadCount += ( high - _high );//at this level, really lame estimate, but not much better we can do
	}

	_high = high;
	_low = low;

}


@end
