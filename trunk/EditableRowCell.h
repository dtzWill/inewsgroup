//Will Dietz
//EditableRowCell.h

#import <UIKit/UIPreferencesTextTableCell.h>

@interface EditableRowCell: UIPreferencesTextTableCell
{

	id _delegate;
}

- (void) setDeleate: (id) delegate;

@end
