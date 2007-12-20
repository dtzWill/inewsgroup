/*
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; version 2
 of the License.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

*/

#import "EditTextView.h"

@implementation EditTextView

- (void) mouseUp:(struct __GSEvent *)fp8
{
    if( ! [self isScrolling] )
    {
	if( [_delegate respondsToSelector:@selector(toggleKeyboardFor:)] )
	{
	    [_delegate toggleKeyboardFor: self];
	}
    }
    [super mouseUp:fp8];
}

- (BOOL)webView:(id)fp8 shouldInsertText:(id)text replacingDOMRange:(id)fp16 givenAction:(int)fp20
{
    if( [_delegate respondsToSelector:@selector(shouldInsertText:)] )
    {
	if( ! [_delegate shouldInsertText:text] )
	{
	    return FALSE;
	}
    }
    return [super webView:fp8 shouldInsertText:text replacingDOMRange:fp16 givenAction:fp20];
}

@end
