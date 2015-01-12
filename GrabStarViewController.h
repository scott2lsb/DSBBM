//
//  GrabStarViewController.h
//  DSBBM
//
//  Created by bisheng on 14-10-16.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GrabStarViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@property (nonatomic,strong) NSString * userId;

@property  int i;

@end
