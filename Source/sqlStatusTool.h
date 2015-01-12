//
//  sqlStatusTool.h
//  DSBBM
//
//  Created by morris on 14/11/19.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class friendModel;
@interface sqlStatusTool : NSObject

//存储数据
+ (void)saveModelWithDict:(friendModel *)model;
//读取数据
+ (NSMutableArray *)readFromSqlite:(NSString *)type;
//修改数据
+ (void)updatesqlWithId:(NSString *)userId status:(int)status;
//删除本地sql文件
+ (void)deleteSql;

@end
