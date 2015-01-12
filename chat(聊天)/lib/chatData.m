//
//  chatData.m
//  DSBBM
//
//  Created by morris on 14/12/18.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "chatData.h"
#import "sqlStatusTool.h"
#import "synFriends.h"
#import "NSString+Emote.h"

@implementation chatData

//********************************************************************

+ (void)getMessageWhenReceivePush:(NSString *)refreshTime successful:(successfulBack)successful
{
    //接受到的信息
    BmobUser *user = [BmobUser getCurrentUser];
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"BmobMsg"];
    bquery.limit = 1000;
    [bquery whereKey:@"toId" equalTo:user.objectId];
    [bquery whereKey:@"msgTime" greaterThan:refreshTime];

    //时间从大到小排列
    [bquery orderByAscending:@"msgTime"];
    //查找GameScore表所有数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSLog(@"有%lu条数据", (unsigned long)array.count);
        if (array.count > 0) {
            BOOL success = YES;
            
            [sqlStatusTool saveChatMeaagaeWith:array];
            NSString *BiggerTime = @"0";
            for (BmobObject *obj in array) {
                //取数据
                NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
                
                if ([[obj objectForKey:@"content"] isBlankString]) {
                    dict1[PUSH_KEY_CONTENT] = [obj objectForKey:@"content"];
                }
                
                dict1[PUSH_KEY_TARGETID] = [obj objectForKey:@"belongId"];
                dict1[PUSH_KEY_TARGETNICK] = [obj objectForKey:@"belongNick"];
                dict1[PUSH_KEY_MSGTYPE] = [obj objectForKey:@"msgType"];
                dict1[PUSH_KEY_MSGTIME] = [obj objectForKey:@"msgTime"];
                dict1[PUSH_KEY_TOID] = [obj objectForKey:@"toId"];
                //
                int num = [sqlStatusTool selectBlackWithId:dict1[PUSH_KEY_TARGETID]];
                [sqlStatusTool selectBlackList];
                if (num > 0) {//黑名单存在
                    NSLog(@"%@, 黑名单存在",dict1[PUSH_KEY_TARGETID]);
                    success = NO;
                }else{//不存在
                    success = YES;
                    NSLog(@"%@, 黑名单不存在",dict1[PUSH_KEY_TARGETID]);
                    [self saveMessageWith:dict1];
                }
                //比较数据中最大的时间戳
                NSString *timeOnLine = [obj objectForKey:@"msgTime"];
                if ([timeOnLine integerValue] > [BiggerTime integerValue]) {
                    BiggerTime = timeOnLine;
                }
                successful(success, dict1);
            }
            NSLog(@"BiggerTime = %@",BiggerTime);
            [self saveChatMessageTime:BiggerTime];
        }
        
    }];
    
}

+ (void)saveMessageWith:(NSDictionary *)userInfo{
    
    BmobQuery * query = [BmobQuery queryForUser];
    NSLog(@"userInfo = %@", userInfo);
    
    BmobChatUser *user =[[BmobChatUser alloc] init];
    user.objectId = userInfo[PUSH_KEY_TARGETID];
    NSString *content = [userInfo objectForKey:PUSH_KEY_CONTENT];
    NSString *toid    = [[userInfo objectForKey:PUSH_KEY_TOID] description];
    int type          = MessageTypeText;
    
    if ([userInfo objectForKey:PUSH_KEY_MSGTYPE]) {
        type = [[userInfo objectForKey:PUSH_KEY_MSGTYPE] intValue];
    }
    
    BmobMsg *msg      = [BmobMsg createReceiveWithUser:user
                                               content:content
                                                  toId:toid
                                                  time:[[userInfo objectForKey:PUSH_KEY_MSGTIME] description]
                                                  type:type status:STATUS_RECEIVER_SUCCESS];
    [[BmobDB currentDatabase] createDataBase];
    [[BmobDB currentDatabase] saveMessage:msg];
    
    [query getObjectInBackgroundWithId:userInfo[PUSH_KEY_TARGETID] block:^(BmobObject *object, NSError *error) {
        
        user.nick = [object objectForKey:@"nick"];
        user.avatar = [object objectForKey:@"avatar"];
        //更新最新的消息
        BmobRecent *recent = [BmobRecent recentObejectWithAvatarString:user.avatar
                                                               message:msg.content
                                                                  nick:user.nick
                                                              targetId:user.objectId
                                                                  time:[msg.msgTime integerValue]
                                                                  type:msg.msgType
                                                            targetName:nil];
        
        msg.belongNick           = [[userInfo objectForKey:PUSH_KEY_TARGETNICK] description];
        //***************************
        [[BmobDB currentDatabase] performSelector:@selector(saveRecent:) withObject:recent afterDelay:0.3f];
        NSString *fid = [userInfo objectForKey:PUSH_KEY_TARGETID];
        [self isFollowThereContent:content fid:fid nick:user.nick object:object];
    }];
    
}


//+ (void)saveMessageWith:(NSDictionary *)userInfo{
//    //    NSLog(@"userInfo%@",userInfo);
//    BmobQuery * query = [BmobQuery queryForUser];
//    NSLog(@"userInfo = %@", userInfo);
//    [query getObjectInBackgroundWithId:userInfo[PUSH_KEY_TARGETID] block:^(BmobObject *object, NSError *error) {
//        BmobChatUser *user =[[BmobChatUser alloc] init];
//        user.nick = [object objectForKey:@"nick"];
//        user.avatar = [object objectForKey:@"avatar"];
//        user.objectId = [object objectId];
//        NSString *content = [userInfo objectForKey:PUSH_KEY_CONTENT];
//        NSString *toid    = [[userInfo objectForKey:PUSH_KEY_TOID] description];
//        int type          = MessageTypeText;
//        if ([userInfo objectForKey:PUSH_KEY_MSGTYPE]) {
//            type = [[userInfo objectForKey:PUSH_KEY_MSGTYPE] intValue];
//        }
//        //    NSLog(@"content = %@， toid = %@",content, toid);
//        
//        BmobMsg *msg      = [BmobMsg createReceiveWithUser:user
//                                                   content:content
//                                                      toId:toid
//                                                      time:[[userInfo objectForKey:PUSH_KEY_MSGTIME] description]
//                                                      type:type status:STATUS_RECEIVER_SUCCESS];
//        [[BmobDB currentDatabase] createDataBase];
//        [[BmobDB currentDatabase] saveMessage:msg];
//        
//        //更新最新的消息
//        BmobRecent *recent = [BmobRecent recentObejectWithAvatarString:user.avatar
//                                                               message:msg.content
//                                                                  nick:user.nick
//                                                              targetId:user.objectId
//                                                                  time:[msg.msgTime integerValue]
//                                                                  type:msg.msgType
//                                                            targetName:nil];
//        
//        msg.belongNick           = [[userInfo objectForKey:PUSH_KEY_TARGETNICK] description];
//        //***************************
//        [[BmobDB currentDatabase] performSelector:@selector(saveRecent:) withObject:recent afterDelay:0.3f];
//        
//        NSString *fid = [userInfo objectForKey:PUSH_KEY_TARGETID];
//        [self isFollowThereContent:content fid:fid nick:user.nick object:object];
//      
//    }];
//    
//}

+ (void)isFollowThereContent:(NSString *)content fid:(NSString *)fromId nick:(NSString *)nickName object:(BmobObject *)object
{
    NSString *followOn = [NSString stringWithFormat:@"%@关注了你",nickName];
    
    if ([content isEqualToString:followOn]) {
        NSLog(@"有人关注了你");
        int there = [sqlStatusTool selectFriendIsThereWithUid:fromId];
        if (there > 0) {//存在
            NSString *status = [sqlStatusTool selectFriendStatusWithUid:fromId];
            if (![status isEqualToString:@"1"]) {//粉丝-朋友
                [sqlStatusTool updatesqlWithId:fromId friendsType:@"0"];
            }else//存在但是取消关注
            {
                [sqlStatusTool updatesqlWithId:fromId friendsType:@"2"];
                [sqlStatusTool updatesqlWithId:fromId status:@"0"];
            }
        }else{//不存在
            NSString *time = [synFriends readSynchtime];
            [synFriends SynchFriendWithTime:time friends:@"fans" type:@"2"];
            [synFriends SynchFriendWithTime:time friends:@"friends" type:@"0"];
            [synFriends saveSynchtime];
            
        }
    }
}

//********************************************************************

+ (void)saveChatMessageTime:(NSString *)timeOfLastMsg
{
    // 1.利用NSUserDefaults,就能直接访问软件的偏好设置(Library/Preferences)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //2.存储网上最后一条数据的时间戳
    [defaults setObject:timeOfLastMsg forKey:@"ChatMessageTime"];
    
    // 3.立刻同步
    [defaults synchronize];
}

+ (NSString *)readChatMessageTimeAndSaveTime {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *timeSynch = [defaults objectForKey:@"ChatMessageTime"];
    
    return timeSynch;
}

@end
