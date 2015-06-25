//
//  YSVideoSquareVideoInfo.m
//  EzvizRealPlayDemo
//
//  Created by Journey on 1/19/15.
//  Copyright (c) 2015 hikvision. All rights reserved.
//

#import "YSVideoSquareVideoInfo.h"

@implementation YSVideoSquareVideoInfo

- (void)dealloc
{
    [_title release];
    [_address release];
    [_coverUrl release];
    [_playUrl release];
    
    [super dealloc];
}

@end
