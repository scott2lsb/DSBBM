//
//  SearchTableViewCell.m
//  DSBBM
//
//  Created by 我想要大双眼皮子 on 14-9-26.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "SearchTableViewCell.h"

@interface SearchTableViewCell ()



@end

@implementation SearchTableViewCell

- (void)awakeFromNib
{
    _searchImageView.layer.cornerRadius = 10;
    _searchImageView.layer.masksToBounds = YES;
    
    
    _line.backgroundColor = [UIcol hexStringToColor:@"#c8c8c8"];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
