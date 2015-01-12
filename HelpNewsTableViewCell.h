//
//  HelpNewsTableViewCell.h
//  DSBBM
//
//  Created by bisheng on 14-9-23.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpNewsTableViewCell : UITableViewCell<TQRichTextViewDelegate>

@property (nonatomic,strong) UILabel * nick;

@property (nonatomic,strong) TQRichTextView * text;

@property (nonatomic,strong) UILabel * time;

@property (nonatomic,strong) UIImageView * avatar;

@property (nonatomic,strong) UIImageView * wishImage;

@property (nonatomic,strong) TQRichTextView * wish;

@property (nonatomic,strong) UIImageView * like;

@property (nonatomic,strong) UIView * line;

@end
