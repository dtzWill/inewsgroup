//
//  NNTPThreaded.m
//  iNG
//
//  Created by Will Dietz on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NNTPThreaded.h"


@implementation NNTPThreaded
//TODO: comment with vim
//desc: Returns the index-th article at this threading level
- (NNTPArticle *) getArtAtIndex: (int) index
{
	if ( _threads == nil || index < 0 || index >= [ _threads count ] )
	{
		return nil;
	}

	return (NNTPArticle *)[ _threads objectAtIndex: index ];
}


//inserts the article--
//the method tries to find what article this is in response to
//and adds it to the appropriate reply list.
//replyOnly tells the method if it should add it
//as new article (not a reply at this level) if it
//can't find the message this is a response to.
//returns true if insert was successful
//(when replyOnly is false, should always return true)
- (bool) insertArt: (NNTPArticle *) art asReplyOnly: (bool) replyOnly
{
	//TODO: implement me!!
	for ( NNTPArticle * curArt in _threads )
	{
		if ( [ curArt isArtReply: art ] )
		{//if art is reply to curArt
			//TODO rename isArtReply (and in comments)
			//to be 'isReplyTo' and reverse the way it works--it returns true iff the the callee is a reply to the argument
			//makes it more readable
			//then reverse the above
			
		}
			
	}
	
	
	
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
	//TODO: implement me!
	return nil;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  encodeWithCoder
 *  Description:  save state information of this object to the specified NSCoder
 * =====================================================================================
 */
- (void) encodeWithCoder: (NSCoder *) coder;
{
	//TODO: implement me!!
}
@end
