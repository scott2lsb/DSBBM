//
//  copyBtn.h
//  DSBBM
//
//  Created by morris on 14/12/30.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol copyBtnDelegate <NSObject>

- (void)copyBtnOnclick;

@end

@interface copyBtn : UIButton
+ (instancetype)sharedcopyBtn;

@property (nonatomic, weak)id <copyBtnDelegate>delegate;

@end
