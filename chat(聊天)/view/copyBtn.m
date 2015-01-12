//
//  copyBtn.m
//  DSBBM
//
//  Created by morris on 14/12/30.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "copyBtn.h"

@implementation copyBtn

+ (instancetype)sharedcopyBtn
{
    static copyBtn *instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[copyBtn alloc]init];
    });
    return  instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"fuzhi"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(copyText) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

//复制文字
- (void)copyText
{
    [self.delegate copyBtnOnclick];
        

}

@end
