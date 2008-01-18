//Will Dietz
//PostView.h

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
#import <UIKit/UITextView.h>
#import "TitleRefresher.h"

//Show a given post.  Assumes article header is loaded, and located at arts[i] 


@interface PostView: UIView
{
	int _postnum, _groupnum; //which article in what group is this??

	UIView<TitleRefresher> * _prevView;
	bool _prevDir;

	UITextView * _textView;//object used to view the text...
	NSMutableArray * _rows;//used to display the header information
	UINavigationItem * _titleItem;//title
	NSString * _subject;
	NSString * _references;
	//the usuals..
	UITable * _table;
	UIAlertSheet * _message;
}

//singleton
+ (PostView *) sharedInstance;

- (id) initWithFrame: (CGRect) rect;

//specify the article number and the groupnumber we're an article in
- (void) setArticleNum: (int) artnum andGroupnum: (int) groupnum;

//call this to have us fetch the actual article information and update the gui accordingly
- (void) refresh;

//do the actual 'getting' of the article, we're called as a callback from a timer set in refresh...
- (void) getPost;

@end


