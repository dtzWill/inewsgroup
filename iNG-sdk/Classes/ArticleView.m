//
//  ArticleView.m
//  iNG
//
//  Created by William Dietz on 4/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ArticleView.h"


@implementation ArticleView

- (id)initWithFrame:(CGRect)frame andArt: (NNTPArticle *) art {
    if (self = [super initWithFrame:frame]) {
        // Initialization code here.
		_article = [art retain ];

		_scroller = nil;
		_contentView = nil;
		_subject = nil;
		_from = nil;

		_body = [ [ UITextView alloc ] initWithFrame: frame ];
		_body.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		_body.editable = NO;
		_body.font = [ UIFont systemFontOfSize: 14.0f ];
		_body.autoresizesSubviews = YES;

		[ self addSubview: _body ];
		self.autoresizesSubviews = YES;

		_body.text = @"Loading body...";
    }
    return self;
}

- (void)dealloc
{
	[super dealloc];

	[ _article release ];
	[ _scroller release ];
	[ _contentView release ];
	[ _subject release ];
	[ _from release ];
	[ _body release ];
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  setBody
 *  Description:  Get the body from the article and display it on the view.
 * =====================================================================================
 */
- (void) setBody
{
	[ _article getBodyIfNeeded ];

	_body.text = [ [ NSString alloc ] initWithString: _article.body ];

}

@end
