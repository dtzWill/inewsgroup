//
//  AccountView.m
//  iNG
//
//  Created by William Dietz on 4/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AccountView.h"

#import "NNTPAccount.h"

@implementation AccountView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code here.
		self.backgroundColor = [ UIColor whiteColor ];

		_delegate = nil;

		[ self createSubviews ];
		[ self resizeSubviewsWithFrame: frame ];
		[ self setSubviewsText ];

		//addSubviews...
		[ self addSubview: _iNG_label ];
		[ self addSubview: _author_label ];
		[ self addSubview: _version_label ];
		[ self addSubview: _account_label ];
		[ self addSubview: _server_label ];
		[ self addSubview: _connect ];
		[ self addSubview: _offline ];
		
		[ self setNeedsLayout ];//we're overriding layoutSubviews
    }
    return self;
}

- (void) createSubviews
{
	_iNG_label = [ [ UILabel alloc ] init ];
	_iNG_label.textAlignment = UITextAlignmentCenter;

	_author_label = [ [ UILabel alloc ] init ];
	_author_label.textAlignment = UITextAlignmentCenter;

	_version_label = [ [ UILabel alloc ] init ];
	_version_label.textAlignment = UITextAlignmentCenter;

	_account_label = [ [ UILabel alloc ] init ];
	_account_label.textAlignment = UITextAlignmentCenter;

	_server_label = [ [ UILabel alloc ] init ];
	_server_label.textAlignment = UITextAlignmentCenter;

	_connect = [ UIButton buttonWithType: UIButtonTypeRoundedRect ];
	[ _connect addTarget: self action: @selector(connectPressed) forControlEvents: UIControlEventTouchDown ];

	_offline = [ UIButton buttonWithType: UIButtonTypeRoundedRect ]; 
	[ _offline addTarget: self action: @selector(offlinePressed) forControlEvents: UIControlEventTouchDown ];

	_offline.enabled = NO;//we don't support this yet!
}
- (void) resizeSubviewsWithFrame: (CGRect) frame
{
	CGRect labelFrame = frame;
	labelFrame.size.height = 30;

	labelFrame.origin.y = 40;
	[ _iNG_label setFrame: labelFrame ];

	labelFrame.origin.y=70;
	[ _author_label setFrame: labelFrame ];

	labelFrame.origin.y= 100;
	[ _version_label setFrame: labelFrame ];

	labelFrame.origin.y = 160;
	[ _account_label setFrame: labelFrame ];

	labelFrame.origin.y = 190;
	[ _server_label setFrame: labelFrame ];

	CGRect buttonFrame;
	buttonFrame.size.width = frame.size.width/3;
	buttonFrame.size.height = 40;
	buttonFrame.origin.y = 300;

	buttonFrame.origin.x = frame.size.width/9;
	[ _offline setFrame: buttonFrame ];

	buttonFrame.origin.x = frame.size.width*5/9;
	[ _connect setFrame: buttonFrame ];

}

- (void)setSubviewsText
{
	//TODO: make these strings global and preferrably localizable

	[ _iNG_label setText: @"iNewsGroup" ]; 
	_iNG_label.font = [ _iNG_label.font fontWithSize: 30 ];
	[ _author_label setText: @"Will Dietz" ];
	[ _version_label setText: @"0.0.1" ];
	[ _account_label setText: @"Active Account:" ];
	_account_label.font = [ _account_label.font fontWithSize: 24 ];
	if ( [ [ NNTPAccount sharedInstance ] isValid ] )
	{
		[ _server_label setText: [ [ NNTPAccount sharedInstance ] getServer ] ];
		_server_label.textColor = [ UIColor greenColor ];
	}
	else
	{
		[ _server_label setText: @"Set Server in Settings.app!" ];
		_server_label.textColor = [ UIColor redColor ];
	}

	[ _offline setTitle: @"Offline" forStates: UIControlStateNormal ];

	[ _connect setTitle: @"Connect" forStates: UIControlStateNormal ];
}

- (void)layoutSubviews
{
	[ self resizeSubviewsWithFrame: [ self bounds ] ];
	[ super layoutSubviews ];	
}

- (void) setDelegate: (id) delegate
{
	_delegate = delegate;
}

- (void)dealloc
{
	[ _iNG_label release ];
	[ _author_label release ];
	[ _version_label release ];
	[ _account_label release ];
	[ _server_label release ];
	[ _connect release ];
	[ _offline release ];
	
	[super dealloc];

}


/*-----------------------------------------------------------------------------
 *  Callbacks--forward it to delegate specified in 'setDelegate' (if the delegate responds to the desired selector) 
 *-----------------------------------------------------------------------------*/


- (void) connectPressed
{
	if ( _delegate )
	{
		if ( [ _delegate respondsToSelector: @selector(connectPressed) ] )
		{
			[ _delegate connectPressed ];
		}
	}
}

- (void) offlinePressed
{
	if ( _delegate )
	{
		if ( [ _delegate respondsToSelector: @selector(offlinePressed) ] )
		{
			[ _delegate offlinePressed ];
		}
	}
}
@end
