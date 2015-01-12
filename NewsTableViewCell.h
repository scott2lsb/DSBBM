//
//  NewsTableViewCell.h
//  DSBBM
//
//  Created by bisheng on 14-9-17.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewsTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel * nickLable;

@property (nonatomic,strong) TQRichTextView * chatLable;

@property (nonatomic,strong) UILabel * timeLable;

@property (nonatomic,strong) UIImageView * avatar;

@end
