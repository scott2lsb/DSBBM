//
//  chatData.h
//  DSBBM
//
//  Created by morris on 14/12/18.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successfulBack)(BOOL successful, NSDictionary *dict);

@interface chatData : NSObject

/**存储聊天的当前时间*/
+ (void)saveChatMessageTime:(NSString *)timeOfLastMsg;
/**读取聊天时间*/
+ (NSString *)readChatMessageTimeAndSaveTime;
/**当收到推送时*/
+ (void)getMessageWhenReceivePush:(NSString *)refreshTime successful:(successfulBack)successful;

@end
