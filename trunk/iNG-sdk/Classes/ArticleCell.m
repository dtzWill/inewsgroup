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
		[ self initializeComponents ];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier: (NSString *) ident {
	if ( self = [super initWithFrame:frame reuseIdentifier: ident ] ) {
		[ self initializeComponents ];
    }
    return self;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  initializeComponents
 *  Description:  Creates the ui components of this cell
 * =====================================================================================
 */
- (void) initializeComponents
{
	_subject = [ [ UILabel alloc ] initWithFrame: CGRectZero ];
	_date = [ [ UILabel alloc ] initWithFrame: CGRectZero ];
	_author = [ [ UILabel alloc ] initWithFrame: CGRectZero ];

	_subject.numberOfLines = 2;


	UIFont * font = [ UIFont systemFontOfSize: 12 ];
	_author.font = font;
	_date.font = font;

	_date.textColor = [ UIColor blueColor ];

	_author.lineBreakMode = UILineBreakModeClip;
	_date.lineBreakMode = UILineBreakModeClip;


	[ self addSubview: _subject ];
	[ self addSubview: _date ];
	[ self addSubview: _author ];
}

- (void)dealloc
{
	[ _subject release ];
	[ _date release ];
	[ _author release ];
    [super dealloc];
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  useArticle
 *  Description:  Uses the specified NNTPArticle to set the cell's attributes
 * =====================================================================================
 */
- (void) useArticle: (NNTPArticle *) art
{
	
	//leakage?? :(
	_subject.text = [ art.subject retain ];
	_date.text = [ art.date retain ];
	_author.text = [ art.from retain ];

}

- (void) layoutSubviews
{
	[ super layoutSubviews ];

	//TODO externalize these values
	const CGFloat DATE_AUTHOR_WIDTH = 100.0f;
	const CGFloat DATE_AUTHOR_HEIGHT = 25.0f;
	const CGFloat ACCESSORY_WIDTH = 30.0f;
	const CGFloat SPACING = 20.f;
	const int num_lines = 4;

	//x,y,width,height
	CGRect subjectRect = CGRectMake( 32.0f,
			( (64.0f - 16.0f * num_lines )/ 2.0f  ),
			self.bounds.size.width - DATE_AUTHOR_WIDTH - ACCESSORY_WIDTH - SPACING,
			16.0f * num_lines );

	[ _subject setFrame: subjectRect ];

	CGRect dateRect = CGRectMake( self.bounds.size.width - DATE_AUTHOR_WIDTH - ACCESSORY_WIDTH,
			10.0f,
			DATE_AUTHOR_WIDTH,
			DATE_AUTHOR_HEIGHT );

	[ _date setFrame: dateRect ]; 

	CGRect authorRect = dateRect;//copy?
	authorRect.origin.y += 30.0f;
	[ _author setFrame: authorRect ]; 

}

//- (void)drawRect:(CGRect)rect {
//	// insert drawing code here
//	
//}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  setSelected
 *  Description:  Changes UI to reflect selected state
 * =====================================================================================
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
	if ( selected )
	{
		//make all fonts to light
		_subject.textColor = [ UIColor lightTextColor ];
		_date.textColor = [ UIColor lightTextColor ];
		_author.textColor = [ UIColor lightTextColor ];
	}
	else
	{
		//use normal font colors
		_date.textColor = [ UIColor blueColor ];

		_subject.textColor = [ UIColor darkTextColor ];
		_author.textColor = [ UIColor darkTextColor ];
	}
}

@end
