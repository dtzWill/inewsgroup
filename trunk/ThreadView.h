//Will Dietz
//ThreadView.h

//From the users's perspective this is /part/ of the groupview. So no 'refresh' button or anything or the sort.  Now we happen to re-use the same view, but that's beside the point. 

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import <UIKit/UISimpleTableCell.h>
#import "PostView.h";


@interface ThreadView: UIView
{
	int _groupnum;
	int _threadnum;//index in my_group
	
    NSMutableArray * _rows;// holds the row objects for our table 
    UINavigationItem * _titleItem;//title
    UITable * _table;
	id _delegate;
	PostView * _postView;

}

- (id) initWithFrame: (CGRect) rect;

- (void) setGroupNum: (int) groupnum andThreadNum: (int) threadnum;

- (void) refresh;//for consistency's sake, this should be called BEFORE switching to this view.  Since this is a fast operation, that shouldn't be a problem.

- (void) refreshTitles;

- (void) setDelegate: (id) delegate; //are YOU my mommmy?

- (void) returnToPage;

@end

//a basically useless class to link together the article number with the cell
//possibly this will be useful later for adding other things to it
@interface ThreadViewItem: UISimpleTableCell
{
	int _articleID;

}

- (id) initWithArticle: (id) artnum;

- (int) article;

@end
