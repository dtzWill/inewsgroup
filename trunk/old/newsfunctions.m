//newsfunctions.c
//Will Dietz
#import <unistd.h>
#import <stdio.h>
#import "newsfunctions.h"
#import "datastructures.h"

//tin launchers:

int tinCheckForMessages()
{
//async-ly run tin to download new messages

//TODO:
//	Check process list and don't run it /again/
//	if already running
	int pid = fork();
	char * exec_args[] = { TIN, TIN_CHECKPARAMS };	
	if ( pid < 0 ) //error
		return -1;
	if ( pid == 0 )//child
	{
		freopen( "/dev/null", "w", stdout );
		freopen( "/dev/null", "w", stderr );
		return 100 * execvp( exec_args[0], &exec_args[0] );
	}

	return 0;
}

int tinSendMessages()
{
//async-ly run tin to send postponed messages

//maybe check if it actually was sent..???
	int pid = fork();
	char *exec_args[] = { TIN,TIN_SENDPARAMS  };	
	if ( pid < 0 ) //error
		return -1;
	if ( pid == 0 )//child
	{
		freopen( "/dev/null", "w", stdout );
		freopen( "/dev/null", "w", stderr );
		execvp( exec_args[0], &exec_args[0] );

		//check if anything was actually sent..
	}

	return 0;
}

//write the message to the send queue
void sendMessage( out_message msg, connection c )
{
	time_t timestamp;
	time( &timestamp );
	FILE * file = fopen( POSTPONEDARTICLES, "a" );
	
	if ( file <= 0)	perror( "error opening file");
	else
	{
		fprintf( file, "From root %s", ctime( &timestamp ) ); //includes linebreak??
		fprintf( file, "From: %s\n", [c.from cString] );
		fprintf( file, "Subject: %s\n", [msg.subject cString] );
		fprintf( file, "Newsgroups: %s\n", [msg.newsgroups cString] );
		fprintf( file, "Summary:\nKeywords:\n\n" ); //needed?
		fprintf( file, "%s\n\n", [msg.content cString] );
		fflush( file );
		fclose ( file );
	}
}


