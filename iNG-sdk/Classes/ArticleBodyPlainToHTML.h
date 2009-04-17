//
//  ArticleBodyPlainToHTML.h
//  iNG
//
//  Created by Will Dietz on 16/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ArticleBodyPlainToHTML : NSObject {

}

+ (NSString *) convert: (NSString *) plainBody useFlowed: (BOOL) flow;
@end
