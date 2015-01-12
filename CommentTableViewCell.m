//
//  PLTableViewCell.m
//  DSBBM
//
//  Created by bisheng on 14-9-2.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.context = [[TQRichTextView alloc] initWithFrame:CGRectMake(150,48, 200, 25)];
        self.context.textColor = [UIcol hexStringToColor:@"#787878"];
        self.context.font = [UIFont systemFontOfSize:13];
        self.context.userInteractionEnabled = NO;
        self.context.backgroundColor = [UIColor clearColor];
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(92,15, 200, 25)];
        self.name.font = [UIFont systemFontOfSize:11];
        self.name.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
        
        self.createTime = [[UILabel alloc] initWithFrame:CGRectMake(150, 15, 160, 15)];
        self.createTime.font = [UIFont systemFontOfSize:11];
        self.createTime.textColor  = [UIcol hexStringToColor:@"#bebebe"];
        self.createTime.textAlignment = NSTextAlignmentRight;
        
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(32, 15,50,50)];
        self.image.layer.cornerRadius = 4;
        self.image.layer.masksToBounds = YES;
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0,79.5, 320, 0.5)];
        self.line.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
        
        UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 12, 12)];
        icon.image = [UIImage imageNamed:@"pinglunliebiao"];
        
        [self addSubview:icon];
        [self addSubview:self.createTime];
        [self addSubview:self.line];
        [self addSubview:self.image];
        [self addSubview:self.name];
        [self addSubview:self.context];
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
