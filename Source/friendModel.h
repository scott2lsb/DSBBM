//
//  friendModel.h
//  DSBBM
//
//  Created by bisheng on 14-11-3.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface friendModel : NSObject

//用户头像
@property (copy)NSString *userUrl;
//用户的名字
@property (copy)NSString * userlName;
//用户的愿望
@property (copy)NSString *userLongWish;
//愿望的图片
@property (copy)NSString *wishUrl;
//用户ID
@property (copy)NSString *userId;

//更新时间。
@property (copy)NSString *UserupDateAt;
@property (copy)NSString *UserLocation;
@property(copy)NSString*wishImageViewStr ;
@property(copy)NSString *zans;
@property(copy)NSString *wishWishTextStr;
@property(copy)NSString *pingluns;
@property(copy)NSString *gengxins;

//添加的***********************************
//创建时间
@property (copy)NSString *createdDateAt;
//用户性别
@property (copy)NSString *userSex;
//朋友类别
@property (copy)NSString *type;
//朋友昵称
@property (copy) NSString *nickName;
//是否是黑名单
@property (copy)NSString *isBlack;
//status
@property (strong)NSNumber *status;


//个人资料详细
//帮帮号
@property(copy)NSString * personBbNumber;
//是不是大 V
@property(copy)NSString *personDaV;
// 年龄
@property(copy)NSString * personAge;
//星座
@property(copy)NSString * personConstellation;
//情感状态
@property(copy)NSString * personMarriage;
//学校
@property(copy)NSString * personSchool;
//家乡
@property(copy)NSString *personHometown;
//兴趣话题
@property(copy)NSString * personTopic;
//梦想职业
@property(copy)NSString * personCareer;
//愿望宣言
@property(copy)NSString * personWishDeclaration;
//梦想宣言
@property(copy)NSString * personDreamDeclaration;
//相册
@property(copy)NSArray *photoArray;



@end
