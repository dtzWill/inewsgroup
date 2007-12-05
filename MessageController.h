//Will Dietz
//MessageController.h

//Used to change the message currently being displayed

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MessageController: NSObject
{
	bool valid;
	UIAlertSheet * _alert;
	UIView * _view;
}

+ (id)	sharedInstance;

- (id) init;

- (void) setAlertText: (NSString *) text;//set text
- (void) setAlertTextSel: (NSString *) text;//set text

- (void) setSheet: (UIAlertSheet *) alert withView: (UIView *) view;//assigns sheet and marks valid

- (void) sheetClosed;//mark invalid

@end

