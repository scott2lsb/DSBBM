//
//  PhotoViewController.m
//  DSBBM
//
//  Created by bisheng on 14-11-28.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self createScroll];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)createScroll{
    UIScrollView * sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    sv.userInteractionEnabled = YES;
    sv.backgroundColor = [UIColor blackColor];
    sv.pagingEnabled = YES;
    CGPoint point = CGPointMake(self.view.bounds.size.width * self.i, self.view.bounds.size.height);

    [sv setContentOffset:point];
    for(int j = 0 ; j < self.array.count ; j++){
        sv.contentSize = CGSizeMake(self.view.bounds.size.width * self.array.count, self.view.bounds.size.height);
        UIImageView * photo = [[UIImageView alloc] init];
        NSURL * imageimu = [NSURL URLWithString:self.array[j]];
        [photo sd_setImageWithURL:imageimu];
        if(photo.image.size.height < 320 || photo.image.size.width < 320){
             photo.frame = CGRectMake(0, 0, photo.image.size.width,photo.image.size.height);
        }else{
            int k = photo.image.size.width/ self.view.bounds.size.width;
            photo.frame = CGRectMake(0, 0, self.view.bounds.size.width,photo.image.size.height/k);
        }
        photo.center = CGPointMake(self.view.bounds.size.width/2 + self.view.bounds.size.width * j,  self.view.bounds.size.height/2);
        [sv addSubview:photo];
    }
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleRecognizer];
    [self.view addSubview:sv];
}


-(void)goBack{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
