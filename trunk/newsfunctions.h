//newsfunctions.h
//Will Dietz
#import "tin.h"

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

void saveSettingsToFiles();

void loadGroup( int groupnum );

int artsInThread( int threadnum );
