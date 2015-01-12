//
//  AppDelegate.m
//  DSBBM
//
//  Created by bisheng on 14-8-18.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "AppDelegate.h"
#import "WishViewController.h"
#import "LoginViewController.h"
#import "TransitViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "chatData.h"
#import "synFriends.h"
#import "MobClick.h"
#import "sqlStatusTool.h"


@implementation AppDelegate
{
    MBProgressHUD * HUD;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    HUD = [[MBProgressHUD alloc] initWithFrame: CGRectMake(0, 0, 320, 320)];
    HUD.labelText = @"登录中";
    [self.window addSubview:HUD];
    [HUD show:YES];

    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] integerValue] == 1){
        CLLocationManager  *locationManager = [[CLLocationManager alloc]init];
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        
        [locationManager startUpdatingLocation];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 1000.0f;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [locationManager requestAlwaysAuthorization];
            [locationManager requestWhenInUseAuthorization];
        }
        NSMutableArray * array = [NSMutableArray array];
        [array addObject:[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude]];
        [array addObject:[NSString stringWithFormat:@"%f",locationManager.location.coordinate.latitude]];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"location"];
        
        [BmobUser logInWithUsernameInBackground:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] password:[[NSUserDefaults standardUserDefaults] objectForKey:@"pass"] block:^(BmobUser *user, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
                DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
                
                REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
                frostedViewController.direction = REFrostedViewControllerDirectionLeft;
                frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
                self.window.rootViewController = frostedViewController;
                [HUD removeFromSuperview];
            }else{
                if([[user objectForKey:@"blockade"] integerValue] == 1){
                    DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
                    DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
                    
                    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
                    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
                    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
                    self.window.rootViewController = frostedViewController;
                    [HUD removeFromSuperview];
                    return ;
                }
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isLogin"];
                NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"location"];
                 NSDate * date = [[NSUserDefaults standardUserDefaults] objectForKey:@"grabStarTime"];
                if(date == nil){
                }else{
                    NSDate * nowDate = [NSDate date];
                    if([[[NSString stringWithFormat:@"%@",date] substringWithRange:NSMakeRange(0, 10)] isEqualToString:[[NSString stringWithFormat:@"%@",nowDate] substringWithRange:NSMakeRange(0, 10)]]){
                    }else{
                        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"grabStarTime"];
                    }
                }
                BmobGeoPoint *location = [[BmobGeoPoint alloc] initWithLongitude:[array[0] floatValue] WithLatitude:[(id)array[1] floatValue]];
                NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
                NSString * qwe =[formatter stringFromDate:[NSDate date]];
                [user setObject:qwe forKey:@"localtime"];
                [user setObject:location forKey:@"location"];
                [user setObject:[NSNumber numberWithInt:1] forKey:@"online"];
                //更新定位
                [user updateInBackground];
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"selfDeviceToken"]) {
                    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"selfDeviceToken"];
                    [[BmobUserManager currentUserManager] checkAndBindDeviceToken:data];
                }
                [synFriends synchFriend];
                //每次进去后，将上一次从网上去下的数据中最后一条作为时间戳，若是，接受到新的信息，以新的信息为准
                NSString *lastTime = [chatData readChatMessageTimeAndSaveTime];
                [chatData getMessageWhenReceivePush:lastTime successful:^(BOOL successful, NSDictionary *dict) {
                }];
                DEMONavigationController * navigationController;
                BmobUser * bUser = [BmobUser getCurrentObject];
                NSLog(@"%@",[NSString stringWithFormat:@"%@",[bUser objectForKey:@"lastWish"]]);
                 if([[NSString stringWithFormat:@"%@",[bUser objectForKey:@"lastWish"]]isEqualToString:@"(null)"]){
                     navigationController = [[DEMONavigationController alloc] initWithRootViewController:[[TransitViewController alloc] init]];
                 }else{
                  navigationController = [[DEMONavigationController alloc] initWithRootViewController:[[WishViewController alloc] init]];

                 }
                DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
                REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
                frostedViewController.direction = REFrostedViewControllerDirectionLeft;
                frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
                self.window.rootViewController = frostedViewController;
                [HUD removeFromSuperview];
            }
            
        }];

    }else{
          DEMONavigationController * navigationController = [[DEMONavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
            DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
            
            REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
            frostedViewController.direction = REFrostedViewControllerDirectionLeft;
            frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
            self.window.rootViewController = frostedViewController;
            [HUD removeFromSuperview];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
        //这里还是原来的代码
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
   
    
    BmobUser *user = [BmobUser getCurrentUser];
    if (user) {
        BmobDB *db = [BmobDB currentDatabase];
        [db createDataBase];
    }else{
        
    }
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithAppkey:@"549bda7bfd98c5cda9000bff"];
    [WXApi registerApp:@"wx780752761f747ff8"];
    [SMS_SDK registerApp:@"3e4b89200c1b" withSecret:@"9a744b391c75fe582c433a6de9ec9d7f"];
    [self.window makeKeyAndVisible];
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
      return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}




- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
   
    [BmobChat regisetDeviceWithDeviceToken:deviceToken];
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"selfDeviceToken"];
  
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error in registration. Error: %@", error);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [BmobUser logout];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isLogin"];
    [[BmobDB currentDatabase] clearAllDBCache];
    [sqlStatusTool deleteSql];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"nick"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"avatar"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"pass"];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sound"];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"vibrate"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"grabStar"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"grabStarTime"];
    DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    self.window.rootViewController = frostedViewController;
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if ([[userInfo objectForKey:@"tag"] isEqualToString:@"offline"]){
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"您的账号在其他地点登陆" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 10;
        [alert show];
    }
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"sound"] integerValue] == 1){
        static SystemSoundID soundIDTest = 0;
        NSString * path = [[NSBundle mainBundle] pathForResource:@"notify" ofType:@"mp3"];
        if (path) {
            AudioServicesCreateSystemSoundID( (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:path]), &soundIDTest );
        }
        AudioServicesPlaySystemSound( soundIDTest );
    }
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"vibrate"] integerValue] == 1){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    if ([userInfo objectForKey:@"tag"]) {
        if ([[[userInfo objectForKey:@"tag"] description] isEqualToString:@""]) {
//            [self saveMessageWith:userInfo];
            //获取到数据库中最后一条数据的信息
            NSLog(@"%@",[userInfo objectForKey:@"fId"]);
            if([[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@first",[userInfo objectForKey:@"fId"]]] integerValue] == 2){
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"%@first",[userInfo objectForKey:@"fId"]]];
            }
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1 + [[[NSUserDefaults standardUserDefaults] objectForKey:[userInfo objectForKey:@"fId"]] integerValue]] forKey:[userInfo objectForKey:@"fId"]];
            NSNotification * center = [[NSNotification alloc] initWithName:@"news" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:center];
            NSString *lastTime = [chatData readChatMessageTimeAndSaveTime];
            [chatData getMessageWhenReceivePush:lastTime successful:^(BOOL successful, NSDictionary *dict) {
                if (successful) {
                    NSLog(@"111推送消息111");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidRecieveUserMessage" object:dict];
                }
            }];
        }else if ([[userInfo objectForKey:@"tag"] isEqualToString:@"addLike"] || [[userInfo objectForKey:@"tag"] isEqualToString:@"addComment"]){

            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + 1] forKey:@"addLike"];
            NSNotification * center = [[NSNotification alloc] initWithName:@"news" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:center];
            
        }else if ([[userInfo objectForKey:@"tag"] isEqualToString:@"aladdinShake"] || [[userInfo objectForKey:@"tag"] isEqualToString:@"aladdinSnatch"]){

            [self saveAlading:userInfo];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinSnatch"] integerValue] + 1] forKey:@"aladdinSnatch"];
            NSNotification * center = [[NSNotification alloc] initWithName:@"news" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:center];
        }else if ([[userInfo objectForKey:@"tag"] isEqualToString:@"visit"]){
           
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"visit"];
            NSNotification * center = [[NSNotification alloc] initWithName:@"news" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:center];
        }
    }

}



-(void)saveAlading:(NSDictionary *)userInfo{
    
    BmobQuery * query = [BmobQuery queryForUser];
    [query getObjectInBackgroundWithId:[userInfo objectForKey:@"fId"] block:^(BmobObject *object, NSError *error) {
        NSArray * oldArray =[[NSUserDefaults standardUserDefaults] objectForKey:@"alading"];
        NSMutableArray * array = [[NSMutableArray alloc] initWithArray:oldArray];
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:[object objectForKey:@"nick"] forKey:@"nick"];
        [dict setObject:[object objectForKey:@"avatar"] forKey:@"avatar"];
        [dict setObject:[object objectId] forKey:@"objectId"];
        [dict setObject:[NSDate date] forKey:@"atTime"];
        [array insertObject:dict atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"alading"];
        NSNotification * center = [[NSNotification alloc] initWithName:@"news" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:center];
    }];

}



#pragma mark save


- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"illResignActive");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"DidEnterBackground");
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"exittime"];
    BmobUser *bUser = [BmobUser getCurrentUser];
    [bUser setObject:[NSNumber numberWithInt:0] forKey:@"online"];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString * qwe =[formatter stringFromDate:[NSDate date]];
    [bUser setObject:qwe forKey:@"exittime"];
    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
      
    }];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"WillEnterForeground");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    BmobUser * user = [BmobUser getCurrentObject];
    NSLog(@"plicationDidBecomeActive:");
//    BmobUser *bUser = [BmobUser getCurrentUser];
    [user setObject:[NSNumber numberWithInt:1] forKey:@"online"];
    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
    }];
    if(user.objectId != nil){
        BmobQuery * query = [BmobQuery queryWithClassName:@"WishMsg"];
        [query whereKey:@"toUser" equalTo:user.objectId];
        [query whereKey:@"updatedAt" greaterThan:[[NSUserDefaults standardUserDefaults] objectForKey:@"exittime"]];
        [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if(!error){
                if(number != 0){
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + number] forKey:@"addLike"];
                    NSNotification * center = [[NSNotification alloc] initWithName:@"news" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:center];
                }
            }
        }];
        BmobQuery *  queryVisitor = [BmobQuery queryWithClassName:@"RecentVisitor"];
        [queryVisitor whereKey:@"respondents" equalTo:user.objectId];
        [queryVisitor whereKey:@"updatedAt" greaterThan:[[NSUserDefaults standardUserDefaults] objectForKey:@"exittime"]];
        [queryVisitor countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if(!error){
                if(number != 0){
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"visit"];
                    NSNotification * center = [[NSNotification alloc] initWithName:@"news" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:center];
                }
            }
        }];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"exittime"];
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"licationWillTerminat");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
