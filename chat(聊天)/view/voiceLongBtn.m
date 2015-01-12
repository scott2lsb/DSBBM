//
//  voiceLongBtn.m
//  DSBBM
//
//  Created by morris on 15/1/5.
//  Copyright (c) 2015年 qt. All rights reserved.
//

#import "voiceLongBtn.h"

@implementation voiceLongBtn
{
    CGPoint startPoint;
    CGPoint endPoint;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint point = [[touches anyObject]locationInView:self];
    NSLog(@"开始%@",NSStringFromCGPoint(point));
    startPoint = point;
    [self.delegate btnTouchBegin];
    [[self superview] bringSubviewToFront:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject]locationInView:self];
    NSLog(@"结束%@", NSStringFromCGPoint(point));

    float fl = startPoint.y - point.y;
    
    [self.delegate btnTouchEnd:fl];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject]locationInView:self];
    float fl = startPoint.y - point.y;

    [self.delegate btnTouchMove:fl];
}

@end
