//
//  NNTPAccount.h
//  iNG
//
//  Created by Will Dietz on 3/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NNTPArticle.h"
#import "NNTPGroupFull.h"

@interface NNTPAccount : NSObject {

	//run-time data
	NSMutableArray * _arts;//		NNTPArticle's (containing the headers)
	NSArray * _groups;//		NSString's containing list of group names
	int _sockd;//fd for the socket connection
	NNTPGroupFull * _currentGroup;//group we're in

	//data to save (other than account information)
	NSMutableArray * _subscribed;// strings of the subscribed groups.
	bool _canPost;

}

+ (NNTPAccount *) sharedInstance;

//init constructor
- (NNTPAccount *) init;


/*-----------------------------------------------------------------------------
 *  Accessors
 *-----------------------------------------------------------------------------*/
- (NSString *) getUser;
- (NSString *) getPassword;
- (NSString *) getServer;
- (int) getPort;
- (bool) isConnected;
- (bool) canPost;

- (void) setUser: (NSString *) user;
- (void) setPassword: (NSString *) password;
- (void) setServer: (NSString *) server;
- (void) setPort: (int) port;

- (bool) isValid;

/*-----------------------------------------------------------------------------
 *  NNTP methods
 *-----------------------------------------------------------------------------*/


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  connect
 *  Description:  attempt to connect.  returns true iff successful
 * =====================================================================================
 */
- (bool) connect;


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  authenticate
 *  Description:  Attempts to authenticate, if necessary (if username is valid, or forceAuth is true).
 *                returns true iff successful
 * =====================================================================================
 */
- (bool) authenticate: (bool) forceAuth;

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  sendCommand
 *  Description:  sends a command to the nntp server, returns if send has an error (local)
 * =====================================================================================
 */
- (bool) sendCommand: (NSString *) command withArg: (NSString *) arg;

/*
 * ===  FUNCTION  ======================================================================
 *         Name:  getLine
 *  Description:  reads a line from the network stream
 * =====================================================================================
 */
- (NSString *) getLine;

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  getResponse
 *  Description:  gets the rest of the response
 * =====================================================================================
 */
- (NSArray *) getResponse;

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  isSuccessfulCommand
 *  Description:  returns true iff the string starts with a '2'.  Used to determine if a server is happy
 * =====================================================================================
 */
- (bool) isSuccessfulCommand: (NSString *) response;

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  getGroupList
 *  Description:  get list of the groups this server has
 *                uses cache on disk, only updating when forceRefresh.
 *                if cache doesn't exist, it'll get a new listing
 * =====================================================================================
 */
- (NSArray *) getGroupList: (bool) forceRefresh;

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  subscribedGroups
 *  Description:  Returns array containing the subscribed groups. (of type NTTPGroupBasic)
 * =====================================================================================
 */
- (NSArray *) subscribedGroups;


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  updateSubscribedGroups
 *  Description:  updates information on subscribed groups (high, low, etc).
 *                used to determine if we have unread articles or not.
 * =====================================================================================
 */
- (void) updateSubscribedGroups;


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  setGroupAndFetchHeaders
 *  Description:  Enters the specified group
 *                also gets the headers
 *                Uses the progressdelegate.
 * =====================================================================================
 */
- (void) setGroupAndFetchHeaders: (NSString *) group;


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  getArts
 *  Description:  returns pointer to internal array of the articles
 *                initially it's just the headers filled in by the initial XOVER
 *                body only guaranteed to be there for the last article that we got
 *                the body for (as memory allows)
 * =====================================================================================
 */
- (NSArray *) getArts;


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  updateAllSubscribedAndHeaders
 *  Description:  go through all subscribed groups and update them.
 *                this means their hi/lo (via updateSubscribedGroups) as well as
 *                fetching headers for each
 * =====================================================================================
 */
//- (void) updateAllSubcribedAndHeaders;


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  getBodyForArticle
 *  Description:  Returns pointer to the article requested, optionally fetching body
 *                Primary purpose is to fetch the body
 * =====================================================================================
 */
- (NNTPArticle *) getBodyForArticle: (int) artid;

//does what you'd expect
//- (NNTPGroup) NNTPGroupFromNSString: (NSString *) string;

//TODO: POSTING SUPPORT!
//TODO: THREADING!

@end
