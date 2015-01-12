//
//  EditDataViewController.m
//  DSBBM
//
//  Created by 我想要大双眼皮子 on 14-9-11.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "EditDataViewController.h"
#import "PerSetViewController.h"
#import "friendInfoViewController.h"
#define Duration 0.2

@interface EditDataViewController ()

@end

@implementation EditDataViewController
{
    BOOL contain;
    CGPoint startPoint;
    CGPoint originPoint;

    UIScrollView * sv;
    UIView * photoView;
    int k;
    UIView * datePickerv;
    UIView * cityPickerv;
    BOOL isPicker;
    BOOL isCityPicker;
    NSMutableArray * basicsComment;
    UIView * basicsView;
    NSMutableArray * photoArray;
    MBProgressHUD * HUD;
    BmobUser * user;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.itemArray = [NSMutableArray array];
        self.cityArray = [NSMutableArray array];
        self.recordArray = [NSMutableArray array];
        isPicker = NO;
        isCityPicker = NO;
        basicsComment = [[NSMutableArray alloc] init];
        
        self.m = 10;
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    BmobUser * bUser = [BmobUser getCurrentUser];
    BmobQuery * query = [BmobQuery queryForUser];
    [self createNarBar];
    [query getObjectInBackgroundWithId:bUser.objectId block:^(BmobObject *object, NSError *error) {
        user = (id)object;
        [self createUI];
        [self createTable];
        [self createPicker];
        [self createCityPicker];
    }];

    
  
    
}


-(void)viewWillAppear:(BOOL)animated{

    if(self.m != 10){
        [basicsComment replaceObjectAtIndex:self.m withObject:self.string];
        [basicsView removeFromSuperview];
        [cityPickerv removeFromSuperview];
        [datePickerv removeFromSuperview];
        [self createTable];
        [self createCityPicker];
        [self createPicker];
    }
}

-(void)createCityPicker{
    cityPickerv = [[UIView alloc] init];
    cityPickerv.backgroundColor = [UIColor blackColor];
    cityPickerv.userInteractionEnabled = YES;
    cityPickerv.frame = CGRectMake(500, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    cityPickerv.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 220, 320, 250)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.backgroundColor = [UIColor whiteColor];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    self.cityArray = [NSArray arrayWithContentsOfFile:path];
    [cityPickerv addSubview:self.pickerView];
    [self.view addSubview:cityPickerv];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)
        return  self.cityArray.count;
    else return [[[self.cityArray objectAtIndex:self.rowInProvince] objectForKey:@"Cities"] count];
    
}
#pragma mark delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [[self.cityArray objectAtIndex:row] objectForKey:@"State"];
    }
    else{
        return [[[[self.cityArray objectAtIndex:self.rowInProvince] objectForKey:@"Cities"] objectAtIndex:row] objectForKey:@"city"];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0){
        self.rowInProvince = row;
        [pickerView reloadComponent:1];
    }
    UILabel * tf = (id)[self.view viewWithTag:206];
    tf.text = [NSString stringWithFormat:@"%@ %@",[[self.cityArray objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"State"],[[[[self.cityArray objectAtIndex:self.rowInProvince] objectForKey:@"Cities"] objectAtIndex:[pickerView selectedRowInComponent:1]] objectForKey:@"city"]];
    [basicsComment replaceObjectAtIndex:6 withObject:tf.text];
}


-(void)createPicker{
    datePickerv = [[UIView alloc] init];
    datePickerv.backgroundColor = [UIColor blackColor];
    datePickerv.userInteractionEnabled = YES;
    UIDatePicker * datePicker = [[UIDatePicker alloc] init];
    datePickerv.frame = CGRectMake(500, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    datePickerv.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.center = CGPointMake(160, self.view.bounds.size.height-100);
    // 设置时区
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

-(void)datePickerValueChanged:(UIDatePicker *)pick{
    
    NSDate *selected = [pick date];
    
    NSInteger year = [[[NSString stringWithFormat:@"%@",selected] substringWithRange:NSMakeRange(0, 4)] intValue];
    NSInteger month = [[[NSString stringWithFormat:@"%@",selected] substringWithRange:NSMakeRange(5, 2)] intValue];
    NSInteger day = [[[NSString stringWithFormat:@"%@",selected] substringWithRange:NSMakeRange(8, 2)] intValue];
    UILabel * tf = (id)[self.view viewWithTag:202];
    tf.text = [NSString stringWithFormat:@"%d-%d-%d",year,month,day];
    [basicsComment replaceObjectAtIndex:2 withObject:tf.text];
}

- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender
{
    
    UIButton *btn = (UIButton *)sender.view;
    if(btn.center.y > 150){
        
        [UIView animateWithDuration:Duration animations:^{
            
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1.0;
            if (!contain)
            {
                btn.center = originPoint;
            }
        
        }];
        [btn setTransform:CGAffineTransformIdentity];
        [btn removeGestureRecognizer:sender];
        return;
    }else if ( btn.center.y < 0)
    {
        [UIView animateWithDuration:Duration animations:^{
            
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1.0;
            if (!contain)
            {
                btn.center = originPoint;
            }
           
        }];
        [btn setTransform:CGAffineTransformIdentity];
        [btn removeGestureRecognizer:sender];
        return;

    }else if (sender.state == UIGestureRecognizerStateBegan)
    {
        startPoint = [sender locationInView:sender.view];
        originPoint = btn.center;
        [UIView animateWithDuration:Duration animations:^{
            
            btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            btn.alpha = 0.7;
        }];
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        
        CGPoint newPoint = [sender locationInView:sender.view];
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        btn.center = CGPointMake(btn.center.x+deltaX,btn.center.y+deltaY);
        NSInteger index = [self indexOfPoint:btn.center withButton:btn];
        if(index >= 0)
        NSLog(@"%d",index);
        if (index<0)
        {
            contain = NO;
        }
        else
        {
            [UIView animateWithDuration:Duration animations:^{
                
                CGPoint temp = CGPointZero;
                UIButton *button = _itemArray[index];
                temp = button.center;
                button.center = originPoint;
                btn.center = temp;
                originPoint = btn.center;
                contain = YES;
            }];
        
            for (NSInteger i = 0;i<_itemArray.count;i++)
            {
                UIButton *button = _itemArray[i];
                if (button == btn)
                {
                    [_itemArray exchangeObjectAtIndex:index withObjectAtIndex:i];
                }
            }
          
//            [_itemArray exchangeObjectAtIndex:index withObjectAtIndex:m];
        }
        
        
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:Duration animations:^{
            
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1.0;
            if (!contain)
            {
                btn.center = originPoint;
            }
        }];
    }

}



- (NSInteger)indexOfPoint:(CGPoint)point withButton:(UIButton *)btn
{
    for (NSInteger i = 0;i<_itemArray.count;i++)
    {
        UIButton *button = _itemArray[i];
        if (button != btn)
        {
            if (CGRectContainsPoint(button.frame, point))
            {
                return i;
            }
        }
    }
    return -1;
}

-(void)addGesture:(UIButton *)btn{
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
    [btn addGestureRecognizer:longGesture];
}

-(void)addPhoto{
    [self updateAvatar];
}

-(void)updateAvatar{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"相册",@"照相", nil];
    as.tag = 200;
    [as showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == 200){
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
    }else{
        if (buttonIndex == [actionSheet cancelButtonIndex]) {
            return;
        }
        switch (buttonIndex) {
            case 0:{
                if(self.itemArray.count == 1){
                    NSLog(@"最后一张");
                }else{
                    UIButton * btn = (id)[self.view viewWithTag:k];
                    [self.itemArray removeObject:btn];                    [btn removeFromSuperview];
                for (int i = 0 ; i < self.itemArray.count; i++) {
                    UIButton * btn = (id)[self.view viewWithTag:i + 500];
                    [btn removeFromSuperview];
                } 
                   NSLog(@"%@",self.itemArray);
                for(int i = 0 ; i < self.itemArray.count + 1; i++){
                    UIButton * avatar = nil;
                    if(i < self.itemArray.count){
                        avatar = self.itemArray[i];
                    }else{
                        avatar = (id)[self.view viewWithTag:9999];
                    }
                        avatar.layer.cornerRadius = 6;
                        avatar.layer.masksToBounds = YES;
                    if(i < 4){
                        avatar.frame  = CGRectMake(9.5 + i * 77, 10, 70, 70);

                    }else{
                        avatar.frame  = CGRectMake(9.5 + (i - 4) * 77, 90, 70, 70);
                    }
                    if(i < self.itemArray.count){
                        [avatar addTarget:self action:@selector(addGesture:) forControlEvents:UIControlEventTouchDown];
                        [avatar addTarget:self action:@selector(subPhoto:) forControlEvents:UIControlEventTouchUpInside];
                        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
                        [avatar addGestureRecognizer:longGesture];
                    }
                    [photoView addSubview:avatar];
             
                }
                }
            }
                break;
            default:
                break;
        }
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
    UIImage *cutImage           = [self cutImage:editImage size:CGSizeMake(640,640)];
    
    UIButton * btn = (id)[self.view viewWithTag:9999];
    
    UIButton * avatar = [UIButton buttonWithType:UIButtonTypeCustom];
    avatar.layer.cornerRadius = 6;
    avatar.layer.masksToBounds = YES;
    avatar.tag = self.itemArray.count + 500;
    if(self.itemArray.count < 4){
        avatar.frame  = CGRectMake(9.5 + self.itemArray.count * 77, 10, 70, 70);
        if(self.itemArray.count != 3){
            btn.frame = CGRectMake(9.5 + (self.itemArray.count + 1) * 77, 10, 70, 70);
        }else{
            btn.frame = CGRectMake(9.5 + (self.itemArray.count - 3) * 77, 90, 70, 70);
        }
    }else{
        avatar.frame  = CGRectMake(9.5 + (self.itemArray.count - 4) * 77, 90, 70, 70);
        btn.frame = CGRectMake(9.5 + (self.itemArray.count - 3) * 77, 90, 70, 70);
     
    }
   
   
    [avatar setImage:cutImage forState:UIControlStateNormal];
    [avatar addTarget:self action:@selector(addGesture:) forControlEvents:UIControlEventTouchDown];
    [avatar addTarget:self action:@selector(subPhoto:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
    [avatar addGestureRecognizer:longGesture];
    
    [self.itemArray addObject:avatar];
 

    [photoView addSubview:avatar];
}

-(void)subPhoto:(UIButton *)btn{
   
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"删除", nil];
        [as showInView:self.view];
        k = btn.tag;
 
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


-(void)createUI{
    
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height - 64)];
    sv.tag = 3000;
    sv.backgroundColor = [UIColor whiteColor];
    sv.delegate =self;
    [self.view addSubview:sv];
    
    photoView = [[UIView alloc] init];
    photoArray = [[NSMutableArray alloc] init];
    [photoArray addObjectsFromArray:[user objectForKey:@"album"]];
    if(photoArray.count == 0){
        [photoArray addObject:[user objectForKey:@"avatar"]];
    }
    [photoArray removeObject:@""];
    [photoArray removeObject:[NSNull null]];
    for(int i = 0 ; i < photoArray.count + 1; i++){
       UIButton * avatar = [UIButton buttonWithType:UIButtonTypeCustom];
        avatar.layer.cornerRadius = 6;
        avatar.layer.masksToBounds = YES;
        avatar.tag = i + 500;
        [self.recordArray addObject:avatar];
        photoView.frame =CGRectMake(0, 0, 320, 170);
        sv.contentSize = CGSizeMake(320, 670);
        if(i < 4){
            avatar.frame  = CGRectMake(9.5 + i * 77, 10, 70, 70);
        }else{
            avatar.frame  = CGRectMake(9.5 + (i - 4) * 77, 90, 70, 70);
        }
        if(i < photoArray.count){
            NSURL * imageimu = [NSURL URLWithString:photoArray[i]];
            UIImageView * i = [[UIImageView alloc] init];
            [i sd_setImageWithURL:imageimu];
            
            [avatar setImage:i.image forState:UIControlStateNormal];
            [avatar addTarget:self action:@selector(addGesture:) forControlEvents:UIControlEventTouchDown];
            [avatar addTarget:self action:@selector(subPhoto:) forControlEvents:UIControlEventTouchUpInside];
            UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
            [avatar addGestureRecognizer:longGesture];
            [self.itemArray addObject:avatar];
            }else{
                avatar.tag = 9999;
            [avatar setImage:[UIImage imageNamed:@"tupiantianjia"] forState:UIControlStateNormal];
            [avatar setImage:[UIImage imageNamed:@"tupiantianjiaselect"] forState:UIControlStateHighlighted];
            [avatar addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
        }
       
        [photoView addSubview:avatar];
    }
    


    
    UIView * photoLine = [[UIView alloc] initWithFrame:CGRectMake(0, photoView.bounds.size.height - 0.5, 320, 0.5)];
    photoLine.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    [photoView addSubview:photoLine];
    [sv addSubview:photoView];
    
}

-(void)createTable{
    NSMutableArray * basicsTitle = [NSMutableArray arrayWithArray:@[@"帮帮号",@"昵称",@"出生日期",@"情感状态",@"学校",@"职业",@"所在地",@"愿望",@"愿望宣言"]];
    NSArray * array = [NSArray arrayWithObjects:@"bbID",@"nick",@"birthday",@"available",@"school",@"job",@"hometown",@"dream",@"declaration", nil];
    if(self.m == 10){
    for(int i = 0 ;i < 9 ;i ++){
        if(![[user objectForKey:array[i]]isEqualToString:@""] && [user objectForKey:array[i]] != nil){
            [basicsComment addObject:[user objectForKey:array[i]]];
        }else{
            [basicsComment addObject:@""];
        }
    }
}
    basicsView  = [[UIView alloc] initWithFrame:CGRectMake(0,photoView.bounds.size.height, 320,500)];
    [sv addSubview:basicsView];
    
    UILabel * basicsLab = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,25)];
    basicsLab.text = @"  基本资料";
    basicsLab.font = [UIFont systemFontOfSize:11];
    basicsLab.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
    basicsLab.backgroundColor = [UIcol hexStringToColor:@"#f2f2f2"];
    [basicsView addSubview:basicsLab];
    CGFloat allBaseViewHeigth = 0;
    CGFloat tempHeigth = 50;
    CGFloat heigth = 375;
    for (int i = 0 ; i < basicsTitle.count ; i++) {
        if(i  == 7)
            allBaseViewHeigth += 25;
        //*********************************
        UILabel *label = [[UILabel alloc]init];
        label.numberOfLines = 0;
        label.userInteractionEnabled = YES;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.tag = 200 + i;
        label.text = basicsComment[i];
        UIFont *font = [UIFont systemFontOfSize:15];
        label.font = font;
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:font forKey:NSFontAttributeName];
        CGSize size = [basicsComment[i] boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        
        //        label.backgroundColor = [UIColor yellowColor];
        
        label.textColor = [UIcol hexStringToColor:@"787878"];
        
        [basicsView addSubview:label];
        
        //********************************
        
        if ((size.height + 17.5) > 50) {
            tempHeigth = size.height + 17.5;
            
        }else
        {
            tempHeigth = 50;
        }
        if(i != 0 ){
            UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, (tempHeigth - size.height) + allBaseViewHeigth - 7, 320, tempHeigth)];
            button.tag = 100 +i;
            [button setImage:[UIcol imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1] size:CGSizeMake(320, tempHeigth)] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(userBtn:) forControlEvents:UIControlEventTouchUpInside];
            [basicsView addSubview:button];
        }
        
        label.frame =CGRectMake(96, 25 + (tempHeigth - size.height) * 0.5 + allBaseViewHeigth,200, size.height);
        //title
        
        UILabel * userTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 25+ allBaseViewHeigth, 67,tempHeigth)];
        userTitle.text = basicsTitle[i];
        userTitle.textAlignment = NSTextAlignmentRight;
        userTitle.textColor = [UIcol hexStringToColor:@"2e2e2e"];
        userTitle.font = [UIFont systemFontOfSize:13];
        [basicsView addSubview:userTitle];
        //********************************
        //        NSLog(@"size.height = %f", size.height);
        
        if(i != basicsTitle.count - 1 && i != basicsTitle.count - 3){
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(81, tempHeigth, 220, 0.5)];
            line.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
            [userTitle addSubview:line];
        }else{
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(-30, tempHeigth, 350, 0.5)];
            line.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
            [userTitle addSubview:line];
        }
        if(i == 7){
            heigth = allBaseViewHeigth;
        }
        
        allBaseViewHeigth = allBaseViewHeigth + tempHeigth;
        sv.contentSize = CGSizeMake(320, allBaseViewHeigth + 200);
    }
    
    UILabel * wishLab = [[UILabel alloc] initWithFrame:CGRectMake(0,heigth,320,25)];
    wishLab.text = @"  愿望与梦想";
    wishLab.font = [UIFont systemFontOfSize:11];
    wishLab.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
    wishLab.backgroundColor = [UIcol hexStringToColor:@"#f2f2f2"];
    [basicsView addSubview:wishLab];

}


-(void)userBtn:(UIButton *)btn{
    switch (btn.tag - 100) {
            case 1:
            case 3:
            case 4:
            case 5:
            case 7:
            case 8:{
                PerSetViewController * psvc = [[PerSetViewController alloc] init];
                psvc.i = btn.tag - 100;
                UILabel * userCommnet = (id)[self.view viewWithTag:btn.tag + 100];
                psvc.str = userCommnet.text;
                [self.navigationController pushViewController:psvc animated:YES];
            }
            break;

        case 2:{
            if(isPicker == NO){
                UILabel * tf = (id)[self.view viewWithTag:202];
                [sv setContentOffset:CGPointMake(0,tf.frame.origin.y) animated:YES];
                datePickerv.center = CGPointMake(160, self.view.bounds.size.height/2);
                isPicker = YES;
            }else{
                datePickerv.center = CGPointMake(1000, self.view.bounds.size.height/2);
                isPicker = NO;
            }
        }
            break;
        case 6:{
            if(isCityPicker == NO){
                UILabel * tf = (id)[self.view viewWithTag:206];
                [sv setContentOffset:CGPointMake(0,tf.frame.origin.y) animated:YES];
                cityPickerv.center = CGPointMake(160, self.view.bounds.size.height/2);
                isCityPicker = YES;
            }else{
                cityPickerv.center = CGPointMake(1000, self.view.bounds.size.height/2);
                isCityPicker = NO;
            }
        }
            break;
        default:
            break;
    }

}



-(void)createNarBar{
    UIView * gj = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    gj.backgroundColor = [UIColor blackColor];
    [self.view addSubview:gj];
    UIView * iv = [[UIView alloc] initWithFrame:CGRectMake(0, 20,320, self.view.bounds.size.height-20)];
    iv.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
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
    
    UIButton * publishBtn = [[UIButton alloc] initWithFrame:CGRectMake(276, 0, 44, 44)];
    [publishBtn addTarget:self action:@selector(saveData) forControlEvents:UIControlEventTouchUpInside];
    UILabel * publishLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    publishLab.text = @"保存";
    publishLab.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    publishLab.shadowOffset = CGSizeMake(1, 0.5);

    publishLab.textColor = [UIColor whiteColor];
    [publishBtn addSubview:publishLab];
    [iv addSubview:publishBtn];

    
    UILabel * titleBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.text = @"资料编辑";
    titleBar.font = [UIFont systemFontOfSize:18];
    titleBar.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    titleBar.shadowOffset = CGSizeMake(1, 0.5);

    titleBar.textAlignment = YES;
    titleBar.textColor = [UIcol hexStringToColor:@"ffffff"];
    [iv addSubview:titleBar];
    
}

-(void)saveData{
    HUD= [[MBProgressHUD alloc] initWithFrame: CGRectMake(0, 0, 320, 320)];
    HUD.labelText = @"加载中";
    [self.view addSubview:HUD];
    [HUD show:YES];
    NSMutableArray * array = [[NSMutableArray alloc] init];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    NSMutableArray * saveUrl = [[NSMutableArray alloc] init];
    NSMutableArray * saveText = [[NSMutableArray alloc] init];
    for (int i = 1;  i < 9; i++) {
        UILabel * label = (id)[self.view viewWithTag:200 + i];
        [saveText addObject:label.text];
    }
    
    for(int i = 0 ; i < _itemArray.count ; i++){
        int number = 999;
        UIButton * btn = _itemArray[i];
        for(int j = 0 ; j < _recordArray.count ;j++){
            UIButton * avatar = _recordArray[j];
            if(btn.tag == avatar.tag){
                number = avatar.tag - 500;
                [array addObject:[NSString stringWithFormat:@"avatar%d.png",i]];
                [dict setObject:photoArray[number] forKey:[NSString stringWithFormat:@"avatar%d.png",i]];
            }
        }
        if(number == 999){
            BmobFile * file = [[BmobFile alloc] initWithClassName:nil withFileName:[NSString stringWithFormat:@"avatar%d.png",i] withFileData:UIImageJPEGRepresentation(btn.imageView.image, 0.8f)];
            [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
                [array addObject:file.name];
                [dict setObject:file.url forKey:file.name];
                if(array.count == _itemArray.count){
                    //                    排序保存
                    NSArray *sortedArray= [array sortedArrayUsingSelector:@selector(compare:)];
                    for (NSString * str in sortedArray) {
                        [saveUrl addObject:[dict objectForKey:str]];
                     }
           
                    BmobQuery * userQuery = [BmobQuery queryForUser];
                    BmobUser * bUser = [BmobUser getCurrentUser];
                    [userQuery getObjectInBackgroundWithId:bUser.objectId block:^(BmobObject *object, NSError *error) {
                        if (!error) {
                            if (object) {
                                BmobObject *obj = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                                [obj setObject:saveUrl[0] forKey:@"avatar"];
                                [obj setObject:saveText[0] forKey:@"nick"];
                                [obj setObject:saveText[1] forKey:@"birthday"];
                                [obj setObject:saveText[2] forKey:@"available"];
                                [obj setObject:saveText[3] forKey:@"school"];
                                [obj setObject:saveText[4] forKey:@"job"];
                                [obj setObject:saveText[5] forKey:@"hometown"];
                                [obj setObject:saveText[6] forKey:@"dream"];
                                [obj setObject:saveText[7] forKey:@"declaration"];
                                [obj setObject:saveUrl forKey:@"album"];

                                [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                   
                                    [HUD removeFromSuperview];
                                    [[NSUserDefaults standardUserDefaults] setObject:saveText[0] forKey:@"nick"];
                                    [[NSUserDefaults standardUserDefaults] setObject:saveUrl[0] forKey:@"avatar"];
                                    NSArray * array = self.navigationController.viewControllers;
                                    friendInfoViewController * fivc = array[array.count - 2];
                                    [basicsComment removeAllObjects];
                                    [self.navigationController popToViewController:fivc animated:YES];
                                    
                                }];
                            }
                        }else{
                        }
                    }];
                }
            }];
        }else{
       
            if(array.count == _itemArray.count){
                //                    排序保存
                NSArray *sortedArray= [array sortedArrayUsingSelector:@selector(compare:)];
                NSMutableArray * saveUrl = [[NSMutableArray alloc] init];
                for (NSString * str in sortedArray) {
                    [saveUrl addObject:[dict objectForKey:str]];
                }
                BmobQuery * userQuery = [BmobQuery queryForUser];
                BmobUser * bUser = [BmobUser getCurrentUser];
                [userQuery getObjectInBackgroundWithId:bUser.objectId block:^(BmobObject *object, NSError *error) {
                    if (!error) {
                        if (object) {
                            BmobObject *obj = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                            [obj setObject:saveUrl[0] forKey:@"avatar"];
                            [obj setObject:saveText[0] forKey:@"nick"];
                            [obj setObject:saveText[1] forKey:@"birthday"];
                            [obj setObject:saveText[2] forKey:@"available"];
                            [obj setObject:saveText[3] forKey:@"school"];
                            [obj setObject:saveText[4] forKey:@"job"];
                            [obj setObject:saveText[5] forKey:@"hometown"];
                            [obj setObject:saveText[6] forKey:@"dream"];
                            [obj setObject:saveText[7] forKey:@"declaration"];
                            [obj setObject:saveUrl forKey:@"album"];
                            
                            [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                [HUD removeFromSuperview];
                                [[NSUserDefaults standardUserDefaults] setObject:saveText[0] forKey:@"nick"];
                                [[NSUserDefaults standardUserDefaults] setObject:saveUrl[0] forKey:@"avatar"];
                                NSArray * array = self.navigationController.viewControllers;
                                friendInfoViewController * fivc = array[array.count - 2];
                                [basicsComment removeAllObjects];
                                [self.navigationController popToViewController:fivc animated:YES];
                            }];
                        }
                    }else{
                    }

                }];
               
            }

            number = 999;
        }
}

}

-(void)goBack{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"放弃编辑资料" message:@"确定放弃编辑个人资料吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 10;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1){
        [basicsComment removeAllObjects];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    datePickerv.center = CGPointMake(1000, self.view.bounds.size.height/2);
    isPicker = NO;
    cityPickerv.center = CGPointMake(1000, self.view.bounds.size.height/2);
    isCityPicker = NO;
    [UIView animateWithDuration:0.3 animations:^{
        sv.frame = sv.frame;
    }];
    
}



@end
