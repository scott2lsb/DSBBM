//
//  YWModel.h
//  DSBBM
//
//  Created by bisheng on 14-8-27.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WishModel : NSObject

@property(nonatomic,strong) NSString * avatar;

@property(nonatomic,strong) NSString * image;

@property(nonatomic,strong) NSString * name;

@property(nonatomic,strong) NSString * type;

@property(nonatomic,strong) NSString * age;

@property(nonatomic,strong) NSString * context;

@property(nonatomic,strong) NSNumber * like;

@property(nonatomic,strong) NSNumber * comment;

@property(nonatomic,strong) NSString * distance;

@property(nonatomic,strong) NSString * attime;

@property(nonatomic,strong) NSString * deviceType;

@property(nonatomic,strong) NSString * installId;

@property(nonatomic,strong) NSString * recommend;

@property(nonatomic,strong) BmobObject * obj;

@property(nonatomic,strong) NSDictionary * objDict;

@property(nonatomic,strong) BmobChatUser * charid;

@end
