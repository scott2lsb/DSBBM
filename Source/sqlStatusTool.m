//
//  sqlStatusTool.m
//  DSBBM
//
//  Created by morris on 14/11/19.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "sqlStatusTool.h"
#import "friendModel.h"
#import "FMDB.h"

@implementation sqlStatusTool


static FMDatabase *_db;
+ (void)initialize
{
    // 0.获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *sqlFilePath = [path stringByAppendingPathComponent:@"friends.sqlite"];
    
    NSLog(@"path = %@", path);
    
    // 1.加载数据库
    _db = [FMDatabase databaseWithPath:sqlFilePath];
    
    // 2.打开数据库
    if ([_db open]) {
        NSLog(@"打开数据库成功");
        
        // 3.创建表
        BOOL success = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS friends(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, username TEXT, nick TEXT, avatar TEXT, birthday TEXT, isblack text, sex text,uid TEXT,  friendstype INT, status INT, objectId TEXT, createdAt TEXT, updatedAt TEXT);"];
        
        if (success) {
            NSLog(@" 创建表成功");
        }else
        {
            NSLog(@" 创建表失败");
        }
    }else
    {
        NSLog(@"打开数据库失败");
    }
    
    
}


//数据存储
+ (void)saveModelWithDict:(friendModel *)model
{
     [_db executeUpdate:@"INSERT INTO friends (username, nick, avatar, birthday, isblack, sex, uid, friendstype, createdAt, updatedAt) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", model.userlName, model.nickName, model.userUrl ,model.personAge, model.isBlack, model.userSex, model.userId, model.type, model.createdDateAt, model.UserupDateAt, model.type];
    
}


+ (NSMutableArray *)readFromSqlite:(NSString *)type
{
    FMResultSet *set = nil;
    
    set = [_db executeQuery:@"SELECT * FROM friends WHERE friendstype = ?", type];
    
    NSMutableArray *array = [NSMutableArray array];
    
    while ([set next]) { // next方法返回yes代表有数据可取
        friendModel *friend = [[friendModel alloc]init];
        
        //取出数据放入模型中
        friend.userlName = [set stringForColumn:@"username"];
        friend.nickName = [set stringForColumn:@"nick"]; // 根据字段名称取出对应的值
        friend.userUrl = [set stringForColumn:@"avatar"];
        friend.personAge = [set stringForColumn:@"birthday"];
        friend.isBlack = [set stringForColumn:@"isblack"];
        friend.userSex = [set stringForColumn:@"sex"];
        friend.userId = [set stringForColumn:@"uid"];
        friend.createdDateAt = [set stringForColumn:@"createdAt"];
        friend.UserupDateAt = [set stringForColumn:@"updatedAt"];

        friend.type = type;
        [array addObject:friend];
        
    }
    
    // 返回模型
    return array;
}

+ (void)updatesqlWithId:(NSString *)userId status:(int)status
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_student SET status = %d WHERE uid = '%@';", status,userId];
    [_db executeUpdate:sql];
}

+ (void)deleteSql
{
    [_db executeUpdate:@"DELETE FROM friends;"];
    // 0.获取沙盒地址。。以下，删除sql文件
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//    NSString *sqlFilePath = [path stringByAppendingPathComponent:@"friends.sqlite"];
//    
//    
//    NSFileManager *fileMgr = [NSFileManager defaultManager];
//    NSError *err;
//    [fileMgr removeItemAtPath:sqlFilePath error:&err];
    
}




@end
