//
//  wishViewController.h
//  DSBBM
//
//  Created by bisheng on 14-9-3.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WishViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,MJRefreshBaseViewDelegate>

@property (nonatomic,strong) void (^change)();

@property (nonatomic,strong) void (^commentChange)(int i, int j);

@end
