//newsfunctions.h
//Will Dietz
#import "tin.h"
#import "extern.h"

//Interaction between iNewsGroup and the tin code... also declare global variables here


//globals:

//TODO: these don't really belong here	
extern NSString *kUIButtonBarButtonAction;
extern NSString *kUIButtonBarButtonInfo;
extern NSString *kUIButtonBarButtonInfoOffset;
extern NSString *kUIButtonBarButtonSelectedInfo;
extern NSString *kUIButtonBarButtonStyle;
extern NSString *kUIButtonBarButtonTag;
extern NSString *kUIButtonBarButtonTarget;
extern NSString *kUIButtonBarButtonTitle;
extern NSString *kUIButtonBarButtonTitleVerticalHeight;
extern NSString *kUIButtonBarButtonTitleWidth;
extern NSString *kUIButtonBarButtonType;
//struct __GSFont * smaller_font;

//CGColorSpaceRef colorSpace;

static const double REFRESH_TIME = 0.3;
static const double SAVE_TIME = 20.0;
static const double HTTP_REQUEST_TIMEOUT = 10.0;

#define MAX_EMAIL 100
//if your email is longer than this, too bad
char email[ MAX_EMAIL ];

//This already exists, apparently.  From /where/ though?
//static const float col_bkgd[4] = {0.0, 0.0, 0.0, 0.0};

//static const float col_gray[4] = {0.34, 0.34, 0.34, 1.0};

//methods:

bool hasConnected();

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

void closeArticle();

void markArticleRead( int groupnum, int articlenum );

void markGroupRead( int groupnum );

bool isThreadRead( int threadnum ); 

void doSubscribe( struct t_group * group, int status );
