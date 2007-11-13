//newsfunctions.h
//Will Dietz
#import "tin.h"
#import "extern.h"

struct __GSFont * smaller_font;

CGColorSpaceRef colorSpace;

static const double REFRESH_TIME = 0.3;

bool hasConnected();

int numSubscribed();

int numActive();

void init();

int init_server();

int updateData();

void printActive();

void readNewsRC();

NSString * getServer();
NSString * getUserName();
NSString * getPassword();

void setServer( NSString * server );

void setUserName( NSString * user );

void setPassword( NSString * pass );

void readSettingsFromFile();

void saveSettingsToFiles();

void loadGroup( int groupnum );

int artsInThread( int threadnum );

t_openartinfo _curArt;

bool openArticle( int groupnum, int articlenum);

NSString * readArticleContent();

NSString * articleFrom();

NSString * articleSubject();

void closeArticle();

void markArticleRead( int groupnum, int articlenum );

bool isThreadRead( int threadnum ); 

void doSubscribe( struct t_group * group, int status );
