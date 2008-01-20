//Will Dietz
//test.c
//Test cases for the network connection code 
//Reads in a file tests that should be as follows:
//server\tuser\tpass
//or just 'server' if no user/pass.
//right now, iNG doesn't support user w/o pass, which in theory some servers use

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

//tin headers....
#include "tin.h"
#include "extern.h"
#include <stdio.h>

void init()
{
	init_alloc();
	hash_init();
	init_selfinfo();
	init_group_hash();
	set_signal_handlers();

}

int run_test( char * server, char * user, char * pass )
{
	//save parameters to proper files, etc
	FILE * f_nntpserver, * f_newsauth, * f_newsemail;
	//update /etc/nntpserver
	
	if ( ( f_nntpserver = fopen( "nntpserver", "w" ) ) == 0 )
	{
		//error! :(
		perror( "failed to open nntpserver" );
		return 0;
	}
	//else
	fprintf( f_nntpserver, "%s\n", server );

	fclose( f_nntpserver); //yay that was fun


	//update ~/.newsauth
	
	if ( ( f_newsauth = fopen( "/home/will/.newsauth", "w" ) )== 0 )
	{
		perror( "failed to open newsauth" );
		//error :(
		return 0;
	}
	//TODO: smarter behavior here?
	if (pass && strcmp( pass, "" ) &&
		user && strcmp( user, "" ) ) //don't bother writing if no username or password
		fprintf( f_newsauth, "%s\t%s\t%s\n",server, pass, user ); 	

	fclose( f_newsauth );

	unlink( "/home/will/.newsrc" );

		

	
	read_news_via_nntp = 1; //not local news server
	check_for_new_newsgroups = 1;//update newsgroup listing
	read_saved_news = 0;//don't just read local cache of messages

	tinrc.auto_reconnect = 1;
	tinrc.cache_overview_files = 1;

	tinrc.thread_articles = 3;//subject and reference

	changed = 1; //flag ripped out of auth.c so we can tell it
					//to try again anyway
	
	nntp_server =  server;

	printf( "server: %s\n", nntp_server ) ;	

	printf( "force_no_post: %d\n", force_no_post );

	strcpy( authusername, user );
	strcpy( authpassword, pass );
	force_auth_on_conn_open = ( authpassword[0] != '\0' );
	printf( "Force auth: %d\n", force_auth_on_conn_open );

//we assume if testing on x86 we have good working dns/gethostbyname
//	if ( !ResolveHostname( (char *)nntp_server ) )
//		return false; //DNS failed :(

	int connect = nntp_open();

	if ( connect != 0 )
	{
		switch( connect )
		{
			case -1:
				//auth failed...?
			default:
				break;
		}
		printf( "nntp_open() != 0, failing\n" );
		return 0;
	}

	int worked = check_auth(); //make sure we're auth'd....


	printf( "\n\ncheck_auth: %d\n", worked );
	if ( worked == -1 )//if failure....
	{
		return 0; // :-(
	}
	newsrc_active = 1;
	list_active = 0;

	read_news_active_file();

	read_newsgroups_file( 1 );

	printf(" closing...." );
	nntp_close();
	printf( "Success\n" );
	return 1;//it worked!!! \o/
}



int main( int argc, char ** argv )
{

	FILE * f_tests;

	if ( (  f_tests = fopen( "tests", "r" ) ) == 0 )
	{
		perror( "Could not open file 'tests' for testing.  See top of tests.c for information about this file." );
		return -1;//FAIL
	}

	char line[303];
	char server[100], user[100], pass[100];

	//do one-time initialization
	init();

	int i = 0;
	while( !feof( f_tests ) )
	{
		server[0] = 0;
		user[0] = 0;
		pass[0] = 0;

		fscanf( f_tests, "%[^\n]\n", line );
		if (sscanf( line, "[^\t]\n" ) ) //if contains no tabs...
		{//we assume then it only has one string, and it's a server name
			sscanf( line, "%[^\n]\n", server );
		}
		else
		{ //otherwise, pull all 3.
			sscanf( line, "%s\t%s\t%s\n", server, user, pass );
		}
		printf( "Running test %d on server: %s", i, server );

		if ( user[0] )//if we found a username..
		{
			printf( "with user: %s\tpass: %s", user, pass );
		}
		printf( "\n" );

		if ( run_test( server, user, pass ) == 0 )
		{
			fprintf( stderr, "Failed test %d\n", i );
			return i;
		}
		i++;
	}
		
	return 0;
} 


