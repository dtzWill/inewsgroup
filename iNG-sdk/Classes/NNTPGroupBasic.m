//
//  NNTPGroupBasic.m
//  iNG
//
//  Created by William Dietz on 4/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NNTPGroupBasic.h"

#define K_NNTPGROUPBASIC_HIGH @"GB_HIGH"
#define K_NNTPGROUPBASIC_LOW @"GB_LOW"
#define K_NNTPGROUPBASIC_COUNT @"GB_COUNT"
#define K_NNTPGROUPBASIC_UNREAD @"GB_UNREAD"
#define K_NNTPGROUPBASIC_NAME @"GB_NAME"

@implementation NNTPGroupBasic

//bind the properties to their respective memeber variables
@synthesize name=_name, high=_high, low=_low, unreadCount=_unreadCount;

//creates a basic group entry
- initWithName: (NSString *) name
{
	if ( self = [ super init ] )
	{
		_name = [ NSString stringWithString: name ];
		_high = _low = _count = _unreadCount = 0;
		_fullGroup = nil;

		//LIST ACTIVE parsing:
		//groupname high low flags
//		NSArray * parts = [ line componentsSeparatedByString: @" " ];
//		_name = [ parts objectAtIndex: 0 ];
//		_high = [ [ parts objectAtIndex: 1 ] intValue ];
//		_low = [ [ parts objectAtIndex: 2 ] intValue ];
//		_count = _high - _low; //ESTIMATE
//		_unreadCount = _count;//all are unread at the get-go
//		_fullGroup = nil;
	}
	return self;

}
- (id) initWithCoder: (NSCoder *) decoder
{
	if ( self = [ super init ] )
	{
		_name = [ decoder decodeObjectForKey: K_NNTPGROUPBASIC_NAME ]; 
		_high = [ [ decoder decodeObjectForKey: K_NNTPGROUPBASIC_HIGH ] longValue ];
		_low = [ [ decoder decodeObjectForKey: K_NNTPGROUPBASIC_LOW ] longValue ];
		_count = [ [ decoder decodeObjectForKey: K_NNTPGROUPBASIC_COUNT ] longValue ];
		_unreadCount = [ [ decoder decodeObjectForKey: K_NNTPGROUPBASIC_UNREAD ] longValue ];
	}

	return self;

}
- (void) encodeWithCoder: (NSCoder *) coder
{

	[ coder encodeObject: _name 
		forKey: K_NNTPGROUPBASIC_NAME ]; 
	[ coder encodeObject: [ NSNumber numberWithLong: _high ]
		forKey: K_NNTPGROUPBASIC_HIGH ];
	[ coder encodeObject: [ NSNumber numberWithLong: _low ] 
		forKey: K_NNTPGROUPBASIC_LOW ];
	[ coder encodeObject: [ NSNumber numberWithLong: _count ] 
		forKey: K_NNTPGROUPBASIC_COUNT ];
	[ coder encodeObject: [ NSNumber numberWithLong: _unreadCount ]
		forKey: K_NNTPGROUPBASIC_UNREAD ];
	
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
