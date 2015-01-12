//
//  constellation.m
//  DSBBM
//
//  Created by bisheng on 14-9-3.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "constellation.h"

@implementation constellation

+(NSString *)getAstroWithMonth:(int)m day:(int)d{
    
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    
    NSString *astroFormat = @"102123444543";
    
    
    return [NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    
    
    
}

@end
