#import "MessageRemindViewController.h"


@interface MessageRemindViewController ()

@end

@implementation MessageRemindViewController
{
    BOOL sound;
    BOOL vibrate;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [self createNaBar];
    [self createNew];
}

-(void)createNew{
    sound = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sound"] integerValue];
    vibrate = [[[NSUserDefaults standardUserDefaults] objectForKey:@"vibrate"] integerValue];
    for(int i = 0 ; i < 2 ; i++){
        UIButton * btn =  [[UIButton alloc] initWithFrame:CGRectMake(0,64 + i * 50, self.view.bounds.size.width, 50)];
        btn.tag = 100 + i;
        btn.backgroundColor = [UIColor whiteColor];
        [btn setImage:[UIcol imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2] size:CGSizeMake( self.view.bounds.size.width, 50)] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
        lab.font = [UIFont systemFontOfSize:15];
        [btn addSubview:lab];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320 - 40, 13.5, 23, 23)];
        imageView.tag = 200 + i;
        [btn addSubview:imageView];
        if(i == 0){
            lab.text = @"声音";
            if(sound){
             imageView.image = [UIImage imageNamed:@"xuanze"];
            }else{
             imageView.image = [UIImage imageNamed:@"weixuanze"];
            }
        }else{
            lab.text = @"振动";
            if(vibrate){
                imageView.image = [UIImage imageNamed:@"xuanze"];
            }else{
                imageView.image = [UIImage imageNamed:@"weixuanze"];
            }
        }
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5,self.view.bounds.size.width, 0.5)];
        line.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
        [btn addSubview:line];
        
        [self.view addSubview:btn];
    }
  
}


-(void)onClick:(UIButton *)btn{
    UIImageView * imageView = (id)[self.view viewWithTag:btn.tag + 100];
    if(btn.tag == 100){
        sound = !sound;
     [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",sound] forKey:@"sound"];
        if(sound){
            imageView.image = [UIImage imageNamed:@"xuanze"];
        }else{
            imageView.image = [UIImage imageNamed:@"weixuanze"];
        }
    }else{
        vibrate = !vibrate;
     [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",vibrate] forKey:@"vibrate"];
        if(vibrate){
            imageView.image = [UIImage imageNamed:@"xuanze"];
        }else{
            imageView.image = [UIImage imageNamed:@"weixuanze"];
        }
    }
    
       [self changeSetting];
}

-(void)changeSetting{

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:sound] forKey:@"sound"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:vibrate] forKey:@"vibrate"];
}

-(void)createNaBar{
    
    UIView * gj = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    gj.backgroundColor = [UIColor blackColor];
    [self.view addSubview:gj];
    UIView * iv = [[UIView alloc] initWithFrame:CGRectMake(0, 20,320, self.view.bounds.size.height-20)];
    iv.backgroundColor = [UIcol hexStringToColor:@"f2f2f2"];
    [self.view addSubview:iv];
    iv.userInteractionEnabled = YES;
    UIImageView * bar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    bar.image = [UIImage imageNamed:@"tou"];
    [iv addSubview:bar];
    
    UIButton * but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44,44)];
    [but setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"fanhuiselect"] forState:UIControlStateHighlighted];
    [but addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:but];
    
    UILabel * titleBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.text = @"消息提醒";
    titleBar.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    titleBar.shadowOffset = CGSizeMake(1, 0.5);
    titleBar.font = [UIFont systemFontOfSize:18];
    titleBar.textAlignment = YES;
    titleBar.textColor = [UIcol hexStringToColor:@"ffffff"];
    [iv addSubview:titleBar];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
