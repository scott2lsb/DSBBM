//
//  ChatTableViewCell.h
//  DSBBM
//
//  Created by bisheng on 14-9-6.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "copyBtn.h"
#import <Foundation/Foundation.h>

@protocol chatTableViewDelegate <NSObject>

@optional
- (void)iconOnClick:(BOOL)fromSelf;
- (void)wishCellOnClick:(NSString *)objectId;
//图片点击
- (void)pictureOnClick:(NSString *)pictureUrl;
//播放音频
- (void)playVoice:(NSString *)urlStr;
@end


@interface ChatTableViewCell : UITableViewCell<copyBtnDelegate>

@property (nonatomic,strong) UILabel     *timeLabel;
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UIImageView *contentImageView;
@property (nonatomic,strong) UIImageView *bubbleView;
@property (nonatomic,strong) UILabel     *contentLabel;
@property (nonatomic,strong) UIButton    *voiceBtn;
//复制
@property (nonatomic,strong) copyBtn     *copyBtn;

@property (assign)           BOOL        fromSelf;
@property (assign)           NSInteger   type;

//已读图标
@property (nonatomic, strong)UIImageView *isReadView;
//代理
@property (nonatomic, weak)id<chatTableViewDelegate> delegete;

/**个人信息字典*/
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, copy) NSString       *textHead;
//
@property (nonatomic, copy) NSString       *imageUrl;
//头像
@property (nonatomic, copy) NSString       *iconUrl;

//音频
@property (nonatomic, copy)NSString         *voiceUrl;
@property (nonatomic, strong) NSData       *voiceData;
@property (nonatomic, copy)  NSString      *voiceLong;
@property (nonatomic, strong)NSTimer         *timer;

@end
