//
//  ArticleCell.m
//  iNG
//
//  Created by William Dietz on 4/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ArticleCell.h"


@implementation ArticleCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code here.
		_subject = [ [ UILabel alloc ] initWithFrame: CGRectZero ];
		_date = [ [ UILabel alloc ] initWithFrame: CGRectZero ];
		_author = [ [ UILabel alloc ] initWithFrame: CGRectZero ];

	//	[ self addSubview: _subject ];
	//	[ self addSubview: _date ];
	//	[ self addSubview: _author ];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier: (NSString *) ident {
	if ( self = [super initWithFrame:frame reuseIdentifier: ident ] ) {
		_subject = [ [ UILabel alloc ] initWithFrame: CGRectZero ];
		_date = [ [ UILabel alloc ] initWithFrame: CGRectZero ];
		_author = [ [ UILabel alloc ] initWithFrame: CGRectZero ];

	//	[ self addSubview: _subject ];
	//	[ self addSubview: _date ];
	//	[ self addSubview: _author ];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
	[ _subject release ];
	[ _date release ];
	[ _author release ];
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  useArticle
 *  Description:  Uses the specified NNTPArticle to set the cell's attributes
 * =====================================================================================
 */
- (void) useArticle: (NNTPArticle *) art
{
	_subject.text = art.subject;
//	_date.text = @"";
	_author.text = art.from;



}

- (void) layoutSubviews
{
	[ super layoutSubviews ];

	CGRect rect = CGRectMake( 32.0f, 0.0f, 185.0f, 16.0f * 4 );//XXX '4' == numLines
	//center it vertically
	rect.origin.y = ( (64.0f - 16.0f * 4)/ 2.0f  );	//XXX '4' == numLines
 
	[ _subject setFrame: rect ];

	[ _date setFrame: CGRectMake( 210.0f, 10.0f, 65.0f, 30.0f ) ];

	[ _author setFrame: CGRectMake(210.0f, 40.0f, 65.0f, 25.0f ) ];

}

//- (void)drawRect:(CGRect)rect {
//	// insert drawing code here
//	
//}

@end
