//
//  ZhuCeXXViewController.m
//  DSBBM
//
//  Created by bisheng on 14-8-19.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "BirthdayViewController.h"
#import "UserViewController.h"


@interface BirthdayViewController ()

@end

@implementation BirthdayViewController
{
    UIImage * strt;
    NSString * sr;
    MBProgressHUD * HUD;
    UIView * birthdayView;
    UILabel * agel;
    NSString * str;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        str = @"1990-1-1";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    UIView * iv = [[UIView alloc] initWithFrame:CGRectMake(0, 20,320, self.view.bounds.size.height-20)];
    iv.backgroundColor =  [UIcol hexStringToColor:@"#f2f2f2"];
    [self.view addSubview:iv];
    iv.userInteractionEnabled = YES;
    UIImageView * bar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    bar.image = [UIImage imageNamed:@"tou"];
    [iv addSubview:bar];
    UIButton * but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,44, 44)];
    [but setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"fanhuiselect"] forState:UIControlStateHighlighted];
    [but addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:but];
    UIButton * nextBut = [[UIButton alloc] initWithFrame:CGRectMake(250,0,70,44)];
    [nextBut setImage:[UIcol imageWithColor:[UIColor clearColor] size:CGSizeMake(70, 44)] forState:UIControlStateNormal];
    [nextBut setImage:[UIcol imageWithColor:[UIColor colorWithRed:0.9 green:0.74 blue:0 alpha:1] size:CGSizeMake(70, 44)] forState:UIControlStateHighlighted];
    [nextBut addTarget:self action:@selector(Next) forControlEvents:UIControlEventTouchUpInside];
    UILabel * nextLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    nextLab.text = @"下一步";
    nextLab.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    nextLab.shadowOffset = CGSizeMake(1, 0.5);
    nextLab.textAlignment = NSTextAlignmentCenter;
    nextLab.font = [UIFont systemFontOfSize:15];
    nextLab.textColor = [UIColor whiteColor];
    [nextBut addSubview:nextLab];
    [iv addSubview:nextBut];
    UILabel * tit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tit.text = @"个人资料(2/4）";
    tit.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    tit.shadowOffset = CGSizeMake(1, 0.5);
    tit.textAlignment = YES;
    tit.textColor = [UIColor whiteColor];
    [iv addSubview:tit];
    
    UIImageView * TX = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tupiantianjia"]];
    TX.frame = CGRectMake(125,69, 70, 70);
    TX.tag = 1001;
    
    TX.userInteractionEnabled = YES;
    UIButton * btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    [btn1 setImage:[UIImage imageNamed:@"tupiantianjiaselect"] forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(asd) forControlEvents:UIControlEventTouchUpInside];
    [TX addSubview:btn1];
    [iv addSubview:TX];
    
    birthdayView = [[UIImageView alloc] init];
    birthdayView.userInteractionEnabled = YES;
    birthdayView.backgroundColor = [UIColor whiteColor];
    birthdayView.frame = CGRectMake(0, 164, 320,96);
    UIView * sline = [[UIView alloc] initWithFrame:CGRectMake(25, 47.5, 320, 0.5)];
    sline.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    [birthdayView addSubview:sline];
    UIView * xline = [[UIView alloc] initWithFrame:CGRectMake(0,95.5, 320, 0.5)];
    xline.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    [birthdayView addSubview:xline];
    [iv addSubview:birthdayView];
    UIButton     *agebtn = [[UIButton alloc] init];
    agebtn.frame            = CGRectMake(0,48, 320, 48);
    agel = [[UILabel alloc] initWithFrame:CGRectMake(53,0, 320, 48)];
    agel.text = @"生日";
    agel.font = [UIFont systemFontOfSize:13];
    agel.textColor = [UIcol hexStringToColor:@"bebebe"];
    [agebtn addSubview:agel];
    agel.tag = 101;
    [agebtn addTarget:self action:@selector(age) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * nickView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 15, 18, 18)];
    nickView.image = [UIImage imageNamed:@"shengri"];
    [agebtn addSubview:nickView];

    
    [birthdayView addSubview:agebtn];

    UITextField * nameText = [[UITextField alloc] initWithFrame:CGRectMake(50,0, 240, 48)];
    nameText.backgroundColor  = [UIColor clearColor];
    nameText.clearButtonMode  = UITextFieldViewModeWhileEditing;
    nameText.placeholder      = @"昵称";
    nameText.tag = 502;
    nameText.font = [UIFont systemFontOfSize:14];
    nameText.textColor = [UIcol hexStringToColor:@"bebebe"];
    nameText.returnKeyType    = UIReturnKeyNext;
    nameText.delegate         = self;
    
    UIImageView * birView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 15, 18, 18)];
    birView.image = [UIImage imageNamed:@"yonghu"];
    [birthdayView addSubview:birView];
    
    [birthdayView addSubview:nameText];
    
    UIView *datePickerv = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 0, 0)];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.backgroundColor =[UIColor colorWithRed:0.94 green:0.93 blue:0.95 alpha:1];
    datePicker.center = CGPointMake(160, self.view.bounds.size.height-100);
    // 设置时区
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:(20 * 365 + 5) * 24 * 60 * 60];
   
    [datePicker setDate:date];
    datePickerv.tag = 500;
    [datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    // 设置当前显示时间
    //    [datePicker setDate:tempDate animated:YES];
    // 设置显示最大时间（此处为当前时间）
    [datePicker setMaximumDate:[NSDate date]];
    // 设置UIDatePicker的显示模式
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    // 当值发生改变的时候调用的方法
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
    datePicker.locale = locale;
    [datePickerv addSubview:datePicker];
    [self.view addSubview:datePickerv];
}

-(void)age{
    UIView *datePickerv = (id)[self.view viewWithTag:500];
    datePickerv.frame = CGRectMake(0, 0, 320, 640);
    UILabel * tf1 = (id)[self.view viewWithTag:101];
    tf1.textColor = [UIcol hexStringToColor:@"787878"];
    tf1.text = str;
    sr = str;
    [UIView animateWithDuration:0.3 animations:^{
         birthdayView.frame = CGRectMake(0, 60, 320,96);
    }];
   
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        birthdayView.frame = CGRectMake(0, 60, 320,96);
    }];
    textField.textColor = [UIcol hexStringToColor:@"787878"];
    return YES;
}



-(void)asd{
     [self updateAvatar];
}

-(void)updateAvatar{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"相册",@"照相", nil];
    
    [as showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    switch (buttonIndex) {
        case 0:{

            [self photoLib];
        }
            break;
        case 1:{

            
            [self takePhoto];
            
        }
            break;
        default:
            break;
    }
    
}

//相册
-(void)photoLib{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType               = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing            = YES;
    
    picker.delegate                 = self;
    [self performSelector:@selector(presentImagePickerController:) withObject:picker afterDelay:.5f];
}
//拍照
-(void)takePhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType               = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing            = YES;
    picker.delegate                 = self;
    [self performSelector:@selector(presentImagePickerController:) withObject:picker afterDelay:.5f];
}

-(void)presentImagePickerController:(UIImagePickerController *)picker{
    [self.navigationController presentViewController:picker animated:YES completion:^{
        //        [self hideBottomView];
    }];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage *editImage          = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *cutImage           = [self cutImage:editImage size:CGSizeMake(640, 640)];
    UIImageView  *imageView = (UIImageView *)[self.view viewWithTag:1001];
    imageView.image = cutImage;
    strt = imageView.image;
    
}

-(NSString *)filepath{
    NSArray  *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirecotry =[paths objectAtIndex:0];
    return documentDirecotry;
}

-(UIImage *)cutImage:(UIImage *)originImage size:(CGSize)size{
    UIGraphicsBeginImageContext(size); //size 为CGSize类型，即你所需要的图片尺寸
    [originImage drawInRect:CGRectMake(0, 0, size.height, size.width)]; //newImageRect指定了图片绘制区域
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(UIImage*)captureView:(UIView *)theView andrect:(CGRect)rect

{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return img;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UIView * v = (id)[self.view viewWithTag:500];
    v.frame = CGRectMake(320, 0, 0, 0);
    UITextField * tf = (id)[self.view viewWithTag:502];
    [UIView animateWithDuration:0.3 animations:^{
     birthdayView.frame = CGRectMake(0, 164, 320,96);
    }];
    [tf resignFirstResponder];
}


-(void)datePickerValueChanged:(UIDatePicker *)pick{
    
    NSDate *selected = [pick date];
    
    
    NSInteger year = [[[NSString stringWithFormat:@"%@",selected] substringWithRange:NSMakeRange(0, 4)] intValue];
    NSInteger month = [[[NSString stringWithFormat:@"%@",selected] substringWithRange:NSMakeRange(5, 2)] intValue];
    NSInteger day = [[[NSString stringWithFormat:@"%@",selected] substringWithRange:NSMakeRange(8, 2)] intValue];
    sr = [NSString stringWithFormat:@"%d-%d-%d",year,month,day];
    UILabel * tf1 = (id)[self.view viewWithTag:101];
    tf1.textColor = [UIcol hexStringToColor:@"787878"];
    tf1.text = sr;
    str = sr;
}


-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)Next{
    
    UITextField * tf = (id)[self.view viewWithTag:502];
    if(tf.text.length > 7){
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"名字长度过长";
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [HUD removeFromSuperview];
            HUD = nil;
        }];
        
        return;
    }
    if(![tf.text isEqualToString:@""] && ![[NSString stringWithFormat:@"%@",strt] isEqualToString:@"(null)"] && ![[NSString stringWithFormat:@"%@",sr] isEqualToString:@"(null)"] ){
    UserViewController * xxvc = [[UserViewController alloc] init];
    xxvc.name = tf.text;
    xxvc.t = strt;
    xxvc.xb = self.sex;
    xxvc.sr = sr;
        BmobQuery * query = [BmobQuery queryWithClassName:@"IDNumber"];
        [query whereKey:@"isUsed" notEqualTo:[NSNumber numberWithBool:YES]];
        query.limit = 1;
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
           xxvc.number =  [array[0] objectForKey:@"number"];
            [self.navigationController pushViewController:xxvc animated:YES];
        }];
    }else{
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"输入信息不全";
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [HUD removeFromSuperview];
            HUD = nil;
        }];
        
    }

    
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
