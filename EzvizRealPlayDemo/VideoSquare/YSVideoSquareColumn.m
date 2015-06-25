//
//  YSVideoSquareColumn.m
//  EzvizRealPlayDemo
//
//  Created by Journey on 1/19/15.
//  Copyright (c) 2015 hikvision. All rights reserved.
//

#import "YSVideoSquareColumn.h"

@implementation YSVideoSquareColumn

- (void)dealloc
{
    [_channelCode release];
    [_channelName release];
    [_channelLevel  release];
    [_parentId release];
    [_showFlag release];
    
    [super dealloc];
}

@end
