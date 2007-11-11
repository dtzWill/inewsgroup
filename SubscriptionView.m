//Will Dietz
//SubscriptionView.m

#include "SubscriptionView.h"
#import <UIKit/UIPreferencesControlTableCell.h>
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


- (UIPreferencesTableCell*) preferencesTable: (UIPreferencesTable*)table cellForRow: (int)row inGroup: (int)group 
{
	switch( group )
	{
		case 0: return _prefHeader;
		case 1: return [[_rows objectAtIndex: row] retain];
		default:
			NSLog( @"WTF: invalid group count in prefstable" );
			return nil;
	}
}

- (void) loadSettings
{
	[ _rows removeAllObjects ];//clear it out...

	int i;
	UIPreferencesControlTableCell * row;
	UISwitchControl * button;
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

	[ _prefTable reloadData ];
}

- (void) saveSettings
{
	int i;
	for_each_group( i )
	{
		bool value = [ [ [ _rows objectAtIndex: i ] control ] value ];
		if ( value != active[ i ].subscribed )//if it's changed...
		{
				doSubscribe( &active[ i ], value );
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


