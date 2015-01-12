//
//  FriendTableViewCell.h
//  DSBBM
//
//  Created by bisheng on 14-11-3.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "friendModel.h"

@interface FriendTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *Headimg;
@property(nonatomic,strong)UILabel *Namelab;
@property(nonatomic,strong)UIImageView *Age;
@property(nonatomic,strong)UILabel *AgeLabe;
@property(nonatomic,strong)UIImageView *DVimg;

//分割线
@property (nonatomic, strong)UIView *line;

@property (nonatomic, strong)friendModel *friendModel;

@end
