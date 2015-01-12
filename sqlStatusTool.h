//
//  sqlStatusTool.h
//  DSBBM
//
//  Created by morris on 14/11/19.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^successful)(NSArray *array);
@class friendModel;
@interface sqlStatusTool : NSObject
/**存储数据*/
+ (void)saveModelWithDict:(friendModel *)model;
/**读取数据*/
+ (NSMutableArray *)readFromSqliteWithType:(NSString *)type;

/**删除本地sql文件*/
+ (void)deleteSql;
/**查询sql中数据条数*/
+ (int)numOfSql;
/**查询sql中某条id等于uid的数据是否存在, 0,没有*/
+ (int)selectFriendIsThereWithUid:(NSString *)uid;
/**查询sql中某条数据的status*/
+ (NSString *)selectFriendStatusWithUid:(NSString *)uid;
/**修改数据*/
+ (void)updatesqlWithId:(NSString *)userId status:(NSString *)status;
/**修改朋友类型*/
+ (void)updatesqlWithId:(NSString *)userId friendsType:(NSString *)friendstype;

/**修改uid的名称为row的数据dataStr*/
+ (void)updatesqlWithId:(NSString *)userId row:(NSString *)row dataStr:(NSString *)dataStr;
/**查询Friendstype*/
+ (NSString *)selectFriendstypeWithUid:(NSString *)uid;
/**查询sql中某条数据*/
+ (friendModel *)selectFriendsWithUid:(NSString *)uid;
/**查询sql黑名单*/
+ (NSArray *)readBlackListFromSql;
/**查询云端黑名单*/
+ (void)readBlackListFromCloud:(BmobUser *)user successful:(successful)successful;
/*查询sql中所有的朋友和关注*/
+ (NSMutableArray *)selectFriendsAndFollows;
//*****************************************************
+ (void)saveChatMeaagaeWith:(NSArray *)array;
/**获取到数据库中最大的时间戳*/
+ (NSMutableDictionary *)getLastMessageTime;
//*****************************************************
/**添加黑名单*/
+ (void)saveBlackListWithDict:(friendModel *)model;
/**根据id查询黑名单*/
+ (int)selectBlackWithId:(NSString *)uid;
+ (void)selectBlackList;
/**删除uid的这条黑名单*/
+ (void)deleteBlack:(NSString *)uid;


@end
