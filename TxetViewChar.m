//
//  TxetViewChar.m
//  DSBBM
//
//  Created by bisheng on 14-12-18.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "TxetViewChar.h"

@implementation TxetViewChar

+(int)textViewCharWish:(NSString *)string{

    int i,n=[string length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[string characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}

@end


