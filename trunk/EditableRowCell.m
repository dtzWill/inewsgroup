//Will Dietz
//EditableRowCell.m
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

#import "EditableRowCell.h"

@implementation EditableRowCell

- (id) init
{
	[super init];

	return self;
}
	
- (void)_textFieldEndEditing:(id)fp8 	// IMP=0x3244e26c
{
//	NSLog( @"textFieldEndEditing" );
	[super _textFieldEndEditing: fp8 ];

	if( [_delegate respondsToSelector:@selector(toggleKeyboardFor:)] )
	{
	    [_delegate toggleKeyboardFor: self];
	}


}
- (void)_textFieldEndEditingOnReturn:(id)fp8	// IMP=0x3244e3ec
{
//	NSLog( @"textFieldEndEditingOnReturn" );
	[super _textFieldEndEditingOnReturn: fp8 ];

}
- (void)_textFieldStartEditing:(id)fp8	// IMP=0x3244e1fc
{
//	NSLog( @"textFieldStartEditing" );
	[super _textFieldStartEditing: fp8];
	
	if( [_delegate respondsToSelector:@selector(toggleKeyboardFor:)] )
	{
	    [_delegate toggleKeyboardFor: self];
	}

}

- (void) setDelegate: (id) delegate
{
	_delegate = delegate;
}




@end


