//
//  TQRichTextEmojiRun.m
//  TQRichTextViewDemo
//
//  Created by fuqiang on 13-9-21.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import "TQRichTextEmojiRun.h"

@implementation TQRichTextEmojiRun

- (id)init
{
    self = [super init];
    if (self) {
        self.type = richTextEmojiRunType;
        self.isResponseTouch = NO;
    }
    return self;
}

- (BOOL)drawRunWithRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSString *emojiString = [NSString stringWithFormat:@"%@.png",self.originalText];
    
    UIImage *image = [UIImage imageNamed:emojiString];
    if (image)
    {
        CGContextDrawImage(context, rect, image.CGImage);
    }
    return YES;
}

+ (NSArray *) emojiStringArray
{
    return [NSArray arrayWithObjects:@"[smile]",@"[ue40a]",@"[ue40b]",@"[ue40d]",@"[ue40e]",@"[ue40f]",@"[ue056]",@"[ue057]",@"[ue058]",@"[ue059]",@"[ue105]",@"[ue106]",@"[ue107]",@"[ue108]",@"[ue401]",@"[ue402]",@"[ue403]",@"[ue404]",@"[ue405]",@"[ue406]",@"[ue407]",@"[ue408]",@"[ue409]",@"[ue410]",@"[ue411]",@"[ue412]",@"[ue413]",@"[ue414]",@"[ue415]",nil];
}


+ (NSString *)analyzeText:(NSString *)string runsArray:(NSMutableArray **)runArray
{
    if(string.length >= 6){
    string = [self chooseString:string];
    }
    NSString *markL = @"[";
    NSString *markR = @"]";
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    NSMutableString *newString = [[NSMutableString alloc] initWithCapacity:string.length];
    
    //偏移索引 由于会把长度大于1的字符串替换成一个空白字符。这里要记录每次的偏移了索引。以便简历下一次替换的正确索引
    int offsetIndex = 0;
    
    for (int i = 0; i < string.length; i++)
    {
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
        
        if (([s isEqualToString:markL]) || ((stack.count > 0) && [stack[0] isEqualToString:markL]))
        {
            if (([s isEqualToString:markL]) && ((stack.count > 0) && [stack[0] isEqualToString:markL]))
            {
                for (NSString *c in stack)
                {
                    [newString appendString:c];
                }
                [stack removeAllObjects];
            }
            
            [stack addObject:s];
            
            if ([s isEqualToString:markR] || (i == string.length - 1))
            {
                NSMutableString *emojiStr = [[NSMutableString alloc] init];
                for (NSString *c in stack)
                {
                    [emojiStr appendString:c];
                }
                
                if ([[TQRichTextEmojiRun emojiStringArray] containsObject:emojiStr])
                {
                    TQRichTextEmojiRun *emoji = [[TQRichTextEmojiRun alloc] init];
                    emoji.range = NSMakeRange(i + 1 - emojiStr.length - offsetIndex, 1);
                    emoji.originalText = emojiStr;
                    [*runArray addObject:emoji];
                    [newString appendString:@" "];
                    
                    offsetIndex += emojiStr.length - 1;
                }
                else
                {
                    [newString appendString:emojiStr];
                }
                
                [stack removeAllObjects];
            }
        }
        else
        {
            [newString appendString:s];
        }
    }

    return newString;
}


+(NSString *)chooseString:(NSString *)string{
   
    //    \\\\ue[a-z0-9]{3}
    //    \\\\ue+(\\d+)\\d+(\\w)
     NSInteger a = string.length - 5;
    NSMutableString * newString = [[NSMutableString alloc] initWithFormat:@"%@",string];
    NSString * phoneRegex1 = @"\\\\ue[401][105][abdef0-9]";

    for (int i = 0; i < a; i++)
    { 
        NSString * s  = [string substringWithRange:NSMakeRange(i, 6)];
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex1];
        if([phoneTest evaluateWithObject:s]){
            [newString replaceOccurrencesOfString:s withString:[NSString stringWithFormat:@"[ue%@]",[s substringWithRange:NSMakeRange(3, 3)]]options: NSLiteralSearch range:NSMakeRange(0, [newString length])];
        }
    }
    return newString;
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

@end
