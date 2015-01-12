//
//  YWTableViewCell.h
//  DSBBM
//
//  Created by bisheng on 14-8-27.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WishTableViewCell : UITableViewCell<TQRichTextViewDelegate>

@property (nonatomic,strong) UIImageView * avatar;

@property (nonatomic,strong) UIImageView * image;

@property (nonatomic,strong) UILabel * name;

@property (nonatomic,strong) UIImageView * agev;

@property (nonatomic,strong) UILabel * age;

@property (nonatomic,strong) TQRichTextView * context;

@property (nonatomic,strong) UILabel * like;

@property (nonatomic,strong) UILabel * comment;

@property (nonatomic,strong) UILabel * distance;

@property (nonatomic,strong) UIView * xian;












@end
