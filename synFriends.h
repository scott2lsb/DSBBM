//
//  synFriends.h
//  DSBBM
//
//  Created by morris on 14/12/3.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface synFriends : NSObject
/**一次请求全部数据*/
+ (void)synchFriend;
/**同步网上数据*/
+ (void)SynchFriendWithTime:(NSString *)timestamp friends:(NSString *)friends type:(NSString *)type;
/**获取上次的时间戳*/
+ (NSString *)readSynchtime;
/**储存现在的时间*/
+ (void)saveSynchtime;
@end
