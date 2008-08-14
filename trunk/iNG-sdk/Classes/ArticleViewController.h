//
//  ArticleViewController.h
//  iNG
//
//  Created by William Dietz on 4/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NNTPArticle.h"
#import "ArticleView.h"


@interface ArticleViewController : UIViewController {

	NNTPArticle * _article;
	ArticleView * _articleView;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  initWithArt
 *  Description:  init with the specified article
 * =====================================================================================
 */
- (id) initWithArt: (NNTPArticle *) art;

@end
