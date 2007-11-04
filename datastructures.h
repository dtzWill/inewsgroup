//Will Dietz
//datastructures.h
#import <Foundation/Foundation.h>

const char * const TIN = "/var/root/bin/tin";
const char * const NEWSRC = "/var/root/.newsrc";
const char * const NNTPSERVER = "/etc/nntpserver";
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
	char[30] date; //==ctime
} out_message;

enum readstatus
{
	unread,
	read
}

typedef struct
{
	NSString * newsgroup;//treat cross-posted items as different messages
	NSString * subject;
	NSString * content;
	NSDate * date;
	readstatus status;
} in_message;

