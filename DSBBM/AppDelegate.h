//
//  AppDelegate.h
//  DSBBM
//
//  Created by bisheng on 14-8-18.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
