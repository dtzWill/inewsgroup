//newsfunctions.h
//Will Dietz
#import "tin.h"
#import "extern.h"

//Interaction between iNewsGroup and the tin code... also declare global variables here

//TODO: push global variables into their own header, and perhaps same with the language variables

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

static const int BUTTON_NORMAL = 0;
static const int BUTTON_RED = 1;
static const int BUTTON_BACK = 2;
static const int BUTTON_BLUE = 3;


static const double REFRESH_TIME = 0.3;
static const double QUIT_WAIT_TIME = 5.0; //yep, I'm valuing appearance of success more than actual success.
static const double SAVE_TIME = 20.0;
static const double HTTP_REQUEST_TIMEOUT = 10.0;

#define MAX_EMAIL 100
//if your email is longer than this, too bad
char email[ MAX_EMAIL ];

//TODO: find /all/ string literals, and put them here.
//	file names (png's used), and in particular the ui messages
//		perhaps put all ui messages in a file 'lang.h' or some such for easy
//		modification



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
