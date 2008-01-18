//Will Dietz
//SubscriptionView.m

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

#include "SubscriptionView.h"
#import <UIKit/UIPreferencesControlTableCell.h>
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UISwitchControl.h>
#import "newsfunctions.h"
#import "ViewController.h"
#import "iNewsApp.h"
//TODO: GET RID OF THIS:
#import "tin.h"


static SubscriptionView * sharedInstance = nil;

@implementation SubscriptionView

+ (SubscriptionView *) sharedInstance
{
	if ( sharedInstance )
		return sharedInstance;

	//else

	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin. x = rect.origin.y = 0;
	sharedInstance = [[SubscriptionView alloc] initWithFrame: rect ]; 

	return sharedInstance;
}


- (id) initWithFrame: (CGRect) rect
{
	[super initWithFrame: rect];

	//TODO: make this relative to rect
	_prefTable = [[UIPreferencesTable alloc] initWithFrame: CGRectMake(0.0f, 48.0f,
	320.0f, 480.0f - 16.0f - 48.0f*2 )  ];
	[_prefTable setDataSource: self];
    [_prefTable setDelegate: self];
	[_prefTable setBottomBufferHeight:44.0f];

	//initialize the row array
	_rows = [[NSMutableArray alloc] init];

	//initialize the curRow array
	_curRows = [[NSMutableArray alloc] init];

	_refresh = [[UIAlertSheet alloc]initWithTitle: L_UPDATING buttons:nil defaultButtonIndex:1 delegate:self context:self];
	[_refresh setDimsBackground:YES];

	NSArray *buttons = [NSArray arrayWithObjects: L_OK, L_CLEAR, L_CANCEL, nil];
	_search = [[UIAlertSheet alloc]initWithTitle:@"" buttons:buttons defaultButtonIndex:1 delegate:self context:self];
	[_search addTextFieldWithValue: @"" label: L_SEARCH_LABEL ];
	[_search setRunsModal: NO ];
	[_search setDimsBackground: YES];

	//queue used to basically be a 'pool' of row objects we use, just changing their title, for
	//displaying our table--this cuts down /big/ time on memory usage
	_memoryQueue = [[NSMutableArray alloc] init];

	//fill up the memoryQueue with rows....
	int i =0;
	UIPreferencesControlTableCell * row;
	UISwitchControl * button;
	for(; i < MAX_ROWS_ON_SCREEN; ++i )
	{
		row = [[UIPreferencesControlTableCell alloc] initWithFrame: CGRectMake(
				0.0f, 0.0f, 320.0f - 114.0 , 30.0f ) ];
		UISwitchControl * button = [[UISwitchControl alloc] initWithFrame: CGRectMake(
 320.f - 
114.0f, 36.0f, 114.0f, 48.0f ) ] ;
		[ [row titleTextLabel ] setFont: GSFontCreateWithName( SUBSCRIPTION_FONT, kGSFontTraitBold, SUBSCRIPTION_SIZE ) ];
		[ [row titleTextLabel ] setWrapsText: YES ];
//DEBUG
//		[ row setTitle: @"this.is.a.ridiculously.long.group.name.dear.god.why.doesnt.it.ever.end" ];
//ENDDEBUG
		[ row setControl: button ];

		[ _memoryQueue addObject: [ row retain ] ];
	}

	//create the header
	_prefHeader = [[UIPreferencesTableCell alloc] init];
	[_prefHeader setTitle: L_SUBSCRIPTIONS ];

	//setup the navbar
	UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(
	    0.0f, 0.0f, 320.0f, 48.0f)];
	_titleItem = [ [UINavigationItem alloc] initWithTitle: L_SUBSCRIPTIONS ];
	[nav showButtonsWithLeftTitle: L_SEARCH rightTitle: L_DONE leftBack: NO ]; 
	[nav pushNavigationItem: _titleItem];
	[nav setDelegate: self];
	[nav setBarStyle: 0];

	UINavigationBar *nav2 = [[UINavigationBar alloc] initWithFrame: CGRectMake(
		0.0f, 480.0f-48.0f -16.0f, 320.0f, 48.0f) ];
	_titleFilter = [ [UINavigationItem alloc] initWithTitle: @"" ];
	[nav2 pushNavigationItem: _titleFilter];
	[nav2 setBarStyle: 0];


	//add the views to ourself
	[self addSubview: nav];
	[self addSubview: _prefTable];
	[self addSubview: nav2];
	
	//done!
	return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////
//AlertSheet stuff
- (void)alertSheet: (UIAlertSheet *)sheet buttonClicked: (int)button
{
//	NSLog( @"Button pressed: %d", button );
	if( sheet == _refresh )
	{	
		NSLog( @"How did the buttonless refresh sheet get clicked?!" );

	}
	else if ( sheet == _search )
	{
		if ( button == 1 ) //OK
		{
			[ _refresh presentSheetInView: self];
	[NSTimer scheduledTimerWithTimeInterval: REFRESH_TIME target:self selector:@selector(updateSearch) userInfo:nil repeats:NO ];
		}
		else if ( button == 2 ) //clear
		{
			[ [ _search textField ] setText: @"" ];
		}
		if ( button != 2 )//don't close if just 'clear'
		{
			[ _search dismiss ];
		}
	}
	else
	{
//		NSLog( @"WTF?" );
	}
}

- (void) refreshMe
{
	//display the message.... help keep user patient :)
	[ _refresh presentSheetInView: self ];

	[NSTimer scheduledTimerWithTimeInterval: REFRESH_TIME target:self selector:@selector(delayedInit) userInfo:nil repeats:NO ];

}

- (void) delayedInit
{

	[self loadSettings ];

	//don't need that anymore... 	
	[ _refresh dismiss ];
}

- (void) updateSearch
{//called after search dialog closed...

//filter the rows by the search data given

	NSString * text = [ [ _search textField ] text ];
	int i;

	//clear the old array...
	while( [ _curRows count ] > 0 )
	{
		id element = [ _curRows lastObject ];
		[ _curRows removeLastObject ];
		[ element release ];
	}



	if( [ text compare: @"" ] == 0 )
	{
		for(i=0; i < [ _rows count ]; i++ )
		{
			[ _curRows addObject: [ [ NSNumber numberWithInt: i ] retain ] ];
		}

		[ _titleFilter setTitle: @"" ];
	}
	else
	{
		for(i=0; i < [ _rows count ]; i++ )
		{
		//	NSLog( @"%d: %@", i, [ [ _rows objectAtIndex: i ] getTitle ] );
			//for now, we just check if the group's name contains the indicated search parameter
			if ( [ [ [ _rows objectAtIndex: i ] getTitle ] rangeOfString: text options:NSCaseInsensitiveSearch].location != NSNotFound )
			{
			//	NSLog( @"%@ matches", [ [ _rows objectAtIndex: i ] getTitle ] );
				[ _curRows addObject: [ [ NSNumber numberWithInt: i ] retain ] ]; 
			} 
	
		}
		[ _titleFilter setTitle: [NSString stringWithFormat: L_FILTER_FORMAT, text ] ];
	}

	[_prefTable reloadData ];

	//all done
	[ _refresh dismiss ];

}


////////////////////////////////////////////////////////////////////////////////////////////////
// Start of Preference required methods
- (int) numberOfGroupsInPreferencesTable: (UIPreferencesTable*)table 
{
//	NSLog( @"numberOfGroups Called\n" );
	return 2;
}

- (int) preferencesTable: (UIPreferencesTable*)table numberOfRowsInGroup: (int)group 
{
//	NSLog( @"numberOfRowsInGroup, current row count is: %d\n", [_rows count] ); 
	switch( group )
	{
		case 0: return 0;
		case 1: return [_curRows count];
		default:
			NSLog( @"WTF: invalid group count in prefstable" );
			return 0;
	}
}


- (UIPreferencesTableCell*) preferencesTable: (UIPreferencesTable*)table cellForGroup: (int)group 
{

	switch (group)
	{
		case 0: return _prefHeader;
		case 1: return _prefHeader;
		default: return nil;
	}


}

- (BOOL) preferencesTable: (UIPreferencesTable*)table isLabelGroup: (int)group 
{
	return false;
    switch (group)
	{
		case 0: return true;
		case 1: return false;
		default:
			NSLog( @"WTF: invalid group count in prefstable" );
			return true;
	}

}

- (float)preferencesTable:(UIPreferencesTable *)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed {
//	NSLog( @"Proposed height: %d", proposed );
  switch (group) {
    case 0:
      return 30;
    case 1:
      if ( row >= 0 ) return 70;
		return 0;
     default:
      return proposed;
  }
}

- (UIPreferencesTableCell*) preferencesTable: (UIPreferencesTable*)table cellForRow: (int)row inGroup: (int)group 
{
//	NSLog( @"Requested cell: %d", row );
	switch( group )
	{
		case 0: return _prefHeader;
		case 1: 

			return [ [ _rows objectAtIndex: [ [ _curRows objectAtIndex: row ] intValue ] ] getRow ];

			break;
		default:
			NSLog( @"WTF: invalid group count in prefstable" );
			return nil;
	}
}

//call this to have us load our settings
- (void) loadSettings
{
	if ( [ _rows count] == 0 ) //if not initialized yet...
	{
	
		int i;
	
		SubPrefItem * item;
	
		for_each_group( i )
		{
	//		NSLog( @"Creating item: %d", i );
			item = [[SubPrefItem alloc] initWithID: i withRows: _memoryQueue ];
			[ _rows addObject: item ];
		}
	
		for(i=0;i< [_rows count]; i++)
		{
			[ _curRows addObject: [ [NSNumber numberWithInt: i ] retain ] ];
		}

	
		[ _rows sortUsingSelector: @selector( compareSubscription: ) ];	
	
	}
	NSLog( @"loaded settings... reloading data" );
	[ _prefTable reloadData ];
}

//call this to have us commit our settings
//in this case, this means subscribing/unsubscribing according to changes
- (void) saveSettings
{
	int i;
	SubPrefItem * item;
	for_each_group( i )
	{
		item = [ _rows objectAtIndex: i ];
		if ( [ item switchValue ] != active[ [ item getIndex] ].subscribed )//if it's changed...
		{
				doSubscribe( &active[ [item getIndex ] ], [item switchValue ] );
		}	
	}
//update listing...?
	readNewsRC();

}


//cleanup!
- (void) dealloc
{
	[super dealloc];
	[_prefTable release];
	while( [_rows count] > 0 )
	{
		id row = [_rows objectAtIndex: 0 ];
		[_rows removeObjectAtIndex: 0 ];
		[row release ];	
	}
	[_rows release];

	[_prefHeader release];

	[_titleItem release];

	[_search release];
	[_refresh release];

}

//////////////////////////////////////////////////////////////////////////////////////////////
//Navigation bar handler


- (void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)which;
{
	if ( which == 0 ) //right, go back
	{
		//commit changes
		
		[self saveSettings ];

		//TODO: refresh main window
		[ [ iNewsApp sharedInstance ] refreshTable ];

		//go back
		[ [ ViewController sharedInstance ] setView: [ [ iNewsApp sharedInstance ] mainView ] slideFromLeft: YES ];
		
	}
	else
	{ //left, 'search'
		[ _search popupAlertAnimated: YES ];

	}
}
@end




@implementation SubPrefItem

-(UIPreferencesControlTableCell *) getRow
{
	//really, a circular queue would be /way/ better for this
//	NSLog( @"Array count: %d\n", [ rowArray count ] );
	UIPreferencesControlTableCell * row = [ rowArray objectAtIndex: 0 ];		

	[ rowArray removeObjectAtIndex: 0];
	[ rowArray addObject: row ];
	//tell me when you change!
	[ [ row control ] removeTarget: nil forEvents: 1<<6 ];//please remove all for that event?.. yay it works!
	[ [ row control ] addTarget: self action:@selector(controlChanged:) forEvents:1<<6]; 
	//set initial button value...
	[ (UISwitchControl *)[ row control ] setValue: value ];
	//and title!
	[ row setTitle: [NSString stringWithFormat: 
		@"%s    \n   \n", //I wish I was kidding
		//TODO: FIX THIS--subclass the row item and make it not suck
		active[ index].name ] ];

//	NSLog( @"Row: %d, title: %s, value: %d", row, [row title], [ [ row control] value ] );

	return row;
}

- (void) controlChanged: (UISwitchControl *) button
{
//	NSLog( @"Button changed!" );
	value = [ button value ];
}


- (id) initWithID: (int) subid withRows: (NSMutableArray *) array

{
	[super init];
	index = subid;
	value= active[ index ].subscribed;
	title = [ NSString stringWithCString: active[index ].name ];
	rowArray = array;
	return self;
}

//accessor methods...

- (bool) switchValue
{
	return value;

}

- (int) getIndex
{
	return index;
}

- (NSString *) getTitle
{
	return [ title retain ];
}

- (NSComparisonResult)compareSubscription:(SubPrefItem *)s
{
//	NSLog( @"Comparer called on: %d vs %d", [self getIndex], [s getIndex] );
	return [ [ self getTitle ] compare: [ s getTitle] ];
}

- (void) dealloc
{
	[ super dealloc ];

	[title release];

}

@end
