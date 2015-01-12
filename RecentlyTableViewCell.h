//
//  RecentlyTableViewCell.h
//  DSBBM
//
//  Created by bisheng on 14-10-20.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentlyTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView * avatar;

@property(nonatomic,strong) UILabel * nick;

@property(nonatomic,strong) UILabel * text;

@property(nonatomic,strong) UIImageView * agev;

@property(nonatomic,strong) UILabel * age;

@property(nonatomic,strong) UIView * line;

@end
