//
//  TKAddressBook.h
//  DSBBM
//
//  Created by 我想要大双眼皮子 on 14-9-24.
//  Copyright (c) 2014年 qt. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface TKAddressBook : NSObject
@property NSInteger SectionNumber;
@property NSInteger RecordID;
@property (nonatomic, retain) NSString *Name;
@property (nonatomic, retain) NSString *Email;
@property (nonatomic, retain) NSString *Tel;
@property (nonatomic,retain)UIImage *HeadImg;
@end
