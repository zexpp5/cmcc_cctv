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
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MyCollectionViewCell" owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }else if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            return nil;
        }else{
            self = [arrayOfViews objectAtIndex:0];
        }
    }
    return self;
}
- (void)dealloc {
    [_infoImge release];
    [_infoLable release];
    [super dealloc];
}
@end
