//
//  photosView.h
//  DSBBM
//
//  Created by morris on 14/12/22.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface photosView : UIView

/**
 *  所有需要展示图片的url地址
 */
@property (nonatomic, strong) NSArray *picUrls;

/**
 *  根据配图的个数计算配图容器的宽高
 *
 *  @param count 配图个数
 *
 *  @return 配图容器的宽高
 */
//+ (CGSize)sizeWithPhotosCount:(int)count;
/**
 *  缩放的view
 */
@property (nonatomic, weak) UIImageView *customIV;

@end
