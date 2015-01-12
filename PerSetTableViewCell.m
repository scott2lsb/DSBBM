//
//  PerSetTableViewCell.m
//  DSBBM
//
//  Created by bisheng on 14-11-6.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "PerSetTableViewCell.h"

@implementation PerSetTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.choose = [[UIImageView alloc] initWithFrame:CGRectMake(278,16.5, 17, 17)];
        [self addSubview:self.choose];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(15, 49.5, 305, 0.5)];
        line.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
        [self addSubview:line];
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
