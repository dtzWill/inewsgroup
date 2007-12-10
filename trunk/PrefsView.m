//Will Dietz
//PrefsView.m

#include "PrefsView.h"

@implementation PrefsView

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
	_rowsAbout = [[NSMutableArray alloc] init];

	UIPreferencesTextTableCell * _row;
	//server
	_row = [[UIPreferencesTextTableCell alloc] init ];
	[_row setTitle: @"Server" ];
	[[_row textField] setText: @""];//blank for now, fill this in!!
	[_rows addObject: _row];

	//username
	_row = [[UIPreferencesTextTableCell alloc] init ];
	[_row setTitle: @"Username"];
	[[_row textField] setText: @""];
	[_rows addObject: _row];

	//password
	_row = [[UIPreferencesTextTableCell alloc] init ];
	[_row setTitle: @"Password"];
	[[_row textField] setText: @""];
	[_rows addObject: _row];


	//email
	_row = [[UIPreferencesTextTableCell alloc] init ];
	[_row setTitle: @"Email:"];
	[[_row textField] setText: @""];
	[_rows addObject: _row];

	//put information about iNewsGroup and author here, copyright, etc
	//about
	UIPreferencesTableCell * _rowAbout = [[UIPreferencesTableCell alloc] init ];
	[ _rowAbout setTitle: @"iNewsGroup 0.0.7" ];
//	[ [ _rowAbout valueTextLabel ] setCentersHorizontally: YES ];
	[ _rowsAbout addObject: _rowAbout ];

	_rowAbout = [[UIPreferencesTableCell alloc] init ];
//	[ [ _rowAbout valueTextLabel ] setCentersHorizontally: YES ];
	[ _rowAbout setTitle: @"Will Dietz" ];
	[ _rowsAbout addObject: _rowAbout ];

	_rowAbout = [[UIPreferencesTableCell alloc] init ];
//	[ [ _rowAbout valueTextLabel ] setCentersHorizontally: YES ];
	[ _rowAbout setTitle: @"inewsgroupdev@gmail.com" ];
	[ _rowsAbout addObject: _rowAbout ];



	[_prefTable reloadData];


	_prefHeader = [[UIPreferencesTableCell alloc] init];
	[_prefHeader setTitle: @"NewsGroup Settings"];


	_prefAboutHeader = [[UIPreferencesTableCell alloc] init];
	[_prefAboutHeader setTitle: @"About:" ];

	UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(
	    0.0f, 0.0f, 320.0f, 48.0f)];
	_titleItem = [ [UINavigationItem alloc] initWithTitle: @"Preferences" ];
	[nav showButtonsWithLeftTitle: @"Quit" rightTitle: @"Done" leftBack: YES ]; 
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
	return 4;
}

- (int) preferencesTable: (UIPreferencesTable*)table numberOfRowsInGroup: (int)group 
{
//	NSLog( @"numberOfRowsInGroup, current row count is: %d\n", [_rows count] ); 
	switch( group )
	{
		case 0: return 0;
		case 1: return [_rows count];
		case 2: return 0;
		case 3: return [_rowsAbout count];
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
		case 2: return _prefAboutHeader;
		case 3: return _prefAboutHeader;
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
		case 2: return true;
		case 3: return false;
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
		case 2:	return _prefAboutHeader;
		case 3:	return [[_rowsAbout objectAtIndex: row] retain ];
		default:
			NSLog( @"WTF: invalid group count in prefstable" );
			return nil;
	}
}

- (void) loadSettings
{
	readSettingsFromFile();//if anything has messed things up... pull from file again

	[ [ [ _rows objectAtIndex: SERVER_ROW ] textField ] setText: getServer() ]; 
	[ [ [ _rows objectAtIndex: USER_ROW ] textField ] setText: getUserName() ];
	[ [ [ _rows objectAtIndex: PASS_ROW ] textField ] setText: getPass() ];
	[ [ [ _rows objectAtIndex: EMAIL_ROW ] textField ] setText: getEmail() ]; 
	[ _prefTable reloadData ];
}

- (void) saveSettings
{
	setServer( [ [ [ _rows objectAtIndex: SERVER_ROW ] textField ] text ] );
	setUserName( [ [ [ _rows objectAtIndex: USER_ROW ] textField ] text ] );
	setPassword( [ [ [ _rows objectAtIndex: PASS_ROW ] textField ] text ] );
	setEmail( [ [ [ _rows objectAtIndex: EMAIL_ROW ] textField ] text ] );

	saveSettingsToFiles();
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

	while( [_rowsAbout count] > 0 )
	{
		id row = [_rowsAbout objectAtIndex: 0 ];
		[_rowsAbout removeObjectAtIndex: 0 ];
		[row release ];	

	}

	[_rows release];
	[_rowsAbout release];


	[_prefHeader release];
	[_prefAboutHeader release];	

	[_titleItem release];

}


//Navigation bar handler


- (void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)which;
{
	if ( which == 0 ) //right, go back
	{
		//commit changes
		

		//refresh main window

		[self saveSettings ];

		//go back
		[_delegate returnToMain];
		
		if( !hasConnected() )
		{//maybe this made things better..?
			[ _delegate connect ];
		}
	}
	
	else
	{

		tin_done( EXIT_SUCCESS );
	}

}
@end


