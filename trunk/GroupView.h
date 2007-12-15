//Will Dietz
//GroupView.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import "ThreadView.h"
#import "PostView.h"

//GroupView:
//view all the threads within a given group
//
//we only allocate one instance of this and use it for w/e we need.


//TODO: switch to 'sharedInstance' style?


@interface GroupView: UIView
{
	int _groupnum;//index in my_group array
    NSMutableArray * _rows;// holds the row objects for our table 
    UINavigationItem * _titleItem;//title, saved for memory purposes
	ThreadView * _threadView;//The only instance of threadView--TODO: switch to sharedInstance style?
	PostView * _postView;//The only isntance of postView--TODO: switch to sharedInstance style?
    UITable * _table;//table used to display the threads
	id _delegate;//our parent we call to change views.. TODO: clean up, use a centralized viewmanager, sharedInstance, etc.  This delegate nonsense causes warnings and is messy as all hell.
	UIAlertSheet * _connect;//alert sheet used to display "Refreshing" text while loading the headers for this newsgroup.

}

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

//used to set the delegate used to change views, etc
- (void) setDelegate: (id) delegate;

//an unfortunate design choice that has the child views (threadview and postview)
//call this (without any interface or anything) and we in turn call the right delegate.
//x.x
- (void) setView: (UIView *) view;

//another such unfortunate method
- (void) returnToPage;

@end


//class representing an element in the table--basically just a subclass of a normal
//table row, but stores the threadnumber in with it for easy access
@interface GroupItem: UIImageAndTextTableCell
{
	int _threadnum;

}

- (id) initWithThreadNum: (int) threadnum;

- (int) threadNum;
@end
