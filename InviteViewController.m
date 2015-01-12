//
//  InviteViewController.m
//  DSBBM
//
//  Created by bisheng on 14-12-12.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "InviteViewController.h"
#import "Addresss.h"
#import "TKAddressBook.h"

@interface InviteViewController ()
{
    NSMutableArray * inviteArray;
    NSMutableArray * attentionArray;
}
@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNarBar];
    [self createTable];
}

-(void)createTable{
    NSLog(@"%@",[Addresss queryAddressBook]);
    NSMutableArray * array = [NSMutableArray array];
    for (TKAddressBook * book in [Addresss queryAddressBook]) {
        [array addObject:book.Tel];
    }
    NSLog(@"%@",array);
    BmobQuery   *bquery = [BmobQuery queryForUser];
    [bquery whereKey:@"username" containedIn:array];

    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobUser * Puser in array) {
            NSLog(@"%@",[Puser objectForKey:@"nick"]);
        }
    
    }];
}

-(void)createNarBar{
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView * narBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tou"]];
    narBar.frame = CGRectMake(0, 20, 320, 44);
    narBar.userInteractionEnabled = YES;
    [self.view addSubview:narBar];
    
    UILabel * titleBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.text = @"邀请";
    titleBar.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    titleBar.shadowOffset = CGSizeMake(1, 0.5);
    titleBar.font = [UIFont systemFontOfSize:18];
    titleBar.textAlignment = YES;
    titleBar.textColor = [UIcol hexStringToColor:@"ffffff"];
    [narBar addSubview:titleBar];
    
    UIImageView * sidebar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    sidebar.image = [UIImage imageNamed:@"caidan"];
    sidebar.userInteractionEnabled = YES;
    [narBar addSubview:sidebar];
    
    NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"aladd"];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"chat"] integerValue] != 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLikeAndComment"] integerValue] != 0 || array.count != 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"visit"] integerValue] != 0){
        UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(20,3, 18,18)];
        dotBack.backgroundColor = [UIcol hexStringToColor:@"#FFD200"];
        dotBack.layer.cornerRadius = 10;
        dotBack.layer.masksToBounds = YES;
        [dotBack.layer setCornerRadius:CGRectGetHeight([dotBack bounds]) / 2];
        [sidebar addSubview:dotBack];
        UIView * dot = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 12, 12)];
        dot.backgroundColor = [UIColor redColor];
        dot.layer.cornerRadius = 20;
        dot.layer.masksToBounds = YES;
        [dot.layer setCornerRadius:CGRectGetHeight([dot bounds]) / 2];
        [dotBack addSubview:dot];
    }else{
        NSLog(@"2");
    }
    UIButton * sideBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [sideBtn setImage:[UIcol imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2] size:CGSizeMake(44, 44)] forState:UIControlStateHighlighted];
    [sideBtn addTarget:(DEMONavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [sidebar addSubview:sideBtn];
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
