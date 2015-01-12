//
//  RecentlyTableViewCell.m
//  DSBBM
//
//  Created by bisheng on 14-10-20.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "RecentlyTableViewCell.h"

@implementation RecentlyTableViewCell

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
        
        self.text = [[UILabel alloc] initWithFrame:CGRectMake(75, 44, 200, 20)];
        self.text.font = [UIFont systemFontOfSize:13];
        self.text.textColor = [UIcol hexStringToColor:@"787878"];
        [self addSubview:self.text];
        
        self.agev = [[UIImageView alloc] initWithFrame:CGRectMake(0,24, 15, 12)];
        [self addSubview:self.agev];
        
        self.age = [[UILabel alloc] initWithFrame:CGRectMake(0,0,15, 12)];
        self.age.textColor = [UIColor whiteColor];
        self.age.textAlignment = YES;
        self.age.font = [UIFont systemFontOfSize:11];
        [self.agev addSubview:self.age];
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(15, 79.5, 320, 0.5)];
        self.line.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
        [self addSubview:self.line];
        
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
