//globals:

#define RELEASE_AND_VERSION @"iNewsGroup 1.0.2"
#define AUTHOR @"Will Dietz"
#define CONTACT_EMAIL @"inewsgroupdev@gmail.com"
#define INEWSGROUP @"iNewsGroup"

//for button dictionaries
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

//button styles
#define BUTTON_NORMAL 0
#define BUTTON_RED 1
#define BUTTON_BACK 2
#define BUTTON_BLUE 3


//Timing consts
#define REFRESH_TIME 0.1
#define QUIT_WAIT_TIME 5.0
#define SAVE_TIME 20.0
#define HTTP_REQUEST_TIMEOUT 10.0

//if your email is longer than this, too bad
#define MAX_EMAIL 100

//this defines the 'queue' (pool) of rows we use for displaying
#define MAX_ROWS_ON_SCREEN 20

//font defines
#define GROUP_FONT "Helvetica"
#define GROUP_SIZE 14.0f
#define HEADER_FONT "Helvetica"
#define HEADER_SIZE 16.0f
#define POST_BODY_SIZE 14.0f
#define SUBSCRIPTION_FONT "Helvetica"
#define SUBSCRIPTION_SIZE 14.0f
#define THREAD_FONT "Helvetica"
#define THREAD_SIZE 14.0f
#define MAIN_FONT "Helvetica"
#define MAIN_SIZE 15.0f

//0b1111111111111111111111111111111
#define UNSIGNED_MINUS_ONE 2147483647

//from tin source, duplicated here for reference, etc
//#define PPA_ERR_NONE 0
//#define PPA_ERR_NO_MAIL 1
//#define PPA_ERR_FAILED_ART_FETCH 2
//#define PPA_ERR_GLOBAL_ERR 3
//#define PPA_ERR_SERVER 4

//keys for passing us information to start the message with
static const NSString * kSubject = @"subj";
static const NSString * kNewsGroup = @"groups";
static const NSString * kQuoteContent = @"quote";
static const NSString * kReferences = @"ref";

#define KEYBOARD_DELAY 0.5f


//Files
#define F_NEWSAUTH "/var/root/.newsauth"
#define F_NEWSEMAIL "/var/root/.newsemail"
#define F_NEWSRC "/var/root/.newsrc"
#define F_NNTPSERVER "/etc/nntpserver"
#define F_TMPNEW "/tmp/newarticle"
#define F_POSTPONEDARTICLES "/var/root/.tin/postponed.articles"
#define TIN_DIR "/var/root/.tin/"

//language strings
#define L_ABOUT @"About"
#define L_BACK @"Back"
#define L_COMPOSE @"Compose"
#define L_CANCEL @"Cancel"
#define L_CANT_POST @"You can't post on this server."
#define L_CLEAR @"Clear"
#define L_CONNECTING_MSG @"Connecting..."
#define L_DONE @"Done"
#define L_EMAIL @"Email"
#define L_ERROR_PROCESSING_MAIL @"ERR: failure processing mail"
#define L_ERROR_SERVER_DENIED @"ERR: Server denied"
#define L_ERROR_APPLICATION_ERROR @"ERR: Application Error"
#define L_GROUPVIEW @"GroupView"
#define L_INVALID_EMAIL @"Invalid Email. Set it in order to post."
#define L_LOADING @"Loading..."
#define L_LOADING_MSG @"Loading Message..."
#define L_MARK_READ @"Mark Read"
#define L_NEW_MSG @"New Message..."
#define L_NEWSGROUP_SETTINGS @"Newsgroup Settings"
#define L_OK @"OK"
#define L_PASSWORD @"Password"
#define L_POSTVIEW @"PostView"
#define L_PREFS @"Prefs"
#define L_PREFERENCES @"Preferences"
#define L_QUIT @"Quit"
#define L_QUOTE @"\n\nQuote:\n"
#define L_REALNAME @"Real name"
#define L_REFRESH @"Refresh"
#define L_REFRESHING_MSG @"Refreshing..."
#define L_REPLY @"Reply"
#define L_SEARCH @"Search"
#define L_SEARCH_LABEL @"search text"
#define L_SEND @"Send"
#define L_SEND_MSG @"Sending Message..."
#define L_SENT @"Message successfully sent!"
#define L_SERVER @"Server"
#define L_SUBSCRIPTIONS @"Subscriptions"
#define L_SUBSCRIPTIONSDOTDOTDOT @"Subscriptions..."
#define L_THREADVIEW @"ThreadView"
#define L_UPDATING @"Updating..."
#define L_USERNAME @"Username"

#define L_FILTER_FORMAT @"Filter: %@"
#define L_FROM_FORMAT @"From: %@ <%@>"
#define L_NEWSGROUP_FORMAT @"Newsgroup: %@"
#define L_QUOTE_FORMAT @"> %@\n"
#define L_SUBJ	@"Subj:"

//Images
#define IMG_READ @"ReadIndicator.png"
#define IMG_UNREAD @"UnreadIndicator.png"

//defaults
#define L_DEFAULT_FROM @"(Not specified)"
#define L_DEFAULT_SUBJECT @"(No Subject)"
