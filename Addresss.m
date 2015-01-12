//
//  Addresss.m
//  DSBBM
//
//  Created by 我想要大双眼皮子 on 14-9-24.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "Addresss.h"

@implementation Addresss
+ (NSMutableArray *)queryAddressBook{
    
    NSMutableArray *array=[[NSMutableArray alloc]init];
    ABAddressBookRef addressBooks = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0){
        if (&ABAddressBookCreateWithOptions) {
            CFErrorRef error = nil;
            addressBooks=ABAddressBookCreateWithOptions(NULL, &error);
            
            if (error) {
                NSLog(@"%@",error);
            }
        }
        
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
    }else{
        
        //addressBooks=ABAddressBookCreate();
    }
    
    CFArrayRef allPeople=ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople=ABAddressBookGetPersonCount(addressBooks);
    for (NSInteger i=0; i<nPeople;i++) {
        ABRecordRef person=CFArrayGetValueAtIndex(allPeople, i);
        TKAddressBook *user=[[TKAddressBook alloc]init];
        CFTypeRef abName=ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName=ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil){
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        user.Name=nameString;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        user.Tel = (__bridge NSString*)value;
                        /**
                         * 有可能在电话字符里出现不规则字符
                         *
                         *  @return 电话号码
                         */
                        NSArray *sepArr=[NSArray arrayWithObjects:@")",@"(",@" ",@"-",nil];
                        for(int k=0;k<sepArr.count;k++){
                            user.Tel=[user.Tel stringByReplacingOccurrencesOfString:[sepArr objectAtIndex:k] withString:@""];
                        }
                        
                        break;
                    }
                    case 1: {// Email
                        user.Email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        
        NSData *imageData =(__bridge NSData *)ABPersonCopyImageData(person);
        UIImage *myImage = [UIImage imageWithData:imageData];
        if(myImage!=nil){
            CGSize newSize = CGSizeMake(55, 55);
            UIGraphicsBeginImageContext(newSize);
            [myImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();//上诉代码实现图片压缩，可根据需要选择，现在是压缩到55*55
            user.HeadImg=newImage;
      
        }
        [array addObject:user];
        
    }
    
    return array;
    
}
@end

