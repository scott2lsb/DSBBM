//
//  GrabTableViewCell.m
//  DSBBM
//
//  Created by bisheng on 14-10-16.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "GrabTableViewCell.h"

@implementation GrabTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        self.avatar.layer.cornerRadius = 6;
        self.avatar.layer.masksToBounds = YES;
        [self addSubview:self.avatar];
        
        self.nick = [[UILabel alloc] initWithFrame:CGRectMake(75, 21, 100, 20)];
        self.nick.font = [UIFont systemFontOfSize:15];
        self.nick.textColor = [UIcol hexStringToColor:@"2e2e2e"];
        [self addSubview:self.nick];
        
        self.distance = [[UILabel alloc] initWithFrame:CGRectMake(170, 21,65, 20)];
        self.distance.textAlignment = NSTextAlignmentRight;
        self.distance.textColor = [UIcol hexStringToColor:@"#bebebe"];
        self.distance.font = [UIFont systemFontOfSize:11];
        [self addSubview:self.distance];
        
        UIImageView * starNull = [[UIImageView alloc] initWithFrame:CGRectMake(75, 44, 144, 18)];
        starNull.image = [UIImage imageNamed:@"qiangxingxingkong"];
        [self addSubview:starNull];
        
        self.star = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 144, 18)];
        self.star.clipsToBounds = YES;
        [starNull addSubview:self.star];
        
        UIImageView * starFull = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 144, 18)];
        starFull.image = [UIImage imageNamed:@"qiangxingxingman"];
        [self.star addSubview:starFull];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(250, 20, 0.5, 40)];
        line.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
        [self addSubview:line];
        
        UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 79.5, 320, 0.5)];
        line2.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
        [self addSubview:line2];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
