//
//  ArticleListViewController.m
//  iNG
//
//  Created by William Dietz on 4/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ArticleListViewController.h"


@implementation ArticleListViewController

- (id)init
{
	if (self = [super init]) {
		// Initialize your view controller.
		self.title = @"Articles"; //TODO: groupname here!
	}
	return self;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview.
	// Release anything that's not essential, such as cached data.
}

- (void)dealloc
{
	[super dealloc];
}


@end
