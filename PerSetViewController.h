//
//  PerSetViewController.h
//  DSBBM
//
//  Created by bisheng on 14-11-6.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PerSetTableViewCell.h"


@interface PerSetViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property  int i;

@property (nonatomic,strong) NSString * str;


@end
