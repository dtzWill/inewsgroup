//Will Dietz
//MessageController.m

#import "MessageController.h"

static id sharedInstance = 0;

@implementation MessageController

+ (id) sharedInstance
{
	if ( !sharedInstance )
		sharedInstance = [ [MessageController alloc] init ];
	return sharedInstance;	

}

- (id) init
{
	[super init];
	valid = false;
	return self;
}

- (void) setAlertText: (NSString *) text
{
		[ self performSelectorOnMainThread: @selector(setAlertTextSel:) withObject: text waitUntilDone: YES ];

}


- (void) setAlertTextSel: (NSString *) text
{
		 
	NSLog( @"Setting text to: %@, valid: %d", text, valid );
	if ( valid )
	{
/*		[ _alert setTitle: text ];
		[ _alert setBodyText: text ];
		[ _view setNeedsDisplay ];
		[ _alert setNeedsDisplay ];
		NSLog( @"alert: %d", [ _alert needsDisplay ]);
		[ _view setTitle: title ];
		[ _alert performSelectorOnMainThread: @selector(forceDisplayIfNeeded) withObject: text waitUntilDone: YES ];
		NSLog( @"alert: %d", [ _alert needsDisplay ]);
	//	[ _view->_titleItem setTitle: @"Testing!!!" ];
		[ _alert recursivelyForceDisplayIfNeeded ];
		[ _view recursivelyForceDisplayIfNeeded ];
		NSLog( @"text set?");
*/

		//TODO: coolness!

//		[ _alert drawRect: [ _alert titleRect ] ];
//		[ _alert dismiss ];
//		[ _alert recursivelyForceDisplayIfNeeded ];
//		sleep( 2 );
//		[ _alert presentSheetInView: _view ];
//		[ _alert recursivelyForceDisplayIfNeeded ];
//		sleep(1);	
//		[ _alert setBodyText: text ];
//		NSLog([ _alert buttons] );
//		[ _alert layout ];
	}
}

- (void) setSheet: (UIAlertSheet * ) alert withView:(UIView *) view;
{
	//TODO: close old one if still valid..  maybe?
	_alert = alert;
	_view = view;
	valid = true;
}

- (void) sheetClosed
{
	valid = false;
}

@end
