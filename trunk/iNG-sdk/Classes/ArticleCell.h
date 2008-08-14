//
//  ArticleCell.h
//  iNG
//
//  Created by William Dietz on 4/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NNTPArticle.h"

@interface ArticleCell : UITableViewCell {
	UILabel * _subject;
	UILabel * _date;
	UILabel * _author;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  initializeComponents
 *  Description:  Creates the ui components of this cell
 * =====================================================================================
 */
- (void) initializeComponents;

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  useArticle
 *  Description:  Uses the specified NNTPArticle to set the cell's attributes
 * =====================================================================================
 */
- (void) useArticle: (NNTPArticle *) art;


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  setSelected
 *  Description:  Changes UI to reflect selected state
 * =====================================================================================
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
