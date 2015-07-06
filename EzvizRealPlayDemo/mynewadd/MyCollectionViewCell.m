//
//  MyCollectionViewCell.m
//  EzvizRealPlayDemo
//
//  Created by liyan on 15/7/6.
//  Copyright (c) 2015年 hikvision. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)dealloc {
    [_infoImge release];
    [_infoLable release];
    [super dealloc];
}
@end
