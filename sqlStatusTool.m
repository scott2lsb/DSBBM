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
    BmobUser *bUser = [BmobUser getCurrentUser];
    // 0.获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *name = [NSString stringWithFormat:@"%@_friends.db", [bUser objectForKey:@"username"] ];
    NSString *sqlFilePath = [path stringByAppendingPathComponent:name];
    
    NSLog(@"path = %@", path);
    
    // 1.加载数据库
    _db = [FMDatabase databaseWithPath:sqlFilePath];
    
    // 2.打开数据库
    if ([_db open]) {
        NSLog(@"打开数据库成功");
        
        // 3.创建表
        //latitude = "40.098497";
        //longitude = "116.348862";
        BOOL success = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS friends(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, username TEXT, nick TEXT, avatar TEXT, birthday TEXT, isblack text, sex text,uid TEXT,  friendstype text, status TEXT, objectId TEXT, createdAt TEXT, updatedAt TEXT, latitude TEXT, longitude TEXT);"];
        [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS chatMessages(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, fromId TEXT, toId TEXT, conversationId TEXT,messageContent TEXT, belongNick text, messageType TEXT, msgTime text);"];
        [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS blackList(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, username TEXT, nick TEXT, avatar TEXT, birthday TEXT, isblack text, sex text,uid TEXT,  friendstype text, status TEXT, objectId TEXT, createdAt TEXT, updatedAt TEXT, latitude TEXT, longitude TEXT);"];
        
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
//****************************************************************
+ (void)saveChatMeaagaeWith:(NSArray *)array
{
    for (BmobObject *obj in array) {
        NSString *fromId         = [obj objectForKey:@"belongId"];
        NSString *toId           = [obj objectForKey:@"toId"];
        NSString *conversationId = [obj objectForKey:@"conversationId"];
        NSString *nick           = [obj objectForKey:@"belongNick"];
        NSString *messageType    = [obj objectForKey:@"msgType"];
        NSString *msgTime        = [obj objectForKey:@"msgTime"];
        NSString *content        = [obj objectForKey:@"content"];
        NSLog(@"fromId = %@, toid = %@, conversationId = %@, belongNick = %@, msgType = %@, msgTime = %@, content = %@, ", fromId,toId,conversationId,nick,messageType,msgTime, content);
        
        [_db executeUpdate:@"INSERT INTO chatMessages(fromId, toId, conversationId, messageContent, belongNick, messageType, msgTime) VALUES ( ?, ?, ?, ?, ?, ?, ?)", fromId, toId, conversationId, content, nick,messageType,msgTime];
    }

}

+ (NSMutableDictionary *)getLastMessageTime
{
    FMResultSet *set = nil;
    set = [_db executeQuery:@"SELECT * FROM chatMessages WHERE msgTime = (SELECT max(msgTime) FROM chatMessages); "];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    while ([set next]) {
        dict[@"msgTime"] = [set stringForColumn:@"msgTime"];
    }
    BOOL isNull = [self isBlankString:dict[@"msgTime"]];
    if (!isNull) {
        dict[@"msgTime"] = @"0";
    }
    NSLog(@"dict0 = %@", dict);
    return dict;
}

//****************************************************************
//黑名单
+ (void)saveBlackListWithDict:(friendModel *)model
{
    [_db executeUpdate:@"INSERT INTO blackList (username, nick, avatar, birthday, isblack, sex, uid, friendstype, status, createdAt, updatedAt, latitude, longitude) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", model.userlName, model.nickName, model.userUrl ,model.personAge, model.isBlack, model.userSex, model.userId, model.type, model.status,model.createdDateAt, model.UserupDateAt, model.latitude, model.longitude];
}

+ (int)selectBlackWithId:(NSString *)uid
{
    FMResultSet *set = nil;
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT count(*) FROM blackList WHERE uid = '%@';", uid];
    set = [_db executeQuery:sqlStr];
    //    int count = [set intForColumnIndex:0];
    int count = 0;
    while ([set next]) { // next方法返回yes代表有数据可取
        count = [set intForColumnIndex:0];
        NSLog(@"intForColumnIndex %d",[set intForColumnIndex:0]);
    }
    
    NSLog(@"dd = %d", count);
    return count;

}

+ (void)selectBlackList
{
    FMResultSet *set = nil;
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM blackList ;"];
    set = [_db executeQuery:sqlStr];
    //    int count = [set intForColumnIndex:0];
    while ([set next]) { // next方法返回yes代表有数据可取
        NSString *nick =  [set stringForColumn:@"nick"];
        NSString *uid =  [set stringForColumn:@"uid"];
        NSLog(@"black_usernick =  %@, id = %@", nick, uid);
    }
    
}

+ (void)deleteBlack:(NSString *)uid
{
    
    [_db executeUpdate:@"DELETE FROM blackList WHERE uid = ?", uid];

}

//****************************************************************

//数据存储
+ (void)saveModelWithDict:(friendModel *)model
{
     [_db executeUpdate:@"INSERT INTO friends (username, nick, avatar, birthday, isblack, sex, uid, friendstype, status, createdAt, updatedAt, latitude, longitude) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", model.userlName, model.nickName, model.userUrl ,model.personAge, model.isBlack, model.userSex, model.userId, model.type, model.status,model.createdDateAt, model.UserupDateAt, model.latitude, model.longitude];
    
}


+ (NSMutableArray *)readFromSqliteWithType:(NSString *)type
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
        friend.status = [set stringForColumn:@"status"];
        friend.type = type;
        friend.latitude = [set stringForColumn:@"latitude"];
        friend.longitude = [set stringForColumn:@"longitude"];
        [array addObject:friend];
        
    }
    
    // 返回模型
    return array;
}

//修改朋友状态
+ (void)updatesqlWithId:(NSString *)userId status:(NSString *)status
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE friends SET status = '%@' WHERE uid = '%@';", status,userId];
    [_db executeUpdate:sql];
}

//修改朋友类型
+ (void)updatesqlWithId:(NSString *)userId friendsType:(NSString *)friendstype
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE friends SET friendstype = '%@' WHERE uid = '%@';", friendstype,userId];
    [_db executeUpdate:sql];
}
//修改朋友状态
+ (void)updatesqlWithId:(NSString *)userId row:(NSString *)row dataStr:(NSString *)dataStr
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE friends SET %@ = '%@' WHERE uid = '%@';",row, dataStr,userId];
    [_db executeUpdate:sql];
}

/***/
+ (int)numOfSql
{
    FMResultSet *set = nil;
    
    set = [_db executeQuery:@"SELECT count(*) FROM friends;"];
    
//    int count = [set intForColumnIndex:0];
    int count = 0;
    while ([set next]) { // next方法返回yes代表有数据可取
        count = [set intForColumnIndex:0];
        NSLog(@"intForColumnIndex %d",[set intForColumnIndex:0]);
    }
    
    NSLog(@"dd = %d", count);
    return count;
    
}

/**查询sql中某条id等于uid的数据是否存在*/
+ (int)selectFriendIsThereWithUid:(NSString *)uid
{
    FMResultSet *set = nil;
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT count(*) FROM friends WHERE uid = '%@';", uid];
    set = [_db executeQuery:sqlStr];
    //    int count = [set intForColumnIndex:0];
    int count = 0;
    while ([set next]) { // next方法返回yes代表有数据可取
        count = [set intForColumnIndex:0];
        NSLog(@"intForColumnIndex %d",[set intForColumnIndex:0]);
    }
    
    NSLog(@"dd = %d", count);
    return count;
}

/**查询sql中某条数据的status*/
+ (NSString *)selectFriendStatusWithUid:(NSString *)uid
{
    FMResultSet *set = nil;
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT status FROM friends WHERE uid = '%@';", uid];
    set = [_db executeQuery:sqlStr];
    //    int count = [set intForColumnIndex:0];
    NSString *name;
    while ([set next]) { // next方法返回yes代表有数据可取
        name = [set stringForColumnIndex:0];
    }
    
    NSLog(@"status = %@", name);
    return name;
}

/*查询sql中某条数据的type*/
+ (NSString *)selectFriendstypeWithUid:(NSString *)uid
{
    FMResultSet *set = nil;
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT friendstype FROM friends WHERE uid = '%@';", uid];
    set = [_db executeQuery:sqlStr];
    //    int count = [set intForColumnIndex:0];
    NSString *name;
    while ([set next]) { // next方法返回yes代表有数据可取
        name = [set stringForColumnIndex:0];
    }
    
    NSLog(@"dd = %@", name);
    return name;
}

/*查询sql中某条数据*/
+ (friendModel *)selectFriendsWithUid:(NSString *)uid
{
    FMResultSet *set = nil;
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM friends WHERE uid = '%@';", uid];
    
    set = [_db executeQuery:sqlStr];
    //    int count = [set intForColumnIndex:0];
    NSString *name;
    friendModel *model= [[friendModel alloc]init];
    while ([set next]) { // next方法返回yes代表有数据可取
        name = [set stringForColumnIndex:0];
        //CREATE TABLE IF NOT EXISTS friends(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, username TEXT, nick TEXT, avatar TEXT, birthday TEXT, isblack text, sex text,uid TEXT,  friendstype text, status TEXT, objectId TEXT, createdAt TEXT, updatedAt TEXT, latitude TEXT, longitude TEXT);
        model.userlName = [set stringForColumn:@"username"];
        model.nickName  = [set stringForColumn:@"nick"];
        model.status    = [set stringForColumn:@"status"];
        model.type      = [set stringForColumn:@"friendstype"];
        model.latitude  = [set stringForColumn:@"latitude"];
        model.longitude = [set stringForColumn:@"longitude"];
    }
    
    NSLog(@"dd = %@", name);
    return model;
}

/*查询sql中所有的朋友和关注*/
+ (NSMutableArray *)selectFriendsAndFollows
{
    FMResultSet *set = nil;
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM friends WHERE friendstype != 2 ;"];
    
    set = [_db executeQuery:sqlStr];
    //    int count = [set intForColumnIndex:0];
    NSString *name;
    
    NSMutableArray *friends = [NSMutableArray array];
    while ([set next]) { // next方法返回yes代表有数据可取
       
        friendModel *model= [[friendModel alloc]init];
        model.userlName = [set stringForColumn:@"username"];
        model.nickName  = [set stringForColumn:@"nick"];
        model.status    = [set stringForColumn:@"status"];
        model.type      = [set stringForColumn:@"friendstype"];
        model.latitude  = [set stringForColumn:@"latitude"];
        model.longitude = [set stringForColumn:@"longitude"];
        [friends addObject:model];
    }
    return friends;
}


+ (NSArray *)readBlackListFromSql
{
    NSMutableArray *black = [NSMutableArray array];
    
    FMResultSet *set = nil;
    
    set = [_db executeQuery:@"SELECT * FROM friends WHERE isblack = '0';"];
    //    int count = [set intForColumnIndex:0];
    
    while ([set next]) { // next方法返回yes代表有数据可取
        //CREATE TABLE IF NOT EXISTS friends(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, username TEXT, nick TEXT, avatar TEXT, birthday TEXT, isblack text, sex text,uid TEXT,  friendstype text, status TEXT, objectId TEXT, createdAt TEXT, updatedAt TEXT, latitude TEXT, longitude TEXT);
        friendModel *model= [[friendModel alloc]init];
        model.userlName = [set stringForColumn:@"username"];
        model.nickName  = [set stringForColumn:@"nick"];
        model.userUrl   = [set stringForColumn:@"avatar"];
        model.personAge = [set stringForColumn:@"birthday"];
        model.userSex   = [set stringForColumn:@"sex"];
        model.userId    = [set stringForColumn:@"uid"];
        model.status    = [set stringForColumn:@"status"];
        model.type      = [set stringForColumn:@"friendstype"];
        model.latitude  = [set stringForColumn:@"latitude"];
        model.longitude = [set stringForColumn:@"longitude"];
        
        [black addObject:model];
    }
    

    return black;
}

+ (void)readBlackListFromCloud:(BmobUser *)user successful:(successful)successful
{
//    BmobUser *user = [BmobUser getCurrentUser];
    BmobQuery *bquery = [BmobQuery queryForUser];
    [bquery whereObjectKey:@"blacklist" relatedTo:user];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array) {
            successful(array);
        }
        for (BmobObject  *obj in array) {
            NSLog(@"username = %@",[obj objectForKey:@"username"]);
            
        }
    }];
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


+ (BOOL )isBlankString:(NSString *)string{
    
    BOOL flag = YES;
    
    if (string == nil) {
        
        flag = NO;
        
    }
    
    if (string == NULL) {
        flag = NO;
        
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        
        flag = NO;
        
    }
    
    if ([string isEqualToString:@"(null)"]) {
        flag = NO;
    }
    
    return flag;
    
    
}

@end
