//
//  FriendTableViewCell.m
//  DSBBM
//
//  Created by bisheng on 14-11-3.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "FriendTableViewCell.h"

@interface FriendTableViewCell ()

@property (nonatomic, strong)UIImageView *doomViewOfIcon;

@end

@implementation FriendTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        // Initialization code

        
    }
    return self;
}

-(void)initSubViews
{
    
    //用户头像
    _Headimg=[[UIImageView alloc]init];
    [self.contentView addSubview:_Headimg];
    _Headimg.layer.cornerRadius = 20;
    _Headimg.layer.masksToBounds = YES;
    
    //用户名
    _Namelab=[[UILabel alloc]init];
    _Namelab.font = [UIFont systemFontOfSize:15];
    _Namelab.textColor=[UIColor blackColor];
    _Namelab.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_Namelab];
    //年纪的背景
    _Age = [[UIImageView alloc]init];
    [self.contentView addSubview:_Age];
    //年纪
    _AgeLabe = [[UILabel alloc]init];
    _AgeLabe.font = [UIFont systemFontOfSize:12];
    _AgeLabe.textColor = [UIColor whiteColor];
    _AgeLabe.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_AgeLabe];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, 320, 0.5)];
    line.backgroundColor = [UIcol hexStringToColor:@"#c8c8c8"];
    [self.contentView addSubview:line];
    
    //大 v img
    _DVimg=[[UIImageView alloc]init];
    [self.contentView addSubview:_DVimg];
    
    
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat headX = 10;
    CGFloat headY = 5;
    CGFloat headW = 40;
    CGFloat headH = 40;
    
    //头像的frame
    _Headimg.frame=CGRectMake(headX, headY, headW, headH);
    /*自定义高度*/
    
    UIFont * tfont = [UIFont systemFontOfSize:15];
    
    _Namelab.font = tfont;
    
    
    _Namelab.lineBreakMode =NSLineBreakByTruncatingTail ;
    //高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    
    CGSize size =CGSizeMake(300,60);
    
    // label可设置的最大高度和宽度
    //    CGSize size = CGSizeMake(300.f, MAXFLOAT);
    
    //    获取当前文本的属性
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    
    //ios7方法，获取文本需要的size，限制宽度
    
    CGSize  actualsize =[_Namelab.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    
    //   更新UILabel的frame
    CGFloat nameX = headY + headW + 15;
    CGFloat nameY = 25 - actualsize.height / 2;
    CGFloat nameW = actualsize.width;
    CGFloat nameH = actualsize.height;
    _Namelab.frame =CGRectMake(nameX, nameY, nameW, nameH);
    /*
     男生／女生
     **/
    CGFloat ageX = nameX + nameW + 10;
    CGFloat ageY = nameY + 5;
    CGFloat ageW = 15;
    CGFloat ageH = 12;
    _Age.frame = CGRectMake(ageX, ageY, ageW, ageH);
    _AgeLabe.frame = _Age.frame;
    
    
}






- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
