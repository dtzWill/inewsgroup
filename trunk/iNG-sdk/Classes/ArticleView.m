//
//  ArticleView.m
//  iNG
//
//  Created by William Dietz on 4/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ArticleView.h"
#import "NNTPAccount.h"
#import "ArticleBodyPlainToHTML.h"

@implementation ArticleView

- (id)initWithFrame:(CGRect)frame andArt: (NNTPArticle *) art {
    if (self = [super initWithFrame:frame]) {
        // Initialization code here.
		_article = [art retain ];

		_scroller = [ [ UIScrollView alloc ] initWithFrame: frame ];
		_contentView = nil;
		_subject = nil;
		_from = nil;
		
		_body = [ [ UIWebView alloc ] initWithFrame: frame ];
		_body.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		_body.autoresizesSubviews = YES;
		_body.scalesPageToFit = YES;
		
		[ self addSubview: _body ];
		self.autoresizesSubviews = YES;

		[ _body loadHTMLString: @"Loading body..." baseURL: nil ];
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
	if ( ![ [ NNTPAccount sharedInstance ] isOffline ] )
	{//only bother saving if we have something to save....
		[ NSTimer scheduledTimerWithTimeInterval: (NSTimeInterval)0.01 target: [ NNTPAccount sharedInstance ] selector: @selector( saveCurrentGroup ) userInfo: nil repeats: NO ];
	}

	if ( _article.body )
	{
		NSString * htmlBody;
		if ( _article.contentType == nil || [ _article.contentType rangeOfString: @"text/plain" ].location != NSNotFound )
		{
			BOOL flowed = /*global use preference indicating use flow && */ [ _article.contentType rangeOfString: @"format=flowed" ].location != NSNotFound;
			htmlBody = [ ArticleBodyPlainToHTML convert: _article.body useFlowed: flowed ];
		}
		else
		{
			//hope it's html or something the webview likes....
			htmlBody = [ NSMutableString stringWithString: _article.body ];
		}

		[ _body loadHTMLString: htmlBody baseURL: nil ];
		//[ htmlBody release ];
	}
	else
	{
		if ( [ [ NNTPAccount sharedInstance ] isOffline ] )
		{
			[ _body loadHTMLString: @"Article not loaded, and in offline mode!" baseURL: nil ];
		}
		else
		{
			[ _body loadHTMLString: @"Error loading article!  If this persists, contact developer! (inewsgroupdev@gmail.com)." baseURL: nil ];
		}
		
	}

}

@end
