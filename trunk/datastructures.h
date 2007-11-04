//Will Dietz
//datastructures.h
#import <Foundation/Foundation.h>

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

} message;



