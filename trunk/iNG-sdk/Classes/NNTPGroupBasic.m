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

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  initWithName
 *  Description:  creates a basic group entry
 * =====================================================================================
 */
- initWithName: (NSString *) name
{
	if ( self = [ super init ] )
	{
		_name = [ [ NSString alloc ] initWithString: name ];
		_high = _low = _count = _unreadCount = 0;
		_fullGroup = nil;

	}
	return self;

}

-/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  initWithCoder
 *  Description:  Creates an instance of an object from archived state information
 * =====================================================================================
 */ (id) initWithCoder: (NSCoder *) decoder
{
	if ( self = [ super init ] )
	{
		_name = [ [ decoder decodeObjectForKey: K_NNTPGROUPBASIC_NAME ] retain ]; 
		_high = [ [ decoder decodeObjectForKey: K_NNTPGROUPBASIC_HIGH ] longValue ];
		_low = [ [ decoder decodeObjectForKey: K_NNTPGROUPBASIC_LOW ] longValue ];
		_count = [ [ decoder decodeObjectForKey: K_NNTPGROUPBASIC_COUNT ] longValue ];
		_unreadCount = [ [ decoder decodeObjectForKey: K_NNTPGROUPBASIC_UNREAD ] longValue ];
		_fullGroup = nil;
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

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  enterGroup
 *  Description:  create the corresponding NNTPGroupFull for this group and return it
 * =====================================================================================
 */
- (NNTPGroupFull *) enterGroup
{
	_fullGroup = [ [ NNTPGroupFull alloc ] initWithName: _name andBasic: self ];
	return _fullGroup;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  leaveGroup
 *  Description:  leave the NNTPGroupFull stored in _fullGroup if it exists
 * =====================================================================================
 */
- (void) leaveGroup
{
	//XXX: as this function is now, it's completely worthless.
	if ( _fullGroup )
	{
		[ _fullGroup release ];
		_fullGroup = nil;
	}
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  updateWithGroupLine
 *  Description:  update state information using the data contained in the group line
 * =====================================================================================
 */
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
