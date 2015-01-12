//
//  voiceTime.h
//  DSBBM
//
//  Created by morris on 15/1/6.
//  Copyright (c) 2015年 qt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface voiceTime : NSObject
+ (void)saveVoiceTime:(NSString *)voiceTime;
+ (NSString *)readVoiceTime;
@end
