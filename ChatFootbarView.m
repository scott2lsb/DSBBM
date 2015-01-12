//
//  ChatFootbarView.m
//  BmobIMDemo
//
//  Created by Bmob on 14-7-2.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "ChatFootbarView.h"

@implementation ChatFootbarView

@synthesize libButton      = _libButton;
@synthesize takeButton     = _takeButton;
@synthesize locationButton = _locationButton;

@synthesize libLabel       = _libLabel;
@synthesize takeLabel      = _takeLabel;
@synthesize locationLabel  = _locationLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(UIButton *)libButton{
    if (!_libButton) {
        _libButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_libButton setImage:[UIImage imageNamed:@"Photo"] forState:UIControlStateNormal];
        [_libButton setImage:[UIImage imageNamed:@"Photoselect"] forState:UIControlStateHighlighted];
        [self addSubview:_libButton];
    }
    
    return _libButton;
}

-(UIButton*)takeButton{
    if (!_takeButton) {
        _takeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_takeButton setImage:[UIImage imageNamed:@"Camera"] forState:UIControlStateNormal];
        [_takeButton setImage:[UIImage imageNamed:@"Cameraselect"] forState:UIControlStateHighlighted];
        [self addSubview:_takeButton];
    }
    
    return _takeButton;
}

-(UIButton *)locationButton{
    if (!_locationButton) {
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationButton setImage:[UIImage imageNamed:@"chat_icon7"] forState:UIControlStateNormal];
        [_locationButton setImage:[UIImage imageNamed:@"chat_icon7_"] forState:UIControlStateHighlighted];
        [self addSubview:_locationButton];
    }
    
    return _locationButton;
}

-(UILabel *)libLabel{
    if (!_libLabel) {
        _libLabel                 = [[UILabel alloc] init];
        _libLabel.backgroundColor = [UIColor clearColor];
        _libLabel.font            = [UIFont systemFontOfSize:13];
//        _libLabel.textColor       = RGB(124, 127, 131, 1.0f);
        _libLabel.textAlignment   = NSTextAlignmentCenter;
        [self addSubview:_libLabel];
    }
    
    return _libLabel;
}

-(UILabel *)takeLabel{
    if (!_takeLabel) {
        _takeLabel                 = [[UILabel alloc] init];
        _takeLabel.backgroundColor = [UIColor clearColor];
        _takeLabel.font            = [UIFont systemFontOfSize:13];
//        _takeLabel.textColor       = RGB(124, 127, 131, 1.0f);
        _takeLabel.textAlignment   = NSTextAlignmentCenter;
        [self addSubview:_takeLabel];
    }
    return _takeLabel;
}

-(UILabel *)locationLabel{
    if (!_locationLabel) {
        _locationLabel                 = [[UILabel alloc] init];
        _locationLabel.backgroundColor = [UIColor clearColor];
        _locationLabel.font            = [UIFont systemFontOfSize:13];
//        _locationLabel.textColor       = RGB(124, 127, 131, 1.0f);
        _locationLabel.textAlignment   = NSTextAlignmentCenter;
        [self addSubview:_locationLabel];
    }
    
    return _locationLabel;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.libButton.frame = CGRectMake(22, 16, 54, 54);
    self.libLabel.frame = CGRectMake(22, 73, 54, 15);
    self.takeButton.frame = CGRectMake(96, 16, 54, 54);
    self.takeLabel.frame = CGRectMake(96, 73, 54, 15);
    self.locationButton.frame = CGRectMake(170, 16, 54, 54);
    self.locationLabel.frame = CGRectMake(170, 73, 54, 15);
}

@end
