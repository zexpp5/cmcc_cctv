//
//  YSMobilePages.h
//  EzvizRealPlay
//
//  Created by zhengwen zhu on 7/12/14.
//  Copyright (c) 2014 yudan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  登录成功回调
 *
 *  @param accessToken 如果登录成功, 返回token字符串; 反之, 返回nil.
 *
 *  @since v1.0.0.0
 */
typedef void (^LoginBlock)(NSString *accessToken);

/**
 *  中间页
 *
 *  @since v1.0.0.0
 */
@interface YSMobilePages : NSObject

/**
 *  登录页面
 *
 *  @param navController 控制器
 *  @param keyValue      应用程序id
 *  @param block         登录回调
 *
 *  @since v1.0.0.0
 */
- (void)login:(UINavigationController *)navController withAppKey:(NSString *)keyValue complition:(LoginBlock)block;

/**
 *  添加设备页面
 *
 *  @param navController
 *  @param token         用户登录 token
 *  @param did            设备唯一标识符
 *  @param sf            设备加密秘钥
 */
- (void)addDevice:(UINavigationController *)navController
  withAccessToken:(NSString *)token
         deviceId:(NSString *)did
          safeKey:(NSString *)sf;

/**
 *  操作设备页面
 *
 *  @param navController
 *  @param did           设备的id
 *  @param token         登录成功返回的token
 *
 *  @since v1.0.0.0
 */
- (void)manageDevice:(UINavigationController *)navController withDeviceId:(NSString *)did accessToken:(NSString *)token;

@end
