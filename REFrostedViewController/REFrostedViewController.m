//
// REFrostedViewController.m
// REFrostedViewController
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "REFrostedViewController.h"
#import "REFrostedContainerViewController.h"
//#import "UIImage+REFrostedViewController.h"
#import "UIView+REFrostedViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "RECommonFunctions.h"

@interface REFrostedViewController ()

@property (assign, readwrite, nonatomic) CGFloat imageViewWidth;
@property (strong, readwrite, nonatomic) UIImage *image;
@property (strong, readwrite, nonatomic) UIImageView *imageView;
@property (assign, readwrite, nonatomic) BOOL visible;
@property (strong, readwrite, nonatomic) REFrostedContainerViewController *containerViewController;

@end

@implementation REFrostedViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{

    _animationDuration = 0.1f;
    _blurTintColor = REUIKitIsFlatMode() ? nil : [UIColor colorWithWhite:1 alpha:1];
    _blurSaturationDeltaFactor = 1.8f;
    _blurRadius = 10.0f;
    _containerViewController = [[REFrostedContainerViewController alloc] init];
    _containerViewController.frostedViewController = self;
    _minimumMenuViewSize = CGSizeZero;
    _liveBlur = REUIKitIsFlatMode();
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNot) name:@"news" object:nil];
}

-(void)recieveNot{
    UIView * dotBack = (id)[self.view viewWithTag:555];
    UIImageView * menu = (id)[self.view viewWithTag:1001];
    NSArray * array = [[BmobDB currentDatabase] queryRecent];
    UIView * dot = (id)[self.view viewWithTag:557];
    int m = 0;
    for (int j = 0 ; j < array.count ; j++) {
        BmobRecent * news = array[j];
        m += [[[NSUserDefaults standardUserDefaults] objectForKey:news.targetId] integerValue];
        
    }
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue] != 0 || m != 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] != 0){
        if(dotBack == nil){
            UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(20,3, 20,20)];
            dotBack.backgroundColor = [UIcol hexStringToColor:@"#FFD200"];
            dotBack.layer.cornerRadius = 10;
            dotBack.layer.masksToBounds = YES;
            dotBack.tag = 555;
            [dotBack.layer setCornerRadius:CGRectGetHeight([dotBack bounds]) / 2];
            [menu addSubview:dotBack];
            UIView * dot = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 14, 14)];
            dot.backgroundColor = [UIColor redColor];
            dot.tag = 557;
            dot.layer.cornerRadius = 20;
            dot.layer.masksToBounds = YES;
            [dot.layer setCornerRadius:CGRectGetHeight([dot bounds]) / 2];
            [dotBack addSubview:dot];
            UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
            number.tag = 556;
            number.font = [UIFont systemFontOfSize:11];
            number.textColor = [UIColor whiteColor];
            number.textAlignment = NSTextAlignmentCenter;
            if(m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue] >= 99){
                number.text = @"99";
            }else{
                number.text =[NSString stringWithFormat:@"%d",m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue]];
            }

            [dot addSubview:number];
        }else{
            UILabel * number = (id)[self.view viewWithTag:556];
            if(number == nil){
                number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
                number.tag = 556;
                number.font = [UIFont systemFontOfSize:11];
                number.textColor = [UIColor whiteColor];
                number.textAlignment = NSTextAlignmentCenter;
                [dot addSubview:number];
            }
            if(m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue] >= 99){
                number.text = @"99";
            }else{
                number.text =[NSString stringWithFormat:@"%d",m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue]];
            }
        }
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"visit"] integerValue] != 0){
        if(dotBack == nil){
            UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(20,3, 20,20)];
            dotBack.tag = 555;
            dotBack.backgroundColor = [UIcol hexStringToColor:@"#FFD200"];
            dotBack.layer.cornerRadius = 10;
            dotBack.layer.masksToBounds = YES;
            [dotBack.layer setCornerRadius:CGRectGetHeight([dotBack bounds]) / 2];
            [menu addSubview:dotBack];
            UIView * dot = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 14, 14)];
            dot.backgroundColor = [UIColor redColor];
            dot.tag = 557;
            dot.layer.cornerRadius = 20;
            dot.layer.masksToBounds = YES;
            [dot.layer setCornerRadius:CGRectGetHeight([dot bounds]) / 2];
            [dotBack addSubview:dot];
        }else{
            UILabel * number = (id)[self.view viewWithTag:556];
            [number removeFromSuperview];
        }
     }else{
        [menu removeFromSuperview];
        UIImageView * tit = (id)[self.view viewWithTag:1000];
        UIImageView * menu = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        menu.image = [UIImage imageNamed:@"caidan"];
        menu.tag = 1001;
        [tit addSubview:menu];
        UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0,0, 44, 44)];
        v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [tit addSubview:v];
    }
}

- (id)initWithContentViewController:(UIViewController *)contentViewController menuViewController:(UIViewController *)menuViewController
{
    self = [self init];
    if (self) {
        _contentViewController = contentViewController;
        _menuViewController = menuViewController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self re_displayController:self.contentViewController frame:self.view.frame];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.contentViewController beginAppearanceTransition:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.contentViewController endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.contentViewController beginAppearanceTransition:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.contentViewController endAppearanceTransition];
}

#pragma mark -

- (void)presentMenuViewController
{
    
    [self presentMenuViewControllerWithAnimatedApperance:YES];
}

- (void)presentMenuViewControllerWithAnimatedApperance:(BOOL)animateApperance
{
  
    self.containerViewController.animateApperance = animateApperance;
    if (CGSizeEqualToSize(self.minimumMenuViewSize, CGSizeZero)) {
        if (self.direction == REFrostedViewControllerDirectionLeft || self.direction == REFrostedViewControllerDirectionRight)
            self.minimumMenuViewSize = CGSizeMake(self.view.frame.size.width - 106.0f, self.view.frame.size.height);
        
        if (self.direction == REFrostedViewControllerDirectionTop || self.direction == REFrostedViewControllerDirectionBottom)
            self.minimumMenuViewSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 106.0f);
        
    }
    
    if (!self.liveBlur) {
        if (REUIKitIsFlatMode() && !self.blurTintColor) {
            self.blurTintColor = [UIColor colorWithWhite:1 alpha:1];
        }
//        self.containerViewController.screenshotImage = [[self.contentViewController.view re_screenshot] re_applyBlurWithRadius:1 tintColor:self.blurTintColor saturationDeltaFactor:self.blurSaturationDeltaFactor maskImage:nil];
    }
    
    [self re_displayController:self.containerViewController frame:CGRectMake(0,64,self.view.bounds.size.width,self.view.bounds.size.height-64)];
    UIImageView * tit = (id)[self.view viewWithTag:1000];
    if(tit == nil){
        tit = [[UIImageView alloc] initWithFrame:CGRectMake(0,20, self.view.bounds.size.width, 44)];
        tit.image = [UIImage imageNamed:@"tou"];
        tit.tag = 1000;
        UIImageView * dsbbm = [[UIImageView alloc] initWithFrame:CGRectMake(23.5 + 44, 12, 105,20)];
        dsbbm.image = [UIImage imageNamed:@"dsmmb"];
        [tit addSubview:dsbbm];
        [self.view addSubview:tit];
        UIImageView * menu = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        menu.image = [UIImage imageNamed:@"caidan"];
        menu.tag = 1001;
        [tit addSubview:menu];
        NSArray * array = [[BmobDB currentDatabase] queryRecent];
        int m = 0;
        for (int j = 0 ; j < array.count ; j++) {
            BmobRecent * news = array[j];
            m += [[[NSUserDefaults standardUserDefaults] objectForKey:news.targetId] integerValue];
            
        }
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue] != 0 || m != 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] != 0){
            UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(20,3, 20,20)];
            dotBack.backgroundColor = [UIcol hexStringToColor:@"#FFD200"];
            dotBack.layer.cornerRadius = 10;
            dotBack.layer.masksToBounds = YES;
            [dotBack.layer setCornerRadius:CGRectGetHeight([dotBack bounds]) / 2];
            [menu addSubview:dotBack];
            UIView * dot = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 14, 14)];
            dot.backgroundColor = [UIColor redColor];
            dot.layer.cornerRadius = 20;
            dot.tag = 557;
            dot.layer.masksToBounds = YES;
            [dot.layer setCornerRadius:CGRectGetHeight([dot bounds]) / 2];
            [dotBack addSubview:dot];
            UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
            dotBack.tag = 555;
            number.tag = 556;
            number.font = [UIFont systemFontOfSize:11];
            number.textColor = [UIColor whiteColor];
            number.textAlignment = NSTextAlignmentCenter;
            if(m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue] >= 99){
                number.text = @"99";
            }else{
                number.text =[NSString stringWithFormat:@"%d",m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue]];
            }
            [dot addSubview:number];
        }else  if([[[NSUserDefaults standardUserDefaults] objectForKey:@"visit"] integerValue] != 0){
            UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(20,3,20,20)];
            dotBack.tag = 555;
            dotBack.backgroundColor = [UIcol hexStringToColor:@"#FFD200"];
            dotBack.layer.cornerRadius = 10;
            dotBack.layer.masksToBounds = YES;
            [dotBack.layer setCornerRadius:CGRectGetHeight([dotBack bounds]) / 2];
            [menu addSubview:dotBack];
            UIView * dot = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 14,14)];
            dot.backgroundColor = [UIColor redColor];
            dot.tag = 557;
            dot.layer.cornerRadius = 20;
            dot.layer.masksToBounds = YES;
            [dot.layer setCornerRadius:CGRectGetHeight([dot bounds]) / 2];
            [dotBack addSubview:dot];
        }
        UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0,0, 44, 44)];
        v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [tit addSubview:v];
    }
    tit.frame = CGRectMake(0, 20, self.view.bounds.size.width, 44);
    _change = ^(){
        tit.frame = CGRectMake(500, 0, 0, 0);
    };
    
    if(self.visible == YES){
    [self  hideMenuViewController];
        _change();
    }
    self.visible = YES;
}

- (void)hideMenuViewController
{
    if (!self.liveBlur) {
//        self.containerViewController.screenshotImage = [[self.contentViewController.view re_screenshot] re_applyBlurWithRadius:self.blurRadius tintColor:self.blurTintColor saturationDeltaFactor:self.blurSaturationDeltaFactor maskImage:nil];
        [self.containerViewController refreshBackgroundImage];
    }
    [self.containerViewController hide];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self presentMenuViewControllerWithAnimatedApperance:NO];
    }
    
    [self.containerViewController panGestureRecognized:recognizer];
}

#pragma mark -
#pragma mark Rotation handler

- (BOOL)shouldAutorotate
{
    return !self.visible;
}

@end
