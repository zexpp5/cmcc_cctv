//
//  YSCloudRecordInfo.m
//  EzvizRealPlayDemo
//
//  Created by zhengwen zhu on 7/17/14.
//  Copyright (c) 2014 hikvision. All rights reserved.
//

#import "YSCloudRecordInfo.h"

@implementation YSCloudRecordInfo

- (void)dealloc
{
    [_fileId release];
    [_startTime release];
    [_stopTime release];
    
    [super dealloc];
}

@end
