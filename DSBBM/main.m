
//
//  main.m
//  DSBBM
//
//  Created by bisheng on 14-8-18.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    [Bmob registerWithAppKey:@"d5b5cb77291196ef78c6c1d06e19d415"];
    @autoreleasepool {
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
