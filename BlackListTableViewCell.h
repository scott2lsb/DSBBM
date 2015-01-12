//
//  BlackListTableViewCell.h
//  DSBBM
//
//  Created by 我想要大双眼皮子 on 14-10-7.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlackListTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView * avatar;

@property (nonatomic,strong) UILabel * nick;

@property (nonatomic,strong) UILabel * bbID;

@property(nonatomic,strong) UIImageView * agev;

@property(nonatomic,strong) UILabel * age;

@property (nonatomic,strong) UIButton * removeBtn;

@end
