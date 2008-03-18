/*
 *  resolve.h
 *  iNG
 *
 *  Created by Will Dietz on 3/17/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  resolveHostname
 *  Description:  attempts to resolve the hostname using apple's API.  returns string containing the ip if successful, else nil.
 * =====================================================================================
 */
NSString * resolveHostname( const char * hostname );
