//
//  friendDatumViewController.h
//  DSBBM
//
//  Created by 我想要大双眼皮子 on 14-9-3.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "friendModel.h"
#import "UIcol.h"
#import "constellation.h"
#import "mistiming.h"
#import "ChatViewController.h"

@interface friendDatumViewController : UIViewController<UITableViewDelegate>
{
    //用来接收传值的数组
    NSMutableArray *_nextDataArray;
    //title来等于lable.text
    NSString * _nextTitle;
    //传值相册
    UIImageView *_photoImageView;
    //传值用户的愿望
    NSString *_tempStr;
    //传值用户的Id
    NSString *_tempIdStr;
    //船值头像
    NSString *_tempImageViewStr;
    //传值愿望的头像
    NSString *_tempWishImageStr;
    //接收赞  评论   更新时间
    NSString *_zan;
    NSString *_pinglun;
    NSString *_update;
    
    
}
@property(nonatomic)NSMutableArray *nextDataArray;
@property(nonatomic)NSString *nextTitle;
@property(nonatomic)UIImageView *photoImageView;
@property(nonatomic)NSString *tempStr;
@property(nonatomic)NSString *tempIdStr;
@property(nonatomic)NSString *tempWishStr;
@property(nonatomic)NSString *tempImageViewStr;
@property (nonatomic)NSString *tempWishImageStr;
@property(nonatomic)NSString *zan;
@property(nonatomic)NSString *pinglun;
@property(nonatomic)NSString *update;

@end
