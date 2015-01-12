//
//  SearchTableViewCell.h
//  DSBBM
//
//  Created by 我想要大双眼皮子 on 14-9-26.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchTableViewCellGuanzhuDelegate <NSObject>

- (void)guanzhuOnclickWithUseName:(NSString *)name UseId:(NSString *)userId;

@end


@interface SearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;
@property (weak, nonatomic) IBOutlet UILabel *searchName;
//分割线
@property (strong, nonatomic) IBOutlet UIView *line;

@property (nonatomic, copy)NSString *userId;
@property (nonatomic, weak)id <SearchTableViewCellGuanzhuDelegate> delegate;

@end
