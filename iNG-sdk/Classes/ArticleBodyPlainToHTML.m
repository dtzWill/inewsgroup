//
//  ArticleBodyPlainToHTML.m
//  iNG
//
//  Created by Will Dietz on 16/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ArticleBodyPlainToHTML.h"

NSString * unstuff( NSString * string );
int quoteLevel( NSString * string );
BOOL is_flowed( NSString * string );

//removes leading space if found
NSString * unstuff( NSString * string )
{
	//XXX: memory use?
	if ( string && [ string length ] > 0 && [ string characterAtIndex: 0 ] == ' '  )
	{
		return [ string substringFromIndex: 1 ];
	}
	return string;
}

BOOL is_flowed( NSString * string )
{
	//a line is considered 'flowed' if last character is a space...
	return [ string characterAtIndex: ( [ string length ] - 1 ) ] == ' ';
}

//returns the quote level of this string... '0' if none
int quoteLevel( NSString * string )
{
	int quotes = 0;
	while( [ string length ] > quotes && [ string characterAtIndex: quotes ] == '>' )
	{
		quotes++;
	}
	return quotes;
}


@implementation ArticleBodyPlainToHTML
/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  convert
 *  Description:  converts body to html as needed, applying format=flowed as appropriate
 * =====================================================================================
 */
+ (NSString *) convert: (NSString *) plainBody useFlowed: (BOOL) flow
{

	NSMutableString * htmlBody = [ [ NSMutableString alloc ] init ];
	
	//NSLog( @"converting plainbody: |||%@||| with flow? %d", plainBody, flow );
	NSArray * lines = [ plainBody componentsSeparatedByString: @"\n" ];
	
	NSEnumerator * enumer = [ lines objectEnumerator ];
	
	NSMutableString * flowed = [ [ NSMutableString alloc ] init ];
	NSString * line_unmutable = [ enumer nextObject ];

	//TODO: escape '<' and '&' and maybe others!
	
	//style information for quotes to look right!
	//...ouch at this line :(
	[ htmlBody appendString:
	 @"<style type=\"text/css\">	div.quote {	border-style: solid; border-left-width: 2px; border-right-width: 0px; border-top-width: 0px; border-bottom-width: 0px; padding-left: 15px; border-color: blue }</style>"
	];
	[ htmlBody appendString: @"<font size=10>" ];
	//flow processing
	while( line_unmutable != nil )
	{
		//NSLog( @"First loop, line: %@", line_unmutable );
		//loop through all lines...
		//we start each loop iteration and start of new paragraph...
		NSMutableString * line = [ NSMutableString stringWithString: line_unmutable ];
		
		int quotes = quoteLevel( line );
	
		NSString * nextline;
		//we flow lines that are flowed, but refuse to do so across quote levels (following the "quote-level-wins" rule)
		while( ( nextline = [ enumer nextObject ] ) != nil && quoteLevel( nextline ) == quotes && is_flowed( line ) )
		{
			[ line appendString: [ nextline substringFromIndex: quoteLevel( nextline ) ] ];
		}
		
		[ flowed appendString: line ];
		
		if ( nextline )
		{
			[ flowed appendString: @"\n" ];
		}
		
		line_unmutable = nextline;
		
	}
	
	//okay that was fun, now to do goodness with quotes
	
	lines = [ flowed componentsSeparatedByString: @"\n" ];
	int quotes_prev = 0;
	BOOL first_line = YES;
	for ( NSString * line in lines )
	{
		int quotes = quoteLevel( line );
		//NSLog( @"Quote level: %d on line: ||%@||", quotes, line );
		//remove quote marks....and unstuff
		line = [ line substringFromIndex: quotes ];
		line = unstuff( line );
		if ( quotes != quotes_prev )
		{
			//note only one of these gets executed
			for ( ; quotes_prev < quotes; quotes_prev++ )
			{
				//increase quote level
				[ htmlBody appendString: @"<div class=\"quote\" >" ];
			}
			for ( ; quotes_prev > quotes; quotes_prev-- )
			{
				//decrease quote level
				[ htmlBody appendString: @"</div>" ];
			}
		}
		else
		{
			//same quote level.. add newline if not first line
			if ( !first_line )
			{
				[ htmlBody appendString: @"<br />" ];
			}
		}
		[ htmlBody appendString: line ];
		first_line = NO;
		quotes_prev = quotes;
	}
	//close all unclosed quote divs
	for ( ; quotes_prev > 0; quotes_prev-- )
	{
		[ htmlBody appendString: @"</div>" ];
	}
	
	[ htmlBody appendString: @"</font>" ];
//	NSLog( @"HTML BODY: %@", htmlBody );
					 
	 return htmlBody;	
}

@end
