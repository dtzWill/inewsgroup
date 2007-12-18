//Will Dietz
//View Controller.m

#import "ViewController.h"

static ViewController *sharedInstance = nil;

@implementation ViewController

+ (ViewController *) sharedInstance
{
	if ( sharedInstance )
		return sharedInstance;

	//else

	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin. x = rect.origin.y = 0;
	sharedInstance = [[ViewController alloc] initWithFrame: rect ]; 

	return sharedInstance;
}

- (id) initWithFrame: (CGRect) rect
{
	[super initWithFrame: rect];
	_prevView = nil;
	_prevView = 0; //...sure
	return self;
}


- (void) setView: (UIView *) view slideFromLeft: (bool) left
{
	NSLog( @"about to transition" );
	int dir = left? 1: 2;	

	_prevDir = left;
	_prevView = _curView;
	_curView = view;

    [ self  transition:dir toView:view ];

}

- (UIView *) getPrevView
{
	return _prevView;
}

- (bool) getPrevDir
{
	return _prevDir;
}

- (void) setCurView: (UIView *) view;
{
	_curView = view;
}

@end




