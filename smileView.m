//
//  smileView.m
//  DSBBM
//
//  Created by morris on 14/12/12.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#define Main_width  [UIScreen mainScreen].bounds.size.width
#define Main_height [UIScreen mainScreen].bounds.size.height

#import "smileView.h"

@interface smileView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *facePageControl;
@property (nonatomic, strong) UIButton *deleteBtn;


@end

@implementation smileView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createScrollView];
        [self createPageCon];
        [self createDeleteBtn];
    }
    return self;
}

- (void)createScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
    _scrollView.backgroundColor        = [UIColor whiteColor];
    _scrollView.contentSize            = CGSizeMake(640, 100);
    _scrollView.pagingEnabled          = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.delegate               = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    [self addEmojiButton:_scrollView];
}
- (void)createPageCon
{
    _facePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(110, 150, 100, 24)];
    _facePageControl.numberOfPages = 2;
    _facePageControl.currentPage = 0;
    _facePageControl.pageIndicatorTintColor = [UIColor grayColor];
    _facePageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:_facePageControl];
}

- (void)createDeleteBtn
{
    _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(270, 140, 24, 24)];
//    _deleteBtn.backgroundColor = [UIColor greenColor];
    [_deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteBtnDidClick) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_deleteBtn];
}
- (void)deleteBtnDidClick
{
    [self.delegate deleteSmile];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [_facePageControl setCurrentPage:_scrollView.contentOffset.x / 320];
    NSLog(@"juli = %f", _scrollView.contentOffset.x);
}

-(void)addEmojiButton:(UIScrollView *)scrollView{
    
    
    NSMutableArray  *emojiArray = [NSMutableArray arrayWithObjects:
                                   @"[ue056]",@"[ue057]",@"[ue058]",@"[ue059]",@"[ue105]",
                                   @"[ue106]",@"[ue107]",@"[ue108]",@"[ue401]",@"[ue402]",
                                   @"[ue404]",@"[ue410]",@"[ue403]",@"[ue405]",@"[ue406]",
                                   @"[ue409]",@"[ue408]",@"[ue407]",@"[ue40d]",@"[ue411]",
                                   @"[ue40e]",@"[ue40a]",@"[ue40f]",@"[ue412]",@"[ue413]",
                                   @"[ue40b]",@"[ue414]",@"[ue415]",nil];
        
    NSMutableArray  *emojiBtnArray = [NSMutableArray array];
    
    CGFloat padding     = (Main_width - 27 * 6) / 7;//22.57
    CGFloat smileWidth  = 27;
    CGFloat smileheight = 27;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 6; j++) {
            UIButton *eBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [eBtn setFrame:CGRectMake(padding +(padding+ smileWidth)*j, 10+(27 +20) * i, smileWidth, smileheight)];
            [emojiBtnArray addObject:eBtn];
            [scrollView addSubview:eBtn];
            //270,
        }
    }
    
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 6; j++) {
            UIButton *eBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [eBtn setFrame:CGRectMake(320 + padding +(padding+ smileWidth)*j, 10+(27 +20) * i, smileWidth, smileheight)];
            [emojiBtnArray addObject:eBtn];
            [scrollView addSubview:eBtn];
            //270,
            
        }
    }
    [emojiBtnArray removeLastObject];
    [emojiBtnArray removeLastObject];
  
    
    for (int i = 0; i < [emojiBtnArray count]; i++) {
        UIButton *eBtn      = [emojiBtnArray objectAtIndex:i];
        NSString    *emojbS = [emojiArray objectAtIndex:i];
        [eBtn setImage:[UIImage imageNamed:emojbS] forState:UIControlStateNormal];
//        [eBtn setTitle:emojbS forState:UIControlStateNormal];
        //         [[eBtn titleLabel] setFont:[UIFont systemFontOfSize:18]];
        eBtn.tag            = i;
        [eBtn addTarget:self action:@selector(addEmoji:) forControlEvents:UIControlEventTouchUpInside];
    }
}


-(void)addEmoji:(UIButton*)sender{
    NSLog(@"点击");
    
    NSMutableArray  *emojiArray = [NSMutableArray arrayWithObjects:
@"[微笑]",@"[哈哈]",@"[害羞]",@"[嘻嘻]",@"[吐舌头]",
@"[飞吻]",@"[流鼻血]",@"[花心]",@"[发呆]",@"[惊讶]",
@"[汗]",@"[灵感]",@"[尴尬]",@"[可怜]",@"[大哭]",
@"[生气]",@"[咆哮]",@"[愤怒]",@"[卖萌]",@"[疑问]",
@"[呕吐]",@"[斜眼]",@"[酷]",@"[瞌睡]",@"[受伤]",
@"[娇媚]",@"[闭嘴]",@"[晕]", nil];
    
    NSString *str = [emojiArray objectAtIndex:sender.tag];
    if ([self.delegate respondsToSelector:@selector(didSelectSmileView:emojiText:)]) {
        [self.delegate didSelectSmileView:self emojiText:str];
    }
    
}

@end
