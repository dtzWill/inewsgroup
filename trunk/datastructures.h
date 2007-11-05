//Will Dietz
//datastructures.h
#import <Foundation/Foundation.h>


static char * const TIN = "/var/root/bin/tin";
static char * const NEWSRC = "/var/root/.newsrc"; 
static char * const NNTPSERVER = "/etc/nntpserver";
static char * const POSTPONEDARTICLES = "/var/root/.tin/postponed.articles";
static char * const TIN_CHECKPARAMS  = "-rnQSc";
static char * const TIN_SENDPARAMS =  "-rnQo";
//more!


typedef struct
{
	NSString * server;
	NSString * username;
	NSString * password; 
	NSString * from; //hopefully " First Last <email@domain.com>"
} connection;

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

typedef struct
{
	NSArray * nodes;//could have any amount of children...
		

} groupNode, * pGroupNode;

