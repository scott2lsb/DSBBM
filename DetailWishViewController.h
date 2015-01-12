//
//  YWXQViewController.h
//  DSBBM
//
//  Created by bisheng on 14-9-1.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "smileView.h"

@interface DetailWishViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate,TQRichTextViewDelegate,smileViewDelegate>

@property (nonatomic,strong) NSString * objectId;

@property (nonatomic,strong) NSString * chatId;

@property (nonatomic,strong) BmobObject * chatid;

@property (nonatomic,strong) NSString * nickname;

@property (nonatomic,strong) NSString * avatar;

@property (nonatomic,strong) NSString * age;

@property (nonatomic,strong) NSString * sex;

@property (nonatomic,strong) NSString * distance;

@property (nonatomic,strong) NSString * attime;

@property (nonatomic,strong) NSString * context;

@property (nonatomic,strong) NSString * image;

@property (nonatomic,strong) NSString * like;

@property (nonatomic,strong) NSString * comment;

@property (nonatomic,strong) NSString * installId;

@property (nonatomic,strong) NSString * deviceType;

@property (nonatomic,strong) NSDate * timeDate;

@property (nonatomic, strong) NSDictionary *SmileDict;

@property int number;

@end
