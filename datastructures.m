//Will Dietz
//datastructures.m
#import "datastructures.h"



@implementation NewsItem

- (id) initWithFilename: (NSString *)filename isThatADir: (BOOL)isDir andNextView: (UIView *) nextView; 
{
	[ super init];
	_isDir = isDir;
	_filename = [filename copy];


	[ self setTitle: _filename ];


	//enable arrows
	[self setDisclosureStyle: 2];
	[self setShowDisclosure: YES]; 

	_nextView = nextView;
	return self;
}

- (UIView *) getView
{
	return _nextView;
}

- (NSString *) getFile
{
	return _filename;
}

- (BOOL) isDir
{
	return _isDir;
}

- (void) dealloc
{
	[_filename release];
//	[ _nextView release]; //?
	[super dealloc];

}



@end



@implementation NewsItemView

- (id) initWithFile: (NSString *) file andDelegate: delegate andParent: parent
{
	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin. x = rect.origin.y = 0;
	[ super initWithFrame: rect ];
	_delegate = delegate;
	_parent = parent;

	_file = [file copy];

	_titleItem = [ [UINavigationItem alloc] initWithTitle: _file ];
	
	UINavigationBar * nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(
	    0.0f, 0.0f, 320.0f, 48.0f)];
	[nav pushNavigationItem: _titleItem];
	[nav showButtonsWithLeftTitle:@"Back" rightTitle: nil leftBack:YES ];
	
	[nav setBarStyle: 0];
	[nav setDelegate: self];

	_textView = [[UITextView alloc] initWithFrame: CGRectMake(0.0f, 48.0f,
	    320.0f, 480.0f - 16.0f - 48.0f)];

	[self addSubview: nav];
	[self addSubview: _textView];
	

	return self;

}

- (void) refresh
{
	//[super refresh];
	NSString * message = [[NSString alloc] initWithContentsOfFile: _file ];

	[_textView setText: message ];	

}

- (void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)which;
{
	if ( which == 1 ) //left
	{
		if ( _parent != self ) //we're not root
		{
			[_parent refresh]; 
			[ _delegate setContentView: _parent ];
		}
	}
}

@end
