//
//  MyPicTableViewCell.m
//  EzvizRealPlayDemo
//
//  Created by liyan on 15/6/29.
//  Copyright (c) 2015年 hikvision. All rights reserved.
//

#import "MyPicTableViewCell.h"

@implementation MyPicTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    _delegate = nil;
    [_timeLable release];
    [_lineImageView release];
    [_pointImageView release];
    [_PicImageView release];
    [_picBtn release];
    [super dealloc];
}
- (IBAction)clickPicBtn:(id)sender {
    NSLog(@"===btn被点击======");
  if ([self.delegate respondsToSelector:@selector(didClickBigPicButtonInCell:)]) {
        [self.delegate didClickBigPicButtonInCell:self];
    }
}

@end
