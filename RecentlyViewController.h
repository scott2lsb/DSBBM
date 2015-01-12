//
//  RecentlyViewController.h
//  DSBBM
//
//  Created by bisheng on 14-10-13.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RecentlyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@property int i;

@property (nonatomic,strong) NSString * userObject;

@end
