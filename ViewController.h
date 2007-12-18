//Will Dietz
//ViewController.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ViewController: UITransitionView
{
	UIView * _curView;//keeps track of current view, so we /can/ go back :)
	UIView * _prevView;//keeps track of view /before/ this one so we can return to it
	bool _prevDir;


}

+ (ViewController *) sharedInstance; //singleton

//transition to the specified view, in the specified direction
- (void) setView: (UIView *) view slideFromLeft: (bool) left;


//used by apps to figure out where they were called from, and what direction
//so we can return appropriately
- (UIView *) getPrevView;

- (bool) getPrevDir;


//used just once to tell us what our /first/ view is, since we don't use
//the setView method the first time 'round
- (void) setCurView: (UIView *) view;

@end
