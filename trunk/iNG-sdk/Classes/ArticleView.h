//
//u m
//  ArticleView.h
//  iNG
//
//  Created by William Dietz on 4/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NNTPArticle.h";


@interface ArticleView : UIView {
	NNTPArticle * _article;
	UIScrollView * _scroller;
	UIView * _contentView;
	UITextView * _subject;
	UITextView * _from;
	UIWebView * _body;


}

- (id)initWithFrame:(CGRect)frame andArt: (NNTPArticle *) art;


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  setBody
 *  Description:  Get the body from the article and display it on the view.
 * =====================================================================================
 */
- (void) setBody;

@end
