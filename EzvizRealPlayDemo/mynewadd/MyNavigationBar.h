//
//  MyNavigationBar.h
//  MyNavigationController
//
//  Created by liyan on 14-4-27.
//  Copyright (c) 2014年 learn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNavigationBar : UIView
//自定义按钮
-(void)createMyNavigationBarWithBackGroundImage:(NSString * )backgroundImageName andTitle:(NSString *)title andTitleImageName:(NSString *)titleImageName;


-(void)createMyNavigationBarWithBackGroundImage:(NSString * )backgroundImageName andTitle:(NSString *)title andTitleImageName:(NSString *)titleImageName andLeftBBIImageName:(NSString *)leftBBIImageName andRightBBIImageName:(NSString *)rightBBIIMageName andClass:(id)classObject andSEL:(SEL)sel;


@end
