//
//  main.m
//  iNG
//
//  Created by Will Dietz on 3/16/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"iNGAppDelegate");
    [pool release];
    return retVal;
}
