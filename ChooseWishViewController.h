//
//  ChooseWishViewController.h
//  DSBBM
//
//  Created by bisheng on 14-10-15.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WishModel.h"

@interface ChooseWishViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@property (nonatomic,strong) WishModel * wishObject;

@end
