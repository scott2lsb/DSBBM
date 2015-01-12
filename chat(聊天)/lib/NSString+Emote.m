//
//  NSString+Emote.m
//  06-图文混排
//
//  Created by apple on 14-10-14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "NSString+Emote.h"

@implementation NSString(Emote)

- (NSArray *)smileWithPattern:(NSString *)pattern{
    // 用字符串本身，实例化一个属性字符串，应该用图片属性字符串替换strM
//    NSMutableString *strM = [[NSMutableString alloc] initWithString:self];
    
    // 1. 实例化正则表达式
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:NULL];
    
    // 2. 匹配字符串
    // 单个匹配结果 NSTextCheckingResult
    NSArray *array = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    return array;

}

//把[微笑]转为\ue403
- (NSString *)emoteStringWithDict:(NSDictionary *)dict
{
    NSMutableString *strM = [[NSMutableString alloc] initWithString:self];
    
    
    NSArray *array = [self smileWithPattern:@"\\[(.*?)\\]"];
    // 3. 倒着遍历匹配数组，依次替换
    NSInteger count = array.count;
    for (NSInteger i = count - 1; i >= 0; i--) {
        // 取出数组中的匹配结果
        NSTextCheckingResult *result = array[i];
        NSRange r = [result rangeAtIndex:0];
        // 要将文字替换位图片
        // 1. 图片的属性字符串
        NSString *imageName = [self substringWithRange:[result rangeAtIndex:1]];
        NSString *str = [NSString stringWithFormat:@"\\\%@", dict[imageName]];
        
        // 2. 使用图片属性字符串替换指定位置的文本
        [strM replaceCharactersInRange:r withString:str];
    }

    return strM;
}

//把\ue403转为[微笑]
- (NSString *)emoteStringToHanzi
{
    NSArray *array0 = [NSArray arrayWithObjects:@"ue056",@"ue057",@"ue058",@"ue059",@"ue105",
                       @"ue106",@"ue107",@"ue108",@"ue401",@"ue402",
                       @"ue404",@"ue410",@"ue403",@"ue405",@"ue406",
                       @"ue409",@"ue408",@"ue407",@"ue40d",@"ue411",
                       @"ue40e",@"ue40a",@"ue40f",@"ue412",@"ue413",
                       @"ue40b",@"ue414",@"ue415",@"ue416",@"ue417",
                       @"ue418",@"ue41f",nil];
    
    NSArray *array1 = [NSArray arrayWithObjects: @"微笑",@"哈哈",@"害羞",@"嘻嘻",@"吐舌头",
                       @"飞吻",@"流鼻血",@"花心",@"发呆",@"惊讶",
                       @"汗",@"灵感",@"尴尬",@"可怜",@"大哭",
                       @"生气",@"咆哮",@"愤怒",@"卖萌",@"疑问",
                       @"呕吐",@"斜眼",@"酷",@"瞌睡",@"受伤",
                       @"娇媚",@"闭嘴",@"晕",@"圣诞老人",@"麋鹿",
                       @"礼物",@"圣诞树",nil];
   
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:array1 forKeys:array0];
    
    NSMutableString *strM = [[NSMutableString alloc] initWithString:self];
    NSArray *array = [self smileWithPattern:@"\\\\ue[a-z0-9A-Z]{3}"];
    // 3. 倒着遍历匹配数组，依次替换
    NSInteger count = array.count;
    for (NSInteger i = count - 1; i >= 0; i--) {
        // 取出数组中的匹配结果
        NSTextCheckingResult *result = array[i];
        NSRange r = [result rangeAtIndex:0];
        // 1. 图片的属性字符串
        NSString *imageName = [self substringWithRange:[result rangeAtIndex:0]];
        NSString *temp = [imageName substringFromIndex:1];
        //        NSString *str = [NSString stringWithFormat:@"///%@", dict[imageName]];
        NSString *strSmile = [NSString stringWithFormat:@"[%@]", dict[temp]];
//        NSString *newString = [self decodeUnicodeBytes:(char *)[strSmile UTF8String]];

        // 2. 使用图片属性字符串替换指定位置的文本
        [strM replaceCharactersInRange:r withString:strSmile];
        
    }
    return strM;
}

//对[ue408]替换成[ue,符合表情的长度
- (NSString *)sizeOfSmile0
{
    
    NSMutableString *strM = [[NSMutableString alloc] initWithString:self];
    NSArray *array = [self smileWithPattern:@"\\[(.*?)\\]"];
    
    // 3. 倒着遍历匹配数组，依次替换
    NSInteger count = array.count;
    for (NSInteger i = count - 1; i >= 0; i--) {
        // 取出数组中的匹配结果
        NSTextCheckingResult *result = array[i];
        NSRange r = [result rangeAtIndex:0];
        // 要将文字替换位图片
        // 1. 图片的属性字符串
        NSString *str = @"[ue";
        // 2. 使用图片属性字符串替换指定位置的文本
        [strM replaceCharactersInRange:r withString:str];
    }
    return strM;
}
//对\ue408替换成[ue,符合表情的长度
- (NSString *)sizeOfSmile1
{
    
    NSMutableString *strM = [[NSMutableString alloc] initWithString:self];
    NSArray *array = [self smileWithPattern:@"\\\\ue[a-z0-9A-Z]{3}"];
    // 3. 倒着遍历匹配数组，依次替换
    NSInteger count = array.count;
    for (NSInteger i = count - 1; i >= 0; i--) {
        // 取出数组中的匹配结果
        NSTextCheckingResult *result = array[i];
        NSRange r = [result rangeAtIndex:0];
        // 1. 图片的属性字符串
        NSString *str = @"[ue";
        // 2. 使用图片属性字符串替换指定位置的文本
        [strM replaceCharactersInRange:r withString:str];
        
    }
    
    return strM;
}


- (NSString *)smileTrans
{
    NSMutableString *strM = [[NSMutableString alloc] initWithString:self];
    NSArray *array = [self smileWithPattern:@"\\\\ue[a-z0-9A-Z]{3}"];
    
    // 3. 倒着遍历匹配数组，依次替换
    NSInteger count = array.count;
    for (NSInteger i = count - 1; i >= 0; i--) {
        // 取出数组中的匹配结果
        NSTextCheckingResult *result = array[i];
        NSRange r = [result rangeAtIndex:0];

        // 1. 图片的属性字符串
        NSString *imageName = [self substringWithRange:[result rangeAtIndex:0]];
        NSString *temp = [imageName substringFromIndex:1];
//        NSString *str = [NSString stringWithFormat:@"///%@", dict[imageName]];
        NSString *strSmile = [NSString stringWithFormat:@"[%@]", temp];
        NSString *newString = [self decodeUnicodeBytes:(char *)[strSmile UTF8String]];
        // 2. 使用图片属性字符串替换指定位置的文本
        [strM replaceCharactersInRange:r withString:newString];

     
    }

    
    return strM;
}

-(NSString *)decodeUnicodeBytes:(char *)stringEncoded {
    unsigned int    unicodeValue;
    char            *p, buff[5];
    NSMutableString *theString;
    NSString        *hexString;
    NSScanner       *pScanner;
    
    theString = [[NSMutableString alloc] init];
    p = stringEncoded;
    
    buff[4] = 0x00;
    while (*p != 0x00) {
        
        if (*p == '\\') {
            p++;
            if (*p == 'u') {
                memmove(buff, ++p, 4);
                
                hexString = [NSString stringWithUTF8String:buff];
                pScanner = [NSScanner scannerWithString: hexString];
                [pScanner scanHexInt: &unicodeValue];
                
                [theString appendFormat:@"%C", (unichar)unicodeValue];
                p += 4;
                continue;
            }
        }
        
        [theString appendFormat:@"%c", *p];
        p++;
    }
    
    return [NSString stringWithString:theString];
}
//**************************************************************************
- (NSString *)numOfSmile
{
    // 用字符串本身，实例化一个属性字符串，应该用图片属性字符串替换strM
    NSMutableString *strM = [[NSMutableString alloc] initWithString:self];
    
    // 1. 实例化正则表达式
    
    NSString *pattern = @"\\[.*?\\]";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:NULL];
    
    
    // 2. 匹配字符串
    // 单个匹配结果 NSTextCheckingResult
    NSArray *array = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    // 3. 倒着遍历匹配数组，依次替换
    NSInteger count = array.count;
    for (NSInteger i = count - 1; i >= 0; i--) {
        // 取出数组中的匹配结果
        NSTextCheckingResult *result = array[i];
        NSRange r = [result rangeAtIndex:0];
        // 要将文字替换位图片
        // 1. 图片的属性字符串
        NSString *imageName = [self substringWithRange:[result rangeAtIndex:0]];
        NSString *lastStr = [NSString stringWithFormat:@" %@",imageName];
        // 2. 使用图片属性字符串替换指定位置的文本
        [strM replaceCharactersInRange:r withString:lastStr];
    }
    
    return strM;
    
    
}

//**************************************************************************
- (NSAttributedString *)emoteStringWithAttrib:(NSDictionary *)attrib
{

    NSMutableAttributedString *strM = [[NSMutableAttributedString alloc] initWithString:self];
    NSString *pattern = @"\\[(.*?)\\]";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:NULL];
    
    NSArray *array = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    NSInteger count = array.count;
    
    // 获取字体高度
    UIFont *font = attrib[NSFontAttributeName];
    CGFloat fontSize = font.pointSize;
    
    for (NSInteger i = count - 1; i >= 0; i--) {
        // 取出数组中的匹配结果
        NSTextCheckingResult *result = array[i];
        NSRange r = [result rangeAtIndex:0];
        
        NSString *tempName = [self substringWithRange:[result rangeAtIndex:1]];
        NSString *imageName = [NSString stringWithFormat:@"[%@]", tempName];
        NSAttributedString *imageStr = [self emoteImageStringWithName:imageName fontSize:fontSize];
        
        // 2. 使用图片属性字符串替换指定位置的文本
        [strM replaceCharactersInRange:r withAttributedString:imageStr];
    }
    
    return strM;
}

// 将 smiley_0 返回对应的属性字符串
- (NSAttributedString *)emoteImageStringWithName:(NSString *)name fontSize:(CGFloat)fontSize {
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:name];
    // 按照字体高度，设置正方形的表情文字
    attachment.bounds = CGRectMake(0, 0, fontSize, fontSize);
    
    return [NSAttributedString attributedStringWithAttachment:attachment];
}
//**************************************************************************

- (BOOL )isBlankString{
    
    BOOL flag = YES;
    
    if (self == nil) {
        
        flag = NO;
        
    }
    
    if (self == NULL) {
        flag = NO;
        
    }
    
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        
        flag = NO;
        
    }
    
    if ([self isEqualToString:@"(null)"]) {
        flag = NO;
    }
    
    return flag;
    
    
}
@end
