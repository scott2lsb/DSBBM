//
//  NSString+Emote.h
//  06-图文混排
//
//  Created by apple on 14-10-14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

// 表情文本分类
@interface NSString(Emote)

/** 生成表情属性字符串 */
- (NSString *)emoteStringWithDict:(NSDictionary *)dict;
- (NSString *)emoteStringToHanzi;
/**ue403..的[]，转义*/
- (NSString *)smileTrans;
/**图片前加一个空格*/
- (NSString *)numOfSmile;

/**表情尺寸*/
- (NSString *)sizeOfSmile0;
- (NSString *)sizeOfSmile1;

/** 图文混排 */
- (NSAttributedString *)emoteStringWithAttrib:(NSDictionary *)attrib;

/** str是否为空,YES 有值，NO无值*/
- (BOOL )isBlankString;
@end
