//Will Dietz
//SubscriptionView.m

#include "SubscriptionView.h"
#import <UIKit/UIPreferencesControlTableCell.h>
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UISwitchControl.h>
//TODO: GET RID OF THIS:
#import "tin.h"

@implementation SubscriptionView

- (id) initWithFrame: (CGRect) rect
{
	[super initWithFrame: rect];

	//TODO: make this relative to rect
	_prefTable = [[UIPreferencesTable alloc] initWithFrame: CGRectMake(0.0f, 48.0f,
	320.0f, 480.0f - 16.0f - 48.0f)  ];
	[_prefTable setDataSource: self];
    [_prefTable setDelegate: self];
	[_prefTable setBottomBufferHeight:44.0f];

	//initialize the row array
	_rows = [[NSMutableArray alloc] init];

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
		[ [row titleTextLabel ] setFont: GSFontCreateWithName("Helvetica", kGSFontTraitBold,14) ];
		[ [row titleTextLabel ] setWrapsText: YES ];
//DEBUG
//		[ row setTitle: @"this.is.a.ridiculously.long.group.name.dear.god.why.doesnt.it.ever.end" ];
//ENDDEBUG
		[ row setControl: button ];

		[ _memoryQueue addObject: [ row retain ] ];
	}

	//create the header
	_prefHeader = [[UIPreferencesTableCell alloc] init];
	[_prefHeader setTitle: @"Subscriptions"];

	//setup the navbar
	UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(
	    0.0f, 0.0f, 320.0f, 48.0f)];
	_titleItem = [ [UINavigationItem alloc] initWithTitle: @"Subscriptions" ];
	[nav showButtonsWithLeftTitle: nil rightTitle: @"Done" leftBack: YES ]; 
	[nav pushNavigationItem: _titleItem];
	[nav setDelegate: self];
	[nav setBarStyle: 0];

	//add the views to ourself
	[self addSubview: nav];
	[self addSubview: _prefTable];
	
	//done!
	return self;
}

- (void) setDelegate: (id) delegate
{
	_delegate = delegate;

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
		case 1: return [_rows count];
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

			return [[_rows objectAtIndex: row] getRow ];

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
		[_delegate refreshTable ];	

		//go back
		[_delegate returnToMain];
		
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
	return title;
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
