//
//  synFriends.m
//  DSBBM
//
//  Created by morris on 14/12/3.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "synFriends.h"
#import "sqlStatusTool.h"
#import "friendModel.h"

@implementation synFriends

//全部导入数据
+ (void)synchFriend
{
    
    //查看数据库中的数据条数
    int num = [sqlStatusTool numOfSql];
    //若是数据库中没有数据，则同步网上数据
    if (num == 0) {
        
        [self SynchFriendWithTime:@"0" friends:@"friends" type:@"0"];
        [self SynchFriendWithTime:@"0" friends:@"follows" type:@"1"];
        [self SynchFriendWithTime:@"0" friends:@"fans" type:@"2"];
        
        [self saveSynchtime];
        
    } else if(num >= 0){//若是数据库有数据，则找出数据库中最后的更新时间，转化为时间戳，同步时间后的数据
        //1.取出上一次存储的时间戳
        NSString *lastTime = [self readSynchtime];
        //2.同步上次时间后的数据
        [self SynchFriendWithTime:lastTime friends:@"friends" type:@"0"];
        [self SynchFriendWithTime:lastTime friends:@"follows" type:@"1"];
        [self SynchFriendWithTime:lastTime friends:@"fans" type:@"2"];
        //3.存储这次的时间
        [self saveSynchtime];
        
    }
    
}


+ (void)SynchFriendWithTime:(NSString *)timestamp friends:(NSString *)friends type:(NSString *)type
{
    //当前用户
    BmobUser *bUser = [BmobUser getCurrentObject];
    //云端代码，参数
    NSDictionary *parameters =  @{@"uid": bUser.objectId,@"timestamp": timestamp};
    
    //云端代码的调用
    [BmobCloud callFunctionInBackground:@"syncFriends2" withParameters:parameters block:^(id object, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        if (![[NSString stringWithFormat:@"%@",object]isEqualToString:@"there is an error in callback function"]) {
//            NSLog(@"object = %@", object);
            
            //***已删除的
            //deletefans
            //deletefollows
            NSArray *deletefansArray = [object objectForKey:@"deletefans"];
            if (deletefansArray.count > 0 ) {
                for (NSDictionary *dict in deletefansArray) {
                    int isThere = [sqlStatusTool selectFriendIsThereWithUid:dict[@"objectId"]];
                    if (isThere > 0) {//存在
                        [sqlStatusTool updatesqlWithId:dict[@"objectId"] status:@"1"];
                    }else{//不存在
                    }
                }
            }
            
            //获取黑名单
            NSArray *blackList = [object objectForKey:@"blacklist"];
            for (int i = 0; i < blackList.count; i ++ ) {
                //取出每一个黑名单信息
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict = blackList[i];
                int num =  [sqlStatusTool selectBlackWithId:dict[@"objectId"]];
                
                if (num > 0) {//存在
                    
                }else{//不存在
                    [self friendDataToModel:dict type:@"4" biao:2];
                }
            }
            
            //朋友****************************************
            NSArray *friendsArray = [object objectForKey:friends];
            
            for (int i = 0; i < friendsArray.count; i ++) {
                //取出每一个朋友信息
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict = friendsArray[i];
                
                //***若黑名单，存在数据，则遍历
                if (blackList.count > 0) {
                    //黑名单若是，黑名单中有该盆友，则不显示，同时，将数据库中该朋友isblack字段变为1；
                    for (NSDictionary *black in blackList) {
                        if ([[black objectForKey:@"nick"] isEqualToString:dict[@"nick"]]) {
                            //0.这不是黑名单？1是黑名单
                            [dict setValue:@"1" forKey:@"isblack"];break;
                            //
                        }else {
                            [dict setValue:@"0" forKey:@"isblack"];
                        }
                    }
                }else{
                    [dict setValue:@"0" forKey:@"isblack"];
                }
                
                //***先查看数据库中有没有该条数据，若有，则更改status
                int isThere = [sqlStatusTool selectFriendIsThereWithUid:dict[@"objectId"]];
                
                if (isThere > 0) {
                    
                    NSString *Friendstype =  [sqlStatusTool selectFriendstypeWithUid:dict[@"objectId"]];
                    if (![Friendstype isEqualToString:type]) {
                        [sqlStatusTool updatesqlWithId:dict[@"objectId"] friendsType:@"0"];
                        
                    }else{
                        
                        NSString *status = [sqlStatusTool selectFriendStatusWithUid:dict[@"objectId"]];
                        if (![status isEqualToString:@"0"]) {
                            [sqlStatusTool updatesqlWithId:dict[@"objectId"] status:@"0"];
                        }
                    }
                }else{
                    //若没有，则添加
                    [self friendDataToModel:dict type:type biao:1];
                }
            }
            
        }
        
    }];
}

/**1.朋友表    2.黑名单*/
+ (void)friendDataToModel:(NSDictionary *)dict type:(NSString *)type biao:(int)biao
{
    friendModel * friend = [[friendModel alloc] init];
    
    friend.userlName = dict[@"username"];
    friend.userId = dict[@"objectId"];
    NSString *name = [dict[@"nick"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    friend.nickName = name;
    friend.userUrl = dict[@"avatar"];
    friend.personAge = dict[@"birthday"];
    
    friend.status = dict[@"status"];
    
    BOOL cheatMode = [dict[@"sex"] boolValue];
    //    friend.userSex
    friend.userSex = [NSString stringWithFormat:@"%hhd", cheatMode ];
    friend.createdDateAt = dict[@"createdAt"];
    friend.UserupDateAt = dict[@"updatedAt"];
    
    //    BOOL b = [dict[@"isblack"] boolValue];
    
    friend.isBlack = dict[@"isblack"];
    friend.type = type;
    
    //地址
    NSDictionary *locationDict =  dict[@"location"];
    friend.latitude =  locationDict[@"latitude"];
    friend.longitude  =  locationDict[@"longitude"];
    
    if (biao == 1) {
        [sqlStatusTool saveModelWithDict:friend];
    }else if (biao == 2)
    {
        [sqlStatusTool saveBlackListWithDict:friend];
    }
    
}


+ (void)saveSynchtime {
    // 1.利用NSUserDefaults,就能直接访问软件的偏好设置(Library/Preferences)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //2.获取当前时间戳
    NSString *timeSynch = [NSString stringWithFormat:@"%ld", time(NULL)];
    // 3.存储数据
    [defaults setObject:timeSynch forKey:@"synchTime"];
    
    // 3.立刻同步
    [defaults synchronize];
}

+ (NSString *)readSynchtime {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *timeSynch = [defaults objectForKey:@"synchTime"];
    
    return timeSynch;
}


@end
