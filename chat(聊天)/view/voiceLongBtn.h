//
//  voiceLongBtn.h
//  DSBBM
//
//  Created by morris on 15/1/5.
//  Copyright (c) 2015年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol voiceLongBtnDelegate <NSObject>

- (void)btnTouchBegin;
- (void)btnTouchMove:(float)fl;
- (void)btnTouchEnd:(float)fl;

@end

@interface voiceLongBtn : UIButton

@property (nonatomic, weak)id <voiceLongBtnDelegate>delegate;

@end
