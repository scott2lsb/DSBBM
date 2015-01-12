//
//  PLTableViewCell.h
//  DSBBM
//
//  Created by bisheng on 14-9-2.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell<TQRichTextViewDelegate>

@property (nonatomic,strong) TQRichTextView * context;

@property (nonatomic,strong) UILabel * name;

@property (nonatomic,strong) UIImageView * image;

@property (nonatomic,strong) UIView * line;

@property (nonatomic,strong) UILabel * createTime;

@end
