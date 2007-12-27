//newsfunctions.h
//Will Dietz
#import "tin.h"
#import "extern.h"
#import "consts.h"

//Interaction between iNewsGroup and the tin code

char email[ MAX_EMAIL ];


//methods:

bool hasConnected();

bool canPost();

int numSubscribed();

int numActive();

void init();

int init_server();

int updateData();

void printActive();

void readNewsRC();

void saveNews();

NSString * getServer();
NSString * getUserName();
NSString * getPassword();
NSString * getEmail();
NSString * getFromString();

void setServer( NSString * server );

void setUserName( NSString * user );

void setPassword( NSString * pass );

void setEmail( NSString * ns_email );

void readSettingsFromFile();

void saveSettingsToFiles();

void loadGroup( int groupnum );

int artsInThread( int threadnum );

t_openartinfo _curArt;

bool openArticle( int groupnum, int articlenum);

NSString * readArticleContent();

NSString * articleFrom();

NSString * articleSubject();

NSString * getReferences( int articlenum );

void closeArticle();

void markArticleRead( int groupnum, int articlenum );

void markGroupRead( int groupnum );

bool isThreadRead( int threadnum ); 

void doSubscribe( struct t_group * group, int status );

bool sendMessage( NSString * newsgroup, NSString * references, NSString * subject, NSString * message );
