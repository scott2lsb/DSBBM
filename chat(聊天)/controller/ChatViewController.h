//
//  chatViewController.h
//  DSBBM
//
//  Created by bisheng on 14-9-3.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "smileView.h"

@interface ChatViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, smileViewDelegate>

@property (nonatomic,strong) NSString * charid;
/**从哪进入的（愿望0？个人资料1, 神灯2）*/
@property (nonatomic, assign)int where;
/**是否关注*/
@property (nonatomic, assign)BOOL isFriend;
@property (assign, nonatomic, readonly) UIEdgeInsets originalTableViewContentInset;

- (instancetype)initWithUserDictionary:(NSDictionary *)dic;

@end
