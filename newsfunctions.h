//newsfunctions.h
//Will Dietz

/*
    This file is part of iNewsGroup.

    iNewsGroup is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    iNewsGroup is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with iNewsGroup.  If not, see <http://www.gnu.org/licenses/>.

*/

#import "tin.h"
#import "extern.h"
#import "consts.h"

//Interaction between iNewsGroup and the tin code

char email[ MAX_EMAIL ];
char name[ MAX_EMAIL ];

//methods:
//TODO: organize these

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
NSString * getRealName();
NSString * getFromString();

void setServer( NSString * server );

void setUserName( NSString * user );

void setPassword( NSString * pass );

void setEmail( NSString * ns_email );

void setRealName( NSString * realname );

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


double getNewestDateInThread( int threadnum );

NSString * getSenderForArt( int artnum );

NSString * getSenderForThread( int threadnum );
