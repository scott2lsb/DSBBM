//
//  UIcol.h
//  DSBBM
//
//  Created by bisheng on 14-8-26.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIcol : NSObject
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end
