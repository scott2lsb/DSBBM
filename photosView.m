//
//  photosView.m
//  DSBBM
//
//  Created by morris on 14/12/22.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "photosView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIImageView+WebCache.h"

@interface photosView ()

/**
 *  点击配图最后的frame的值
 */
@property (nonatomic, assign) CGRect lastFrame;


@end

@implementation photosView
/*
 #warning 注意自定义构造方法的时候, initWith写错也会报错
 - (instancetype)initwithName:(NSString *)name
 {
 if (self = [super init]) {
 
 }
 return self;
 }
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.backgroundColor = [UIColor redColor];
        
        // 1创建9张图片
        for (int i = 0; i < 9; i++) {
            UIImageView *iv = [[UIImageView alloc] init];
            iv.userInteractionEnabled = YES;
            [self addSubview:iv];
            iv.tag = i;
            // 添加监听事件
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
            [iv addGestureRecognizer:tap];
        }
    }
    return self;
}

- (void)imageTap:(UITapGestureRecognizer *)tap
{
    // 1.创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    // 2.设置图片浏览器需要展示的图片
    int count = self.picUrls.count;
    
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        
        NSString *p = self.picUrls[i];
        
        // 创建需要显示的photo对象
        MJPhoto *photo = [[MJPhoto alloc] init];
        // 设置需啊哟显示的photo对象的图片地址
        photo.url = [NSURL URLWithString:p];
        
        // 设置显示图片对应哪一个imageview
        photo.srcImageView = self.subviews[i];
        
        // 将photo对象添加到数组中
        [photos addObject:photo];
        
        
    }
    browser.photos = photos;
    
    // 设置当前点击的图片的位置
    browser.currentPhotoIndex = tap.view.tag;
    // 3.显示图片浏览器
    [browser show];
    
}



- (void)setPicUrls:(NSArray *)picUrls // 6 0~5 7 0~6
{
    _picUrls = picUrls;
    int count = picUrls.count;
    NSLog(@"%d, %@", count, picUrls);

    // 防止重用
    
    if (count == 0) {
        self.hidden = YES;
        return;
    }else
    {
        self.hidden = NO;
    }
    
    for (int i = 0; i < 9; i++) {
        UIImageView *iv = (UIImageView *)self.subviews[i];
        iv.layer.cornerRadius = 6;
        iv.layer.masksToBounds = YES;
        // 判断是否需要显示
        if (i < count) {
            // 显示子配图
            [iv sd_setImageWithURL:_picUrls[i]];
            iv.hidden = NO;

        }else
        {
            // 隐藏子配图
            iv.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int count = self.picUrls.count;
    
    for (int i = 0; i < count; i++) {
        UIImageView *iv = self.subviews[i];
        
        CGFloat photoWidth = 70;
        CGFloat photoHeight = 70;
        
        int maxL = 0;
        int row = 0;
        CGRect frame;
        int pictureHeight = 90 + 25;
        if (count < 4) {
            maxL = 0;
            row = i;
            pictureHeight = 90 + 25;
            frame = CGRectMake(0, 0, 320, pictureHeight);
            self.frame = frame;
        }else if(count >= 4){
            pictureHeight = 170 + 25;
            frame = CGRectMake(0, 0, 320, pictureHeight);
            self.frame = frame;
            
            if (i < 4) {
                maxL = 0;
                row = i;
            }else{
                maxL = 1;
                row = i - 4;
            }
        }
        
        
        
        CGFloat photoX = 9.5 + row * 77;
        CGFloat photoY = 10 + maxL * 80;
        iv.frame = CGRectMake(photoX, photoY, photoWidth, photoHeight);
    }
}



@end
