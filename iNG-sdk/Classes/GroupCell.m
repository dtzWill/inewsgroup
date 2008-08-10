//
//  GroupCell.m
//  iNG
//
//  Created by William Dietz on 8/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GroupCell.h"


@implementation GroupCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// Initialization code
	}
	return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}


- (void)dealloc {
	[super dealloc];
}


@end
