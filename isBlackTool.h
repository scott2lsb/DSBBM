//
//  isBlackTool.h
//  DSBBM
//
//  Created by morris on 14/12/9.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface isBlackTool : NSObject
/**拉黑为黑名单*/
+ (void)laheiWithBlackId:(NSString *)_userId;
/**取消黑名单*/
+ (void)cancelBlackListWithBlackId:(NSString *)_userId;
@end
