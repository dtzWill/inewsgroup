//
//  ArticleViewController.m
//  iNG
//
//  Created by William Dietz on 4/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ArticleViewController.h"


@implementation ArticleViewController

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  initWithArt
 *  Description:  init with the specified article
 * =====================================================================================
 */
- (id)initWithArt: (NNTPArticle *) art
{
	if (self = [super init]) {
		// Initialize your view controller.
		_article = art;
		self.title = art.subject; 

		_articleView = [ [ ArticleView alloc] initWithFrame: CGRectMake(0.0, 0.0, 1.0, 1.0) andArt: [ _article retain ] ];
		_articleView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		_articleView.autoresizesSubviews = YES;
	}
	return self;
}


- (void)loadView
{
	// Create a custom view hierarchy.
    UIView *view = [ [ UIView alloc ] initWithFrame: [ UIScreen mainScreen ].applicationFrame ];
    view.autoresizesSubviews = YES;
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
    _articleView.frame = view.bounds;
    [ view addSubview: _articleView ];

    [ view release ];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview.
	// Release anything that's not essential, such as cached data.
}

- (void)dealloc
{
	[super dealloc];
	[ _articleView release ];
}


- (void) reallyLoadArticle: (NSTimer *) timer
{
	[ _articleView setBody ];
	_article.read = YES; 
	//[ (ArticleView *)self.view setBody ];
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  loadArticle
 *  Description:  gets the body for the article if we don't already have it
 * =====================================================================================
 */
- (void) loadArticle
{
	//ouch :(
	[ NSTimer scheduledTimerWithTimeInterval: (NSTimeInterval)0.01 target: self selector: @selector(reallyLoadArticle:) userInfo: nil repeats: NO ];
}

- (void) viewWillAppear: (bool) animated
{
	[ self loadArticle ];
}

@end
