//
//  souceDownload.h
//  DSBBM
//
//  Created by morris on 15/1/9.
//  Copyright (c) 2015年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface souceDownload : UIView

/**
 *   根据所给的url,判断是网络数据还是本地数据。网络上的数据，下载到本地后直接加载。
 */
+ (NSString *)souceDownload:(NSString *)urlStr;
/**创建文件夹*/
+(void)createSaveDir:(NSString *)dirName;
@end
