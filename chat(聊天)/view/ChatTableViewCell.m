//
//  ChatTableViewCell.m
//  DSBBM
//
//  Created by bisheng on 14-9-6.
//  Copyright (c) 2014年 qt. All rights reserved.
//
#define Main_Screen_Width [UIScreen mainScreen].bounds.size.width
#import "ChatTableViewCell.h"
#import "UIImage+Extension.h"
#import "NSString+Extension.h"
#import "NSString+Emote.h"
#import "chatData.h"
#import "copyBtn.h"
#import "RecordAudio.h"


@implementation ChatTableViewCell
{
    UILabel         *_timeLabel;
    UILabel         *_strLabel;
    BOOL            isAn;
    int             _num;
    CGFloat         _top;
    NSString        *_urlStr;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
//        self.backgroundColor = [UIColor colorWithRed:0.94 green:0.93 blue:0.95 alpha:1];
    }
    return self;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
//        _timeLabel.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 100) * 0.5, 8, 100, 15);
        _timeLabel.layer.cornerRadius = 5;
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.textColor = [UIcol hexStringToColor:@"#787878"];
        [self.contentView addSubview:_timeLabel];
    }
    
    return _timeLabel;
}


-(UIImageView*)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toggleZoom:)];
        singleTapGestureRecognizer.numberOfTapsRequired = 1;
        [_headImageView addGestureRecognizer:singleTapGestureRecognizer];
        [_headImageView.layer setMasksToBounds:YES];
        [_headImageView.layer setCornerRadius:24];
        NSURL *url = [NSURL URLWithString:self.iconUrl];
        [_headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"touxiangjiazaitu"]];
        [self.contentView addSubview:_headImageView];
    }
    
    return _headImageView;
}

- (UIButton *)voiceBtn
{
    if (!_voiceBtn) {
        isAn = NO;
        _num = 0;
        _voiceBtn = [[UIButton alloc]init];
        if (self.fromSelf) {
            [_voiceBtn setImage:[UIImage imageNamed:@"yuyinyou0"] forState:UIControlStateNormal];
        }else{
            [_voiceBtn setImage:[UIImage imageNamed:@"yuyinzuo0"] forState:UIControlStateNormal];
        }
        [_voiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:_voiceBtn];
    }
    return _voiceBtn;
}

- (void)voiceBtnClick:(UIButton *)btn
{
    isAn = !isAn;
    int longtime = [_voiceLong intValue];
    [self.delegete playVoice:_urlStr];
   
    if ([_timer isValid]) {
        NSLog(@"jdj是多大的");
        [self stopTimer];
        return;
    }else{
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(longtime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopTimer];
    });
    
    
//    if (isAn) {
//        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
//        _timer = timer;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(longtime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (isAn) {
//                [self stopTimer];
//                if (self.fromSelf) {
//                    [_voiceBtn setImage:[UIImage imageNamed:@"yuyinyou0"] forState:UIControlStateNormal];
//                }else{
//                    [_voiceBtn setImage:[UIImage imageNamed:@"yuyinzuo0"] forState:UIControlStateNormal];
//                }
//            }
//        });
//    }else{
//        [self stopTimer];
//        if (self.fromSelf) {
//            [_voiceBtn setImage:[UIImage imageNamed:@"yuyinyou0"] forState:UIControlStateNormal];
//        }else{
//            [_voiceBtn setImage:[UIImage imageNamed:@"yuyinzuo0"] forState:UIControlStateNormal];
//        }
//        
//    }
    
}
/**
 *  停止定时器
 */
- (void)stopTimer{
    if (_timer) {
        if ([_timer isValid]) {
            
            [_timer invalidate];
            
            if (self.fromSelf) {
                [_voiceBtn setImage:[UIImage imageNamed:@"yuyinyou0"] forState:UIControlStateNormal];
            }else{
                [_voiceBtn setImage:[UIImage imageNamed:@"yuyinzuo0"] forState:UIControlStateNormal];
            }
        }
    }
}


- (void)changeImage{
    
    NSString *imageName;
    if (self.fromSelf) {
        imageName = [NSString stringWithFormat:@"yuyinyou%d", _num];
        
    }else{
        imageName = [NSString stringWithFormat:@"yuyinzuo%d", _num];
    }
    
    [_voiceBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    _num = _num+ 1;
    if (_num == 4) {
        _num = 0;
    }
    
}


- (copyBtn *)copyBtn
{
    if (!_copyBtn) {
        _copyBtn = [copyBtn sharedcopyBtn];
//        _copyBtn.hidden = YES;
    }
    return _copyBtn;
}

- (void)toggleZoom:(UITapGestureRecognizer *)tap
{
    if ([self.delegete respondsToSelector:@selector(iconOnClick:)]) {
        if (self.fromSelf) {
            [self.delegete iconOnClick:YES];
        }else
        {
            [self.delegete iconOnClick:NO];
        }

    }
    
}

- (void)cellDidClick
{
    if ([self.delegete respondsToSelector:@selector(wishCellOnClick:)]) {
        NSLog(@"objectId = %@",self.dict[@"objectId"]);
        [self.delegete wishCellOnClick:self.dict[@"objectId"]];
    }
}

//送达已读
- (UIImageView *)isReadView
{
    if (!_isReadView) {
        _isReadView = [[UIImageView alloc]init];
        [self.contentView addSubview:_isReadView];
    }
    return _isReadView;
}

-(UIImageView *)bubbleView{
    if (!_bubbleView) {
        _bubbleView = [[UIImageView alloc] init];
        _bubbleView.userInteractionEnabled = YES;
        [self.contentView addSubview: _bubbleView ];
    }
    
    return _bubbleView;
}

//复制文字
- (void)copyText0
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _contentLabel.text;
//    _copyBtn.hidden = YES;
}

- (void)copyBtnOnclick
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _contentLabel.text;
    _copyBtn.hidden = YES;
}

- (void)longPressToDo:(UILongPressGestureRecognizer *)longPress
{
    copyBtn *cb = [copyBtn sharedcopyBtn];
    cb.hidden = NO;
    [self.contentView addSubview:cb];
    cb.delegate = self;
    
    if (self.fromSelf) {
        cb.frame = CGRectMake(self.bubbleView.frame.origin.x + 13 + 5, 0, 50, 25);
    }else{
        cb.frame = CGRectMake(71, 0, 50, 25);
    }
    
    _copyBtn = cb;
    
}
-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [UIcol hexStringToColor:@"#787878"];
        _contentLabel.numberOfLines = 0;
        _contentLabel.userInteractionEnabled = YES;
        //长按手势:复制文字
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 1.0;
        [_contentLabel addGestureRecognizer:longPressGr];
        
        _contentLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_contentLabel];
    }
    
    return _contentLabel;
}

- (void)imageDidClick:(UITapGestureRecognizer *)tap
{
//    NSLog(@"图片点击");
    if ([self.delegete respondsToSelector:@selector(pictureOnClick:)]) {
        [self.delegete pictureOnClick:self.imageUrl];
    }
}
-(UIImageView *)contentImageView{
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        _contentImageView.userInteractionEnabled = YES;
        _contentImageView.layer.cornerRadius = 5;
        _contentImageView.layer.masksToBounds = YES;
        //添加点击手势
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageDidClick:)];
        singleTapGestureRecognizer.numberOfTapsRequired = 1;
        
        [_contentImageView addGestureRecognizer:singleTapGestureRecognizer];

        [self.contentView addSubview:_contentImageView];
    }
    
    return _contentImageView;
}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    //时间上，如果存在
    NSString *timeText = self.timeLabel.text;
    CGFloat top = 20;
    if (timeText) {
        self.timeLabel.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 100) * 0.5, 25, 100, 15);
        top = 43.0f;
    }
    _top = top;
    
    if (self.type == MessageTypeText) {
        self.contentLabel.frame = CGRectZero;
        NSString    *text = self.contentLabel.text;
        
        //size,计算
        NSString *tempStr =  [text sizeOfSmile0];
        CGSize contentSize = [tempStr sizeWithFont:[self setFontSize:15] maxSize:CGSizeMake(135, MAXFLOAT)];
        NSLog(@"%f", contentSize.width);
        // 要设置图片大小=>图片跟文字等高
        // 文字高度 是由字体大小决定的
        NSDictionary *attrib = @{NSFontAttributeName : [UIFont systemFontOfSize:19]};
        NSString *text1 = [text smileTrans];
        self.contentLabel.attributedText = [text1 emoteStringWithAttrib:attrib];
        
        if (self.fromSelf) {
            [self.contentLabel setTextColor:[UIColor blackColor]];
            if (contentSize.width < 45) {
                self.bubbleView.frame =  CGRectMake(320-67-(contentSize.width + 33), top, contentSize.width + 40, contentSize.height + 34);//28+17+20
            }else{
            
                self.bubbleView.frame =  CGRectMake(320-62-(contentSize.width + 33), top, contentSize.width + 40, contentSize.height + 34);//28+17+20
            }
            
//            NSLog(@"bubbleView.frame = %@",NSStringFromCGRect(self.bubbleView.frame));

            self.contentLabel.frame     = CGRectMake(self.bubbleView.frame.origin.x + 12, self.bubbleView .frame.origin.y +12 , contentSize.width, contentSize.height + 10);
            self.headImageView.frame   = CGRectMake(260, top + self.bubbleView.frame.size.height - 48 - 5, 48.0f, 48.0f);
            //送达已读
            self.isReadView.frame = CGRectMake(self.bubbleView.frame.origin.x  - 35, self.bubbleView.frame.origin.y, 25, 15);
            //复制
            _copyBtn.frame = CGRectMake(self.bubbleView.frame.origin.x + 13 + 5, 0, 50, 25);
            
        }else{

            self.bubbleView.frame = CGRectMake(60, top, contentSize.width + 40, contentSize.height + 34);
            //- 15
            self.contentLabel.frame     = CGRectMake(self.bubbleView.frame.origin.x + 28, self.bubbleView.frame.origin.y + 12, contentSize.width, contentSize.height + 10);
            self.headImageView.frame   = CGRectMake(13, top + self.bubbleView.frame.size.height - 48 - 5 , 48.0f, 48.0f);
            //复制
            _copyBtn.frame = CGRectMake(71, 0, 50, 25);
        }
    }
    
    if (self.type == MessageTypeImage || self.type == MessageTypeLocation) {
        CGSize  contentSize = CGSizeMake(120, 120);
        if (self.fromSelf) {
            [self.contentLabel setTextColor:[UIColor whiteColor]];
            self.bubbleView.frame =  CGRectMake(320-42-(contentSize.width + 33), top, contentSize.width + 19, contentSize.height + 6);
            self.contentImageView.frame     = CGRectMake(self.bubbleView.frame.origin.x + 3, self.bubbleView .frame.origin.y + 3, 120, 120);
//            self.headImageView.frame   = CGRectMake(260, self.bubbleView.frame.size.height-15, 48.0f, 48.0f);
            self.headImageView.frame   = CGRectMake(260, top + self.bubbleView.frame.size.height - 48 - 5, 48.0f, 48.0f);

        }else{
//            [self.contentLabel setTextColor:[CommonUtil setColorByR:55 G:59 B:60]];
            self.bubbleView.frame = CGRectMake(55, top, contentSize.width +19, contentSize.height + 6);
            self.contentImageView.frame     = CGRectMake(self.bubbleView.frame.origin.x + 16, self.bubbleView.frame.origin.y + 3, 120, 120);
            self.headImageView.frame   = CGRectMake(13, top + self.bubbleView.frame.size.height - 48 - 5 , 48.0f, 48.0f);
        }
    }

    
    if (self.type == MessageTypeVoice) {
        
        NSString *tempStr = @"语音1";
        self.contentLabel.text = tempStr;
        int ss = [_voiceLong intValue];
        
        CGFloat Vwidth = 120 + (195 - 120)/60 * ss;
        CGFloat voiceBtnWidth = 24;
        CGFloat voiceBtnHeight = 20;
        CGSize contentSize = [tempStr sizeWithFont:[self setFontSize:15] maxSize:CGSizeMake(135, MAXFLOAT)];
        
        if ([_voiceUrl hasPrefix:@"http"]) {
            NSLog(@"网上的");
            NSArray *voiceArray = [_voiceUrl componentsSeparatedByString:@"&"];
            NSString *urlStr = [voiceArray objectAtIndex:0];
            _urlStr = urlStr;
            NSString *vl = [voiceArray objectAtIndex:1];
            _voiceLong = vl;
        }else{
            _urlStr = _voiceUrl;
            NSArray *voiceArray = [_voiceUrl componentsSeparatedByString:@"&"];
            NSString *temp = [voiceArray objectAtIndex:1];
            temp = [temp substringToIndex:1];
            _voiceLong = temp;

        }
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:15];
        timeLabel.numberOfLines = 0;
        timeLabel.userInteractionEnabled = YES;
        timeLabel.text = _voiceLong;
        [self addSubview:timeLabel];
        
        if (self.fromSelf) {
            timeLabel.textColor = [UIColor whiteColor];
            [self.contentLabel setTextColor:[UIColor blackColor]];
            
            self.bubbleView.frame =  CGRectMake(320-52-Vwidth, top, Vwidth, contentSize.height + 34);//28+17+20
            CGRect frame = self.bubbleView.frame;
            //18 + 25 - 20=23
            self.voiceBtn.frame = frame;
//            self.voiceBtn.frame     = CGRectMake(frame.origin.x +frame.size.width - 28 - voiceBtnWidth, self.bubbleView .frame.origin.y + (frame.size.height - voiceBtnHeight)* 0.5 , voiceBtnWidth , voiceBtnHeight);
            
            timeLabel.frame = CGRectMake(frame.origin.x + 16, self.bubbleView .frame.origin.y + (frame.size.height - voiceBtnHeight)* 0.5, contentSize.width * 0.5, contentSize.height);
            
            self.headImageView.frame   = CGRectMake(260, top + self.bubbleView.frame.size.height - 48 - 5, 48.0f, 48.0f);
            
        }else{
            timeLabel.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
            self.bubbleView.frame = CGRectMake(61, top, Vwidth, contentSize.height + 34);
            //- 15
            CGRect frame = self.bubbleView.frame;
            self.voiceBtn.frame = frame;
//            self.voiceBtn.frame     = CGRectMake(frame.origin.x + 28, self.bubbleView .frame.origin.y + (frame.size.height - voiceBtnHeight)* 0.5, voiceBtnHeight, voiceBtnHeight);
            timeLabel.frame = CGRectMake(frame.origin.x + frame.size.width- contentSize.width * 0.5-16, self.bubbleView .frame.origin.y + (frame.size.height - voiceBtnHeight)* 0.5, contentSize.width * 0.5, contentSize.height);
            self.headImageView.frame   = CGRectMake(13, top + self.bubbleView.frame.size.height - 48 - 5 , 48.0f, 48.0f);
        }


    }
    
    if (self.type == 6) {
        [self setStrLable];
    }
    
    if (self.type == 5) {
        NSLog(@"100,100,100");
        //1.lable“通过什么..发起聊天”
        [self setStrLable];
        //2.愿望
        [self setWishView];
    }
    
}

-(UIFont*)setFontSize:(CGFloat)size{
    return [UIFont systemFontOfSize:size];
}


//1.lable“通过什么..发起聊天”
- (void)setStrLable
{
    _strLabel = [[UILabel alloc] init];
    _strLabel.font = [UIFont systemFontOfSize:11];
//    _strLabel.backgroundColor = [UIcol hexStringToColor:@"#787878"];
    _strLabel.textAlignment = NSTextAlignmentCenter;
    _strLabel.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) * 0.5, _top, 200, 15);
    _strLabel.layer.cornerRadius = 5;
    _strLabel.layer.masksToBounds = YES;
    _strLabel.textColor = [UIcol hexStringToColor:@"#787878"];
    _strLabel.text = _textHead;
    [self addSubview:_strLabel];
}

//2.愿望 109 + 25 = 134
- (void)setWishView
{
    //我的愿望————数据
    // 愿望背景———view
    UIButton *bjWish = [[UIButton alloc]initWithFrame:CGRectMake((Main_Screen_Width - 240) * 0.5, _strLabel.frame.origin.y + _strLabel.frame.size.height + 10, 240, 84)];
    [bjWish setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
    [bjWish setImage:[UIImage imageNamed:@"kuangselect"] forState:UIControlStateHighlighted];
    bjWish.layer.cornerRadius = 10;
    bjWish.layer.masksToBounds = YES;
    [self addSubview:bjWish];
    
    [bjWish addTarget:self action:@selector(cellDidClick) forControlEvents:UIControlEventTouchDown];
    
    
    NSString *urlStr = _dict[@"image"];
    CGFloat iconWidth = 84;
    if([self isBlankString:urlStr]){
        NSLog(@"妈蛋，尽然不是空");
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(1, 1, iconWidth - 2, iconWidth- 3)];
        NSURL *iconUrl = [NSURL URLWithString:urlStr];
        [iconView sd_setImageWithURL:iconUrl];
        [bjWish addSubview:iconView];
        
    }else{
        iconWidth = 0;
    }

    CGFloat lableX = iconWidth + 12;
    CGFloat lableY = ((84 - 25) - 29) * 0.5;
    UILabel     *textLable = [[UILabel alloc]initWithFrame:CGRectMake(lableX, lableY, (240-iconWidth - 24), 29)];
    textLable.textColor = [UIcol hexStringToColor:@"#B6B6B6"];
    textLable.numberOfLines = 2;
    textLable.backgroundColor = [UIColor clearColor];
    UIFont *contetfont = [UIFont systemFontOfSize:14];
    textLable.font = contetfont;
    NSString *text = _dict[@"context"];
    NSLog(@"context = %@", _dict[@"context"]);
    text = [text smileTrans];
    textLable.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attrib = @{NSFontAttributeName : [UIFont systemFontOfSize:20]};
    textLable.attributedText = [text emoteStringWithAttrib:attrib];
    [bjWish addSubview:textLable];
    
    //分割线1
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(iconWidth, 59, 240 - iconWidth, 1)];
    view1.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    [bjWish addSubview:view1];
    //分割线2
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(iconWidth + (240 - iconWidth) * 0.5, 59, 0.5, 25)];
    view2.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    [bjWish addSubview:view2];
    
    
    for (int i = 0; i < 2; i ++) {
        //评论
        CGFloat viewWidth = (240 - iconWidth) * 0.5;
        UIView *zanView = [[UIView alloc]initWithFrame:CGRectMake(iconWidth + viewWidth * i, 59, viewWidth, 50)];
        zanView.backgroundColor = [UIColor clearColor];
        [bjWish addSubview:zanView];
        
        CGFloat iconW = 12;
        CGFloat iconH = iconW;
        CGFloat iconX = 10;
        CGFloat iconY = 6;
        UIImageView *zanImage = [[UIImageView alloc]initWithFrame:CGRectMake(iconX, iconY, iconW, iconH)];
        zanImage.image = [UIImage imageNamed:@"zan"];
        [zanView addSubview:zanImage];
        
        UILabel *zanLable = [[UILabel alloc]initWithFrame:CGRectMake(iconX + iconW + 5, iconY,iconW * 2 , iconH )];
        zanLable.textColor = [UIcol hexStringToColor:@"#bebebe"];
        zanLable.font = [UIFont systemFontOfSize:11];
        [zanView addSubview:zanLable];
        zanView.tag = i;
        
        if (zanView.tag == 0) {
//            zanView.frame = CGRectMake(iconWidth, 59, zanviewW, 50);
            zanImage.image = [UIImage imageNamed:@"zan"];
            NSNumber *num = _dict[@"like"];
            zanLable.text = [NSString stringWithFormat:@"%@",num];

        }else if (zanView.tag == 1){
//            zanView.frame = CGRectMake(iconWidth + zanviewW, 59, zanviewW, 50);
            zanImage.image = [UIImage imageNamed:@"pinlun"];
            NSNumber *num = _dict[@"comment"];
            zanLable.text = [NSString stringWithFormat:@"%@",num];

        }
    }
   
    
 

}

- (CGSize)sizeWithNsstring:(NSString *)str Font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (BOOL )isBlankString:(NSString *)string{
    
    BOOL flag = YES;
    
    if (string == nil) {
        
        flag = NO;
        
    }
    
    if (string == NULL) {
        flag = NO;
        
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        
        flag = NO;
        
    }
    
    if ([string isEqualToString:@"(null)"]) {
        flag = NO;
    }
    
    return flag;
    
    
}




- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
