//
//  YSDemoAppDefine.h
//  EzvizRealPlayDemo
//
//  Created by zhengwen zhu on 7/17/14.
//  Copyright (c) 2014 hikvision. All rights reserved.
//

#ifndef EzvizRealPlayDemo_YSDemoAppDefine_h
#define EzvizRealPlayDemo_YSDemoAppDefine_h

#define HTTP_REQUEST_OK_CODE          200

#define UIColorFromRGB(rgbValue, alp)	[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 \
alpha:alp]


#define IS_IOS7_OR_LATER                            ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define AppKey        @"6a68ce26acc54c0fa36f56c53b52c38d"
#define AppSecret     @"598a522d6cdcad88717526194b35fcad"

// 视频播放状态
typedef enum _resultState
{
    ENUM_LOGIN_SUCCESS = 0,  // 登录成功
    ENUM_LOGIN_FAILED,       // 登录失败
    
    ENUM_PLAY_START,         // 准备播放
    ENUM_PLAY_WAITTING,      // 播放开启中
    ENUM_PLAY_SUC,           // 播放成功
    ENUM_PLAY_FAILED,        // 播放失败
    ENUM_STOP_BEFORE,        // 准备停止
    ENUM_STOP,               // 已停止
    ENUM_OFFLINE,            // 设备不在线
    ENUM_RECONNECTING,       // 正在重连
    ENUM_PASSWORD_ERROR,
}RESULT_STATE;


// 当前预览状态
typedef enum _REAL_STATE
{
    REAL_START = 0,    // 准备播放
    REAL_WAITING,      // 播放开启中
    REAL_PLAY,         // 播放中
    REAL_STOP,         // 停止播放
    REAL_OFFLINE,      // 设备不在线
    REAL_UNLOGIN,      // 未登录
}REAL_STATE;



#endif
