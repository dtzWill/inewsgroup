//Will Dietz
//EditableRowCell.h
//This is a UIPreferencesTable, so I get that label/field look, but is used in a normal UITable

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

#import <Foundation/Foundation.h>
#import <UIKit/UIPreferencesTextTableCell.h>

//This protocol is to ensure the delegate implements toggleKeyboardFor
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
