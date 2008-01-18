//Will Dietz
//ThreadView.h
//From the users's perspective this is /part/ of the groupview. So no 'refresh' button or anything or the sort.  Now we happen to re-use the same view, but that's beside the point. 

/*
    This file is part of iNewsGroup.

    iNewsGroup is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    iNewsGroup is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with iNewsGroup.  If not, see <http://www.gnu.org/licenses/>.

*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import <UIKit/UIDateLabel.h>
#import "PostView.h";
#import "TitleRefresher.h"

@interface ThreadView: UIView <TitleRefresher>
{
	int _groupnum;
	int _threadnum;//index in my_group
	
    NSMutableArray * _rows;// holds the row objects for our table 
    UINavigationItem * _titleItem;//title
    UITable * _table;

}

//singleton
+ (ThreadView *) sharedInstance;

- (id) initWithFrame: (CGRect) rect;

- (void) setGroupNum: (int) groupnum andThreadNum: (int) threadnum;

- (void) refresh;//for consistency's sake, this should be called BEFORE switching to this view.  Since this is a fast operation, that shouldn't be a problem.

- (void) refreshTitles;

@end

//a basically otherwise useless class to link together the article number with the cell
//possibly this will be useful later for adding other things to it
@interface ThreadViewItem: UIImageAndTextTableCell
{
	int _articleID;
	UIDateLabel * _dateLabel;
	UITextLabel * _fromLabel;
}

- (id) initWithArticle: (int) artnum;

- (float) rowHeight;

- (int) numLines;

- (int) article;

@end
