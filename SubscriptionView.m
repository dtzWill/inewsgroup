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


	_rows = [[NSMutableArray alloc] init];

	_memoryQueue = [[NSMutableArray alloc] init];

	_prefHeader = [[UIPreferencesTableCell alloc] init];
	[_prefHeader setTitle: @"Subscriptions"];


	UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(
	    0.0f, 0.0f, 320.0f, 48.0f)];
	_titleItem = [ [UINavigationItem alloc] initWithTitle: @"Subscriptions" ];
	[nav showButtonsWithLeftTitle: nil rightTitle: @"Done" leftBack: YES ]; 
	[nav pushNavigationItem: _titleItem];
	[nav setDelegate: self];
	
	[nav setBarStyle: 0];

	[self addSubview: nav];
	[self addSubview: _prefTable];
	
	return self;
}

- (void) setDelegate: (id) delegate
{
	_delegate = delegate;

}

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
	NSLog( @"Requested cell: %d", row );
	switch( group )
	{
		case 0: return _prefHeader;
		case 1: 
			if ( [ _memoryQueue count ] > MAX_ROWS_ON_SCREEN )
			{
				//if queue is full, remove one and free it's memory
				SubPrefItem * r = [ _memoryQueue objectAtIndex: 0 ];
				[ r releaseRow ];
				[ _memoryQueue removeObjectAtIndex: 0 ];

			}			
			[ _memoryQueue addObject: [ _rows objectAtIndex: row ] ]; //enqueue this one

			return [[_rows objectAtIndex: row] getRow ];

			break;
		default:
			NSLog( @"WTF: invalid group count in prefstable" );
			return nil;
	}
}

- (void) loadSettings
{
	while( [_rows count] > 0 )
	{
		id row = [_rows objectAtIndex: 0 ];
		[_rows removeObjectAtIndex: 0 ];
		[row release ];	
	}
	[ _rows removeAllObjects ];//clear it out...

	int i;

//	[ _rows release ];
//	_rows = [NSMutableArray arrayWithCapacity: numActive() ];

	SubPrefItem * item;

	for_each_group( i )
	{
//		NSLog( @"Creating item: %d", i );
		item = [[SubPrefItem alloc] initWithID: i ];
		[ _rows addObject: item ];
	}


	[ _rows sortUsingSelector: @selector( compareSubscription: ) ];	

/*
	for_each_group( i )
	{
		row = [[UIPreferencesControlTableCell alloc] init];
		button = [[UISwitchControl alloc] initWithFrame: CGRectMake( 320.f - 
114.0, 11.0f, 114.0f, 48.0f ) ];
		[button setValue: active[ i ].subscribed ];
		[ row setTitle: [NSString stringWithCString: active[ i ].name ] ];
		[ row setControl: button ];
		[ _rows addObject: row ];
	}
*/

	NSLog( @"loaded settings... reloading data" );
	[ _prefTable reloadData ];
}

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
	//only initializes as needed.. hopefully this helps speed things up
	if ( ![self isInitialized ] )
	{
		row = [[UIPreferencesControlTableCell alloc] initWithFrame: CGRectMake(
				0.0f, 0.0f, 320.0f - 114.0 , 30.0f ) ];
		UISwitchControl * button = [[[UISwitchControl alloc] initWithFrame: CGRectMake(
 320.f - 
114.0f, 36.0f, 114.0f, 48.0f ) ] autorelease];
		[button setValue: value ];
//		[ [row titleTextLabel ] setFrame: CGRectMake( 0.0f, 0.0f, 320.0f - 114.0f, 32.0f ) ];
		[ [row titleTextLabel ] setFont: GSFontCreateWithName("Helvetica", kGSFontTraitBold,14) ];
		[ [row titleTextLabel ] setWrapsText: YES ];
//		[ [row titleTextLabel ] setVerticallyCenterText: NO ];
//		[ row setTitle: @"this.is.a.ridiculously.long.group.name.dear.god.why.doesnt.it.ever.end" ];
		[ row setTitle: [NSString stringWithFormat: 
			@"%s    \n   \n", //I wish I was kidding
			active[ index].name ] ];
		[ row setControl: button ];
	}

	return row;
}


- (id) initWithID: (int) subid
{
	[super init];
	row = 0;
	index = subid;
	title = [ NSString stringWithCString: active[index ].name ];
	value= active[ index ].subscribed;
	return self;
}


- (bool) isInitialized
{
	return ( row != 0 );
}


- (void) releaseRow
{
	NSLog( @"releasing row: %d", index );
	if( [self isInitialized] ){
		value = [ [row control] value ];
		 [ row release ];
		row = 0;
	}

}

- (bool) switchValue
{
	if ( ! [self isInitialized] ) return value;

	return [ [  row control ] value ];

}

- (int) getIndex
{
	return index;
}

- (NSComparisonResult)compareSubscription:(SubPrefItem *)s
{
//	NSLog( @"Comparer called on: %d vs %d", [self getIndex], [s getIndex] );
	return [ [ self getTitle ] compare: [ s getTitle] ];
}

- (NSString *) getTitle
{
	return title;
}

- (void) dealloc
{
	[ super dealloc ];

	[self rowRelease];
	[title release];

}

@end
