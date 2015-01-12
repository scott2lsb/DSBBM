//
//  isBlackTool.m
//  DSBBM
//
//  Created by morris on 14/12/9.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "isBlackTool.h"
#import "sqlStatusTool.h"
#import "synFriends.h"
#import "friendModel.h"

@implementation isBlackTool

//拉黑为黑名单
+ (void)laheiWithBlackId:(NSString *)_userId
{
    BmobUser *bUser1 = [BmobUser getCurrentObject];
    //新建relation对象
    BmobRelation *relation = [[BmobRelation alloc] init];
    //relation添加id为27bb999834的用户
    [relation addObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:_userId]];
    //obj 添加关联关系到likes列中
    [bUser1 addRelation:relation forKey:@"blacklist"];
    //异步更新obj的数据
    [bUser1 updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        NSLog(@"error %@",[error description]);
        if (isSuccessful) {
            NSLog(@"拉黑成功");
            
            int there = [sqlStatusTool selectFriendIsThereWithUid:_userId];
            if (there > 0) {
                [sqlStatusTool updatesqlWithId:_userId row:@"isblack" dataStr:@"1"];
            }else{
                NSString *lastTime = [synFriends readSynchtime];
                [synFriends SynchFriendWithTime:lastTime friends:@"blacklist" type:@"3"];
                [synFriends saveSynchtime];
            }
            
            int black = [sqlStatusTool selectBlackWithId:_userId];
            if (black > 0) {
            }else{
                //username, nick, avatar, birthday, isblack, sex, uid, friendstype, status, createdAt, updatedAt, latitude, longitude
                
                BmobQuery * userQuery = [BmobQuery queryForUser];
                [userQuery includeKey:@"userInfo,lastWish"];
                [userQuery getObjectInBackgroundWithId:_userId block:^(BmobObject *object, NSError *error) {
                    if(!error){
                        NSLog(@"%@, %@", object, object.objectId);
                        friendModel *friend = [[friendModel alloc]init];
                        friend.userlName = [object objectForKey:@"username"];
                        friend.userId = object.objectId;
                        NSLog(@"isblack uid = %@, name = %@", friend.userId, friend.userlName);
                        NSString *name = [[object objectForKey:@"nick"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        friend.nickName = name;
                        [sqlStatusTool saveBlackListWithDict:friend];
                    }
                
                }];
            }

            
        }
    }];
    
    

}

//取消拉黑
+ (void)cancelBlackListWithBlackId:(NSString *)_userId
{
    BmobUser *bUser1 = [BmobUser getCurrentObject];
    //进行操作
    //新建relation对象
    BmobRelation *relation = [[BmobRelation alloc] init];
    //relation要移除id为27bb999834的用户
    [relation removeObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:_userId]];
    //obj 更新关联关系到likes列中
    [bUser1 addRelation:relation forKey:@"blacklist"];
    [bUser1 updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if(error)
        {
            NSLog(@"error %@",[error description]);
        }
        
        if (isSuccessful) {
            NSLog(@"取消拉黑成功");
        }
        //朋友表
        int there = [sqlStatusTool selectFriendIsThereWithUid:_userId];
        if (there > 0) {
            NSLog(@"本地取消拉黑成功");
            [sqlStatusTool updatesqlWithId:_userId row:@"isblack" dataStr:@"0"];
        }
        
        //黑名单表
        int black = [sqlStatusTool selectBlackWithId:_userId];
        if (black > 0) {
            [sqlStatusTool deleteBlack:_userId];
        }
        
    }];

}


@end
