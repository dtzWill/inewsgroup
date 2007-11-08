//newsfunctions.c
//Will Dietz
//#import <unistd.h>
//#import <stdio.h>
#import "datastructures.h"
#import "newsfunctions.h"
#import "tin.h"

int numSubscribed()
{//TODO: Better way??
	int subCount = 0;
	int i;
	for_each_group(i)
		if ( active[i].subscribed )
			subCount++;
	return subCount;
}


int numActive()
{
	return num_active;

}

void readNewsRC()
{
	//TODO: do something with this number?
	read_news_via_nntp = true;
	list_active = true;
	newsrc_active = false;
/*	newsrc_active = true;
	list_active = false; */
	int num_subscribed = read_newsrc( newsrc, false );
	list_active = true;
	newsrc_active = false;

}


void init()
{
	init_alloc();
	hash_init();
	init_selfinfo();
	init_group_hash();
	//no we don't want anything keybinding-related, but for now
	//leaving this here so any code in tin depending on it doesn't
	//die horribly.
	setup_default_keys(); /* preinit keybindings */

}


int init_server()
{
	set_signal_handlers();
	
	read_news_via_nntp = true;
	check_for_new_newsgroups = true;
	read_saved_news = false;

	newsrc_active = false;
	list_active = true;
	
	//batch_mode = true;//silence/speed things up...?

	nntp_server =  getserverbyfile(NNTP_SERVER_FILE);
	NSLog ( @"server: %s\n", nntp_server ) ;	
//	read_server_config();

	if ( !nntp_open() )
	{
		NSLog( @"Established connection to %s\n", nntp_server );
	}
	else
	{
		NSLog( @"error connecting to server: %s\n", nntp_server );
		return false;
	}

	postinit_regexp();

	return true;//it worked!!! \o/
}


//	read_server_config();


	//char user[30], pass[30];

/*	//test connection by sending 'list' command
	char response[100];
	FILE * file;
	if ( file = nntp_command("list",215, response, 100 ) ) 
		NSLog( @"worked:%s\n", response );
	else
	{
		NSLog( @"failure\n" );
		return false; // :(
	}
	drain_buffer( file );

	TIN_FCLOSE( file );
*/
//	load_newnews_info();

//	create_save_active_file();

	//read_descriptions(TRUE);

int updateData()
{
	
	newsrc_active = false;
	list_active = true;
	
	read_news_active_file();

	read_newsgroups_file( true );

	//TODO: use this value (and check that it means what the variable name suggests it emans)	
	int num_subscribed = read_newsrc( newsrc, true );

	create_save_active_file();

	return true;//it worked!!! \o/
/* print out response of all the groups on this server
	char * line;
	while ( line = tin_fgets( file, FALSE ) )
	{
		printf( "%s\n", line );

	}
*/
};


void printActive()
{
	int i;
	NSLog( @"%d\n", num_active );
	for_each_group(i)
	{
		NSLog( @"%s:%d\n", active[i].name, active[i].next );

	}


};
