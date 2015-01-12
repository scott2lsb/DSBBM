//
//  NewsTableViewCell.m
//  DSBBM
//
//  Created by bisheng on 14-9-17.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createNewsCell];
    }
    return self;
}

-(void)createNewsCell{
    
    _nickLable = [[UILabel alloc] initWithFrame:CGRectMake(67, 20, 100, 20)];
    _nickLable.font = [UIFont systemFontOfSize:13];
    _nickLable.textColor = [UIcol hexStringToColor:@"#343434"];
    
    _chatLable = [[TQRichTextView alloc] initWithFrame:CGRectMake(67, 42, 140, 15)];
    _chatLable.font = [UIFont systemFontOfSize:11];
    _chatLable.backgroundColor = [UIColor clearColor];
    _chatLable.textColor = [UIcol hexStringToColor:@"#76757b"];
    
    _timeLable = [[UILabel alloc] initWithFrame:CGRectMake(200, 22, 98, 20)];
    _timeLable.textAlignment = NSTextAlignmentRight;
    _timeLable.font = [UIFont systemFontOfSize:10];
    _timeLable.textColor = [UIcol hexStringToColor:@"#76757b"];
    
    _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(14, 16.5, 44, 44)];
    _avatar.layer.cornerRadius = 8;
    _avatar.layer.masksToBounds = YES;
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0,76.5 , 320, 0.5)];
    line.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    
    [self addSubview:line];
    [self addSubview:_avatar];
    [self addSubview:_nickLable];
    [self addSubview:_chatLable];
    [self addSubview:_timeLable];
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
