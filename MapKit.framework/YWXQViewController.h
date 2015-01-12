//
//  YWXQViewController.h
//  DSBBM
//
//  Created by bisheng on 14-9-1.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobIM/BmobIM.h>

@interface YWXQViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (nonatomic,strong) BmobObject * object;

@property (nonatomic,strong) NSString * nickname;

@property (nonatomic,strong) NSString * t1;

@property (nonatomic,strong) NSString * age;

@property (nonatomic,strong) NSString * xingz;

@property (nonatomic,strong) NSString * juli;

@property (nonatomic,strong) NSString * shijian;

@property (nonatomic,strong) NSString * nairong;

@property (nonatomic,strong)    NSString * t2;

@property (nonatomic,strong) NSString * like;

@property (nonatomic,strong) NSString * comment;





@end
