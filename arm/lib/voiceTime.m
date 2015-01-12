//
//  voiceTime.m
//  DSBBM
//
//  Created by morris on 15/1/6.
//  Copyright (c) 2015年 qt. All rights reserved.
//

#import "voiceTime.h"

@implementation voiceTime

+ (void)saveVoiceTime:(NSString *)voiceTime
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:voiceTime forKey:@"voiceTime"];
    [defaults synchronize];
}

+ (NSString *)readVoiceTime
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *VoiceTime = [defaults objectForKey:@"voiceTime"];
    return VoiceTime;
}


@end
