//Will Dietz
//View Controller.m

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

#import "ViewController.h"

static ViewController *sharedInstance = nil;

@implementation ViewController

+ (ViewController *) sharedInstance
{
	if ( sharedInstance )
		return sharedInstance;

	//else

	struct CGRect rect = [ [UIScreen mainScreen ] applicationFrame ];
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
//	NSLog( @"about to transition" );
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




