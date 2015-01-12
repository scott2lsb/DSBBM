//
//  LoginViewController.h
//  DSBBM
//
//  Created by bisheng on 14-8-18.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface LoginViewController : UIViewController<UITextFieldDelegate,CLLocationManagerDelegate>


@property (nonatomic, strong) CLLocationManager  *locationManager;

@end
