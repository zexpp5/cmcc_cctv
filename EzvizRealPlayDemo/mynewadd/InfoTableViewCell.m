//
//  InfoTableViewCell.m
//  EzvizRealPlayDemo
//
//  Created by liyan on 15/7/6.
//  Copyright (c) 2015年 hikvision. All rights reserved.
//

#import "InfoTableViewCell.h"

@implementation InfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_bigImage release];
    [_infoLable release];
    [_timeLable release];
    [super dealloc];
}
@end
