//Will Dietz
//datastructures.m
#import "datastructures.h"



@implementation NewsItem

- (id) initWithFilename: (NSString *)filename isThatADir: (BOOL)isDir andNextView: (UIView *) nextView; 
{
	[ super init];
	_isDir = isDir;
	_filename = [filename copy];
//TODO:
//	Set title to be either application name (when root)
//	or the newsgroup name.. or the part of it we've hit thus
// far.
// Example:
// "iNewsGroup" -> "class" -> "class.cs232" (etc)


	[ self setTitle: _filename ];


	//enable arrows
	[self setDisclosureStyle: 2];
	[self setShowDisclosure: YES]; 

	_nextView = nextView;
	return self;
}

- (UIView *) getView;
{
	return _nextView;
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
	[ super init ];
	_delegate = delegate;
	_parent = parent;
	


}


@end
