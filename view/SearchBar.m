//
//  IWSearchBar.m
//  8期微博
//
//  Created by apple on 14-9-1.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "SearchBar.h"

@implementation SearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.设置背景图片
        self.background = [UIImage imageNamed:@"sousuoNew"];
//        self.backgroundColor = [UIColor whiteColor];
        
        // 2.设置文本垂直居中
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        // 3.设置清除按钮
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        // 4.添加放大镜
        self.returnKeyType = UIReturnKeySearch; //设置按键类型

        
        // 4.1创建UIImageView的同时初始化image, 那么UIImageView的frame就是image的size
        UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
        // 4.2设置放大镜为leftview
        self.leftView = iv;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        //frame
        CGRect temp = iv.frame;
        temp.size.width = 30;
        iv.frame = temp;
        
        iv.contentMode = UIViewContentModeCenter;
        
        // 5.设置默认提示信息
        self.placeholder = @"搜索好友";
        self.font = [UIFont systemFontOfSize:12];

    }
    return self;
}


@end
