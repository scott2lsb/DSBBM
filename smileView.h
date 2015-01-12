//
//  smileView.h
//  DSBBM
//
//  Created by morris on 14/12/12.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class smileView;

@protocol smileViewDelegate <NSObject>

-(void)didSelectSmileView:(smileView *)view emojiText:(NSString *)text;

/**点击删除表情*/
- (void)deleteSmile;
@end

@interface smileView : UIView

//- (void)createScrollView;

@property (nonatomic, weak)id <smileViewDelegate>delegate;

@end
