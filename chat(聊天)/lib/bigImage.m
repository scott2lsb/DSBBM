//
//  bigImage.m
//  DSBBM
//
//  Created by morris on 15/1/7.
//  Copyright (c) 2015年 qt. All rights reserved.
//

#import "bigImage.h"
#import "SaveImage.h"

@interface bigImage ()
@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) UIButton      *saveBtn;
@end

@implementation bigImage


- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        [self bigImg:url];
    }
    return self;
}

/**
 *  大图
 */
- (void)bigImg:(NSString *)url{
    // 1.添加阴影
    UIButton *cover = [[UIButton alloc] init];
    cover.frame =  [UIScreen mainScreen].bounds ;
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.0;
    [cover addTarget:self action:@selector(smallImg) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cover];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(Main_screen_width * 0.5, Main_screen_height* 0.5, 0, 0)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageWithContentsOfFile:url]];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, Main_screen_height - 45, 51, 30)];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"baocuntupian"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveImage1) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:saveBtn];
    self.saveBtn = saveBtn;
    
    // 2.更换阴影和头像的位置
    
    // 3.执行动画
    [UIView animateWithDuration:0.25 animations:^{
        // 3.1.阴影慢慢显示出来
        cover.alpha = 1;
        
        // 3.2.头像慢慢变大,慢慢移动到屏幕的中间
        CGFloat iconW = self.frame.size.width;
        CGFloat iconH = iconW;
        CGFloat iconY = (self.frame.size.height - iconH) * 0.5;
        imageView.frame = CGRectMake(0, iconY, iconW, iconH);
    }];
}
- (void)saveImage1
{
    NSLog(@"保存图片");
    [SaveImage saveImageToPhotos:self.imageView.image];
}
/**
 *  小图
 */
- (void)smallImg
{
    // 执行动画
    [UIView animateWithDuration:0.25 animations:^{
        // 存放需要执行动画的代码
        
        // 1.头像慢慢变为原来的位置和尺寸
        self.imageView.frame = CGRectMake(Main_screen_width * 0.5,  Main_screen_height* 0.5, 0, 0);
        self.saveBtn.alpha = 0.0;
        // 2.阴影慢慢消失
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        // 动画执行完毕后会自动调用这个block内部的代码
        
        // 3.动画执行完毕后,移除遮盖(从内存中移除)
        [self.saveBtn removeFromSuperview];
        [self.imageView removeFromSuperview];
        [self removeFromSuperview];
        self.saveBtn = nil;
        self.imageView = nil;
    }];
}


@end
