//
//  HelpNewsTableViewCell.m
//  DSBBM
//
//  Created by bisheng on 14-9-23.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "ChooseWishTableViewCell.h"

@implementation ChooseWishTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createUI];
    }
    return self;
}

-(void)createUI{
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.content = [[TQRichTextView alloc] initWithFrame:CGRectMake(20, 15, 150, 36)];
    self.content.textColor = [UIcol hexStringToColor:@"787878"];
    self.content.font = [UIFont systemFontOfSize:14];
    self.content.backgroundColor = [UIColor clearColor];
    self.content.userInteractionEnabled = NO;
    [self addSubview:self.content];
    
    self.likeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    self.likeIcon.image = [UIImage imageNamed:@"kaopuliebiao"];
    [self addSubview:self.likeIcon];
    
    self.like = [[UILabel alloc] initWithFrame:CGRectMake(35, 58, 80, 12)];
    self.like.font = [UIFont systemFontOfSize:11];
    self.like.textColor = [UIcol hexStringToColor:@"bebebe"];
    [self addSubview:self.like];
    
    self.commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 12, 12)];
    self.commentIcon.image = [UIImage imageNamed:@"pingluliebiao"];
    [self addSubview:self.commentIcon];
    
    self.comment = [[UILabel alloc] initWithFrame:CGRectMake(90, 58, 80, 12)];
    self.comment.font = [UIFont systemFontOfSize:11];
    self.comment.textColor = [UIcol hexStringToColor:@"bebebe"];
    [self addSubview:self.comment];
    
    self.picture = [[UIImageView alloc] initWithFrame:CGRectMake(185, 17,70,70)];
    self.picture.layer.cornerRadius = 6;
    self.picture.layer.masksToBounds = YES;
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    self.line.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
    [self addSubview:self.line];
    
    [self addSubview:self.picture];
    
    self.choose = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
    [self addSubview:self.choose];
    
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
