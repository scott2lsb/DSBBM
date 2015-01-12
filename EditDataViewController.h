//
//  EditDataViewController.h
//  DSBBM
//
//  Created by 我想要大双眼皮子 on 14-9-11.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"


@interface EditDataViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>


@property (nonatomic,strong) NSMutableArray * itemArray;

@property (nonatomic,strong) NSMutableArray * recordArray;

@property (nonatomic,strong) NSArray * cityArray;

@property (assign ,nonatomic) NSInteger rowInProvince;

@property (nonatomic,strong) UIPickerView *pickerView ;

@property (nonatomic,strong) NSString * string;

@property int m;

@end
