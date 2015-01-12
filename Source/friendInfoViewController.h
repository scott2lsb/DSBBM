//
//  friendInfoViewController.h
//  DSBBM
//
//  Created by morris on 14/11/21.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"friendModel.h"
#import "EditDataViewController.h"

@protocol cancelFriendDelegate <NSObject>

@optional
- (void)cancelFriend:(int)time;

@end

@interface friendInfoViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate>



@property (nonatomic,copy) NSString * userId;

@property (nonatomic,copy) NSString * userName;



@property (nonatomic, strong)NSArray *allFollows;

@property int furcation;

@property (nonatomic, weak)id<cancelFriendDelegate> delegete;

@end
