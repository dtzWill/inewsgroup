//Will Dietz
//ComposeView.h
//Compose a message, and send it

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
#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import <UIKit/UITextField.h>
#import "EditTextView.h"
#import "EditorKeyboard.h"
#import "EditableRowCell.h" 

@interface ComposeView: UIView <KeyboardToggler>
{

	/*All messages need the following:
	
		-From --NOT editable
		-Newsgroup(s) to post to (for now, just one)
		-Subject
		-Message content
	*/

	//these represent the group we're posting to, and the post we're replying to (if applicable) 
	int _postnum, _groupnum;

	//rects representing the 'small' and the 'big' modes for the message content
	CGRect _rectSmall;
	CGRect _rectBig;

	//state data
	bool _keyboardShown;
	bool _editingMessage;
	bool _keyboardTransitioning;

	//UI elements
	EditTextView * _textView;
	UINavigationBar * _nav;
	EditorKeyboard * _keyboard;
    NSMutableArray * _rows;
    UINavigationItem * _titleItem;
    UITable * _table;
	UIAlertSheet * _sending, * _result; 

	//message-specific
	NSString * _subject;
	NSString * _newsgroup;
	NSString * _references;
	

}

+ (ComposeView *)sharedInstance;

- (id) initWithFrame: (CGRect) rect;

//initialize a new message.  Call this every time you want to re-initialize the view for a new message.
- (void) startNewMessage: (NSDictionary *) items;

//for internal use, it clears out/releases old memory
- (void) emptyOldMessage;

//used to handle the sliding keyboard, etc:
- (void) toggleKeyboardFor: (id) sender;
- (void) keyboardTransitionOver;

@end

