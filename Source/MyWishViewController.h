//
//  MyWishViewController.h
//  DSBBM
//
//  Created by bisheng on 14-9-19.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWishViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@property (nonatomic, copy)NSString *userId;

@end
