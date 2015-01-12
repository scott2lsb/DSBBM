//
//  HelpNewsTableViewCell.m
//  DSBBM
//
//  Created by bisheng on 14-9-23.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "HelpNewsTableViewCell.h"

@implementation HelpNewsTableViewCell

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
    
    _nick = [[UILabel alloc] initWithFrame:CGRectMake(75, 15, 100, 12)];
    _nick.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
    _nick.font = [UIFont systemFontOfSize:13];
    [self addSubview:_nick];
    
    _time = [[UILabel alloc] initWithFrame:CGRectMake(75, 20, 100, 12)];
    _time.font = [UIFont systemFontOfSize:11];
    _time.textColor = [UIcol hexStringToColor:@"#bebebe"];
    [self addSubview:_time];
    
    _text = [[TQRichTextView alloc] initWithFrame:CGRectMake(75,33, 200, 20)];
    _text.userInteractionEnabled = NO;
    _text.backgroundColor = [UIColor clearColor];
    _text.font = [UIFont systemFontOfSize:14];
    _text.textColor = [UIcol hexStringToColor:@"#787878"];
    [self addSubview:_text];
    
    _wish = [[TQRichTextView alloc] initWithFrame:CGRectMake(260, 15, 0, 0)];
    _wish.backgroundColor = [UIColor clearColor];
    _wish.font = [UIFont systemFontOfSize:11];
    _wish.textColor = [UIcol hexStringToColor:@"#bebebe"];
    [self addSubview:_wish];
    
    _wishImage = [[UIImageView alloc] initWithFrame:CGRectMake(260, 15,45, 45)];
    _wishImage.layer.cornerRadius = 8;
    _wishImage.layer.masksToBounds = YES;
    [self addSubview:_wishImage];
    
    _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(15,15, 50, 50)];
    _avatar.layer.cornerRadius = 8;
    _avatar.layer.masksToBounds = YES;
    [self addSubview:_avatar];
    
    _like = [[UIImageView alloc] initWithFrame:CGRectMake(75,28 , 13, 16)];
    _like.image = [UIImage imageNamed:@"kaopuliebiao"];
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _line.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    [self addSubview:_line];
    
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
