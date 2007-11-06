//Will Dietz
//datastructures.h
#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import "NewsListView.h"


static char * const TIN = "/var/root/bin/tin";
static char * const NEWSRC = "/var/root/.newsrc"; 
static char * const NNTPSERVER = "/etc/nntpserver";
static char * const POSTPONEDARTICLES = "/var/root/.tin/postponed.articles";
static char * const TIN_CHECKPARAMS  = "-rnQSc";
static char * const TIN_SENDPARAMS =  "-rnQo";
static NSString * NEWSROOT = @"/var/root/News/";
//more!

static const int MAX_VIEW_DEPTH=8;



//**********connection data:
typedef struct
{
	NSString * server;
	NSString * username;
	NSString * password; 
	NSString * from; //hopefully " First Last <email@domain.com>"
} connection;



//**********messages:
typedef struct 
{
	NSString * subject;
	NSString * newsgroups;
	NSString * content; 	
	char date[30]; //==ctime
} out_message;

enum readstatus
{
	msg_unread,
	msg_read
};

typedef struct
{
	NSString * newsgroup;//treat cross-posted items as different messages
	NSString * subject;
	NSString * content;
	NSDate * date;
	enum readstatus status;
} in_message;



//**********Structures for storing the various items in memory

@interface NewsItemView : UITextView
{
	NSString * _file;
	id _delegate;
	UIView * _parent;

}
- (id) initWithFile: (NSString *) file andDelegate: delegate andParent: parent;

@end

@interface NewsItem:  UIImageAndTextTableCell //could be actual file /or/ directory
{
	BOOL _isDir;
	NSString * _filename;
	UIView * _nextView;	
}

- (id) initWithFilename: (NSString *)filename isThatADir: (BOOL)isDir andNextView: (UIView *) nextView; 
- (UIView *) getView;

@end

/*
typedef struct
{
	NSMutableArray * nodes;//could have any amount of children...
	NewsListView * view;		

} directoryNode, * pDirectoryNode;
*/



