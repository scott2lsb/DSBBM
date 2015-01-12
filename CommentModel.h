//
//  PLModel.h
//  DSBBM
//
//  Created by bisheng on 14-9-2.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic,strong) NSString * context;

@property (nonatomic,strong) NSString * name;

@property (nonatomic,strong) NSString * url;

@property (nonatomic,strong) NSString * userId;

@property (nonatomic,strong) NSDate * createTime;

@property (nonatomic,strong) NSString * commentId;

@property (nonatomic,strong) NSString * installId;

@property (nonatomic,strong) NSString * deviceType;

@end
