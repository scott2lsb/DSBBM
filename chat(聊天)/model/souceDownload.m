//
//  souceDownload.m
//  DSBBM
//
//  Created by morris on 15/1/9.
//  Copyright (c) 2015年 qt. All rights reserved.
//

#import "souceDownload.h"

@implementation souceDownload

+ (NSString *)souceDownload:(NSString *)urlStr
{
    NSString *filePath;
    //http://s.bmob.cn/9INSKU&3
    //先判断，资源来自哪里
    NSLog(@"资源来自哪里%@", urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data;
    if ([urlStr hasPrefix:@"http"]) {
        NSLog(@"来自网络");
        //1.查看是本地是否有该资源
        NSString *str = [urlStr substringFromIndex:17];
        str = [str stringByAppendingString:@".amr"];
        filePath = [self getDocumentPath:str];
        BOOL isExist = [self isExistsFile:str];
        if (isExist) {
        }else{
            [self createSaveDir:@"voiceDir"];
            data = [NSData dataWithContentsOfURL:url];
            //若是没有，就将文件下载到本地，yes，覆盖。
            [data writeToFile:filePath atomically:YES];
        }
        
    }else{
        NSLog(@"来自本地");
        data = [NSData dataWithContentsOfFile:urlStr];
        filePath = urlStr;
    }
    return filePath;
}

+ (void)info:(NSString *)getFilePath
{
    NSError *error = nil;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:getFilePath error:&error];
    
    NSLog(@"@@");
    if (fileAttributes != nil) {
        NSNumber *fileSize;
        NSString *fileOwner, *creationDate;
        NSDate *fileModDate;
        //NSString *NSFileCreationDate
        //文件大小
        if ((fileSize = [fileAttributes objectForKey:NSFileSize])) {
            NSLog(@"File size: %qi\n", [fileSize unsignedLongLongValue]);
        }
        //文件创建日期
        if ((creationDate = [fileAttributes objectForKey:NSFileCreationDate])) {
            NSLog(@"File creationDate: %@\n", creationDate);
            //textField.text=NSFileCreationDate;
        }
        //文件所有者
        if ((fileOwner = [fileAttributes objectForKey:NSFileOwnerAccountName])) {
            NSLog(@"Owner: %@\n", fileOwner);
        }
        //文件修改日期
        if ((fileModDate = [fileAttributes objectForKey:NSFileModificationDate])) {
            NSLog(@"Modification date: %@\n", fileModDate);
        }
    }
    else {
        NSLog(@"Path (%@) is invalid.", getFilePath);
    }
    NSLog(@"@@");
}

/**创建文件夹*/
+(void)createSaveDir:(NSString *)dirName
{
    NSString *pathDir = [NSString stringWithFormat:@"%@/Caches/%@", NSHomeDirectory(), dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:pathDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:pathDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

/**
 *  根据文件名,得到Document中的地址
 *
 *  @param filename 文件名
 *
 *  @return 详细地址
 */
+ (NSString *)getDocumentPath:(NSString *)filename{
    NSString *pathDir = [NSString stringWithFormat:@"%@/Caches/%@", NSHomeDirectory(), @"voiceDir"];
    return [pathDir stringByAppendingPathComponent:filename];
}

/**
 *  根据文件路径判断文件是否存在
 *
 *  @param filepath 文件路径
 */
+ (BOOL)isExistsFile:(NSString *)filepath{
    NSFileManager *filemanage = [NSFileManager defaultManager];
    return [filemanage fileExistsAtPath:filepath];
    
}

@end
