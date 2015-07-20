//
//  InfoTableViewCell.h
//  EzvizRealPlayDemo
//
//  Created by liyan on 15/7/6.
//  Copyright (c) 2015年 hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *infoLable;
@property (retain, nonatomic) IBOutlet UILabel *timeLable;
@property (retain, nonatomic) IBOutlet UILabel *nameLable;

@property (retain, nonatomic) IBOutlet UIImageView *bigImage;
@end
