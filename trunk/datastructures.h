//Will Dietz
//datastructures.h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import <objc/Object.h>
//#import <UIKit/UINavigationBar.h>
//#import <UIKit/UINavigationItem.h>
//#import <UIKit/UIView.h>
//#import <UIKit/UITextView.h>
//#import "NewsListView.h"

/*
static char * const TIN = "/var/root/bin/tin";
static char * const NEWSRC = "/var/root/.newsrc"; 
static char * const NNTPSERVER = "/etc/nntpserver";
static char * const POSTPONEDARTICLES = "/var/root/.tin/postponed.articles";
static char * const TIN_CHECKPARAMS  = "-rnQSc";
static char * const TIN_SENDPARAMS =  "-rnQo";
*/
/*
static NSString * NEWSROOT = @"/var/root/News/";
*/
//more!

static const int MAX_VIEW_DEPTH=8;

struct __GSFont * smaller_font;

static const double REFRESH_TIME = 0.3;

typedef enum
{
	msg_unread,
	msg_read
} readstatus;

//**********connection data:
@interface connection : Object
{
	NSString * _server;//name or ip, both work fine
	NSString * _username;
	NSString * _password; 
	NSString * _from; //hopefully " First Last <email@domain.com>"
	NSMutableArray * _groups;//all known groups
	NSMutableArray * _outGoingMessages;
	int connected;
}

- (void) init;

- (NSMutableArray *) sendMessages;
- (void) refresh; 
//accessor methods:
- (void) setServer: (NSString *) server;
- (int) setAuthWithUsername: (NSString *) user andPass: (NSString *) pass;
- (void) setFrom: (NSString * ) from;
- (NSMutableArray *) getGroups;
- (NSMutableArray *) getOutgoingMessages;
- (int) isConnected;


@end

//**********group data:
typedef struct
{
	NSString * groupName;
	int low;
	int high;		
	char subscribed;
	NSDate * updated;

} group;


//**********message on server:
@interface InMessage : Object
{
	NSString * newsgroup;//treat cross-posted items as different messages
	NSString * subject;
	NSString * content;
	NSDate * date;
	NSString * from;//who is /said/ to have sent it
	readstatus status;
}

- (id) init;

@end



//**********outgoing message:

@interface OutMessage: Object
{
	NSString * subject;
	NSString * newsgroups;
	NSString * content; 
	//from header made from connection
	//sender header by server.. hopefully
	//	
	char date[30]; //==ctime
}

- (id) init;

@end

//**********UI Datastructures

@interface NewsItemView : UIView
{
	NSString * _file;
	id _delegate;
	UINavigationItem * _titleItem;
	UIView * _parent;
	UITextView * _textView;

}
- (id) initWithFile: (NSString *) file andDelegate: delegate andParent: parent;
- (void) refresh;
@end

@interface NewsItem:  UIImageAndTextTableCell //could be actual file /or/ directory
{
	BOOL _isDir;
	NSString * _filename;
	UIView * _nextView;	
}

- (id) initWithFilename: (NSString *)filename isThatADir: (BOOL)isDir andNextView: (UIView *) nextView; 
- (UIView *) getView;
- (NSString *) getFile;
- (BOOL) isDir;
@end



