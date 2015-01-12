//
//  ChooseWishTableViewCell.h
//  DSBBM
//
//  Created by bisheng on 14-10-15.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseWishTableViewCell : UITableViewCell<TQRichTextViewDelegate>

@property (nonatomic,strong) TQRichTextView * content;

@property (nonatomic,strong) UILabel * like;

@property (nonatomic,strong) UILabel * comment;

@property (nonatomic,strong) UIImageView * picture;

@property (nonatomic,strong) UIImageView * likeIcon;

@property (nonatomic,strong) UIImageView * commentIcon;

@property (nonatomic,strong) UIImageView * choose;

@property (nonatomic,strong) UIView * line;

@end
