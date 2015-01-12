//
//  YWTableViewCell.m
//  DSBBM
//
//  Created by bisheng on 14-8-27.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "WishTableViewCell.h"

@implementation WishTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        self.backgroundColor = [UIcol hexStringToColor:@"#f0ecf3"];
        
        UIImageView * back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 320, 110)];
        back.image = [UIImage imageNamed:@"wishdi"];
        
        self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 70, 70)];
        self.avatar.layer.cornerRadius = 5;
        self.avatar.layer.masksToBounds = YES;
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(265, 44,45, 45)];
        self.image.layer.cornerRadius = 5;
        self.image.layer.masksToBounds = YES;
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(90, 13, 100, 20)];
        self.name.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
        self.name.font = [UIFont systemFontOfSize:13];
        self.agev = [[UIImageView alloc] initWithFrame:CGRectMake(0, 16, 15, 12)];
        self.age = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 12)];
        self.age.textColor = [UIColor whiteColor];
        self.age.font = [UIFont systemFontOfSize:11];
        self.age.textAlignment = YES;
        [self.agev addSubview:self.age];
        
        self.context = [[TQRichTextView alloc] initWithFrame:CGRectMake(90, 42, 170, 36)];
        self.context.backgroundColor = [UIColor clearColor];
        self.context.userInteractionEnabled = NO;
        self.context.delegage = self;
        self.context.font = [UIFont systemFontOfSize:14];
        self.context.textColor = [UIcol hexStringToColor:@"#787878"];
        self.like = [[UILabel alloc] initWithFrame:CGRectMake(105, 88, 80, 12)];
        self.like.font = [UIFont systemFontOfSize:11];
        self.like.textColor = [UIcol hexStringToColor:@"#bdbdbd"];
        self.comment = [[UILabel alloc] initWithFrame:CGRectMake(160, 88, 80, 12)];
        self.comment.font = [UIFont systemFontOfSize:11];
        self.comment.textColor = [UIcol hexStringToColor:@"#bdbdbd"];
        self.distance = [[UILabel alloc] initWithFrame:CGRectMake(150, 13, 160, 12)];
        self.distance.font = [UIFont systemFontOfSize:11];
        self.distance.textAlignment = NSTextAlignmentRight;
        self.distance.textColor = [UIcol hexStringToColor:@"#bdbdbd"];
        
        self.xian = [[UIView alloc] initWithFrame:CGRectMake(320, 14, 1, 10)];
        self.xian.backgroundColor = [UIcol hexStringToColor:@"#bdbdbd"];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 109.5, 320, 0.5)];
        line.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
        
        [back addSubview:self.xian];
        [back addSubview:self.distance];
        [back addSubview:self.comment];
        [back addSubview:self.like];
       
        [back addSubview:self.context];
        [back addSubview:self.agev];
        [back addSubview:self.name];
        [back addSubview:self.image];
        [back addSubview:self.avatar];

        [back addSubview:self.name];
        [back addSubview:line];

        [self addSubview:back];
    }
    return self;
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
