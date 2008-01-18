//Will Dietz
//GroupView.h
//view all the threads within a given group
//
//we only allocate one instance of this and use it for w/e we need.

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
#import <UIKit/UIDateLabel.h>
#import "ThreadView.h"
#import "PostView.h"
#import "TitleRefresher.h"

@interface GroupView : UIView <TitleRefresher>
{
	int _groupnum;//index in my_group array
	NSMutableArray * _rows;//stores rows--right now this is worthless. TODO: get rid of this, since all of the information in here is already in various places
	NSMutableArray * _memoryQueue;
	UINavigationItem * _titleItem;//title, saved for memory purposes
	UITable * _table;//table used to display the threads
	UIAlertSheet * _connect;//alert sheet used to display "Refreshing" text while loading the headers for this newsgroup.

	int	_selectedRow;
}

//singleton
+ (GroupView *) sharedInstance;

//standard init, passing frame to display in
- (id) initWithFrame: (CGRect) rect;

//specify the group number to use when displaying--note that a call to 'refreshMe'
//must be called to have the effects take place. 
- (void) setGroupNum: (int) groupnum;

//method used to refresh the contents of the groupView--displays message and then does the refreshing.
- (void) refreshMe;

//Uses the appropriate newsfunctions to load the articles headers into memory
- (void) getArticles; 

//updates/assigns the titles for each row (the subject of the thread)
//any the read/unread status indicator
- (void) refreshTitles;

@end

@interface GroupViewRow : UIImageAndTextTableCell
{
	UIDateLabel * _dateLabel;
	UITextLabel * _fromLabel;
}
- (id) initWithFrame: (CGRect) frame;

- (int) numLines;

- (void) setDate: (double) epochtime;

- (void) setFrom: (NSString *) from;

@end

//class representing an element in the table--basically just a subclass of a normal
//table row, but stores the threadnumber in with it for easy access
@interface GroupItem : NSObject 
{
	int _threadnum;
}

- (id) initWithThreadNum: (int) threadnum; 

- (int) threadNum;

- (void) prepareRow: (GroupViewRow *) row;
@end


