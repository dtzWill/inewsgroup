//Will Dietz
//EditableRowCell.h

#import <Foundation/Foundation.h>
#import <UIKit/UIPreferencesTextTableCell.h>

@protocol KeyboardToggler

- (void) toggleKeyboardFor: (id) sender;

@end

@interface KeyboardTogglerView: NSObject <KeyboardToggler>
@end

@interface EditableRowCell: UIPreferencesTextTableCell
{

	KeyboardTogglerView * _delegate;
}

- (void) setDelegate: (id) delegate;

@end
