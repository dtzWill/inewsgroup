//Will Dietz
//EditableRowCell.m

#import "EditableRowCell.h"

@implementation EditableRowCell

- (id) init
{
	[super init];

	NSLog( @"init" );
}
	
- (void)_textFieldEndEditing:(id)fp8 	// IMP=0x3244e26c
{
	NSLog( @"textFieldEndEditing" );
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
	NSLog( @"textFieldStartEditing" );
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


