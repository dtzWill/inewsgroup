//Will Dietz
//EditTextView.m
//Editable UITextView, used in ComposeView

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

#import "EditTextView.h"

@implementation EditTextView

- (void) mouseUp:(struct __GSEvent *)fp8
{
	if( ! [self isScrolling] )
	{
		if( [_delegate respondsToSelector:@selector(toggleKeyboardFor:)] )
		{
			[_delegate performSelector: @selector(toggleKeyboardFor:) withObject: self];
		}
	}
	[super mouseUp:fp8];
}

- (BOOL)webView:(id)fp8 shouldInsertText:(id)text replacingDOMRange:(id)fp16 givenAction:(int)fp20
{
	if( [_delegate respondsToSelector:@selector(shouldInsertText:)] )
	{
		if( ! [_delegate performSelector: @selector(shouldInsertText:) withObject: text] )
		{
			return FALSE;
		}
	}
	return [super webView:fp8 shouldInsertText:text replacingDOMRange:fp16 givenAction:fp20];
}

@end
