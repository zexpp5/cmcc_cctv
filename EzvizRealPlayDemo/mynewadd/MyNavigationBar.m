//
//  MyNavigationBar.m
//  MyNavigationController
//
//  Created by liyan on 14-4-27.
//  Copyright (c) 2014年 learn. All rights reserved.
//

#import "MyNavigationBar.h"

@implementation MyNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)createMyNavigationBarWithBackGroundImage:(NSString * )backgroundImageName andTitle:(NSString *)title andTitleImageName:(NSString *)titleImageName
{
    //创建背景图
    [self createBackGroundViewWithImageName:backgroundImageName];
    if (title.length>0) {
        //有标题文字
        
        [self createTitleLableWithTitle:title];
    }else{
    //有图片
        [self createTitleViewWithImageName:titleImageName ];
    
    }


}

-(void)createMyNavigationBarWithBackGroundImage:(NSString * )backgroundImageName andTitle:(NSString *)title andTitleImageName:(NSString *)titleImageName andLeftBBIImageName:(NSString *)leftBBIImageName andRightBBIImageName:(NSString *)rightBBIIMageName andClass:(id)classObject andSEL:(SEL)sel
{
    //创建背景图
    [self createBackGroundViewWithImageName:backgroundImageName];
//    self.backgroundColor = [Tools changeColor:@"#46b751"];
    //创建标题
    if (title.length>0) {
        //有标题文字
        
        [self createTitleLableWithTitle:title];
    }else{
        //有图片
        [self createTitleViewWithImageName:titleImageName ];
        
    }
    //创建按钮，判断创建的时哪一侧的按钮
    if (leftBBIImageName.length>0) {
        [self createBBIWithImageName:leftBBIImageName andIsLeft:YES andClassObject:classObject andSEl:sel];
    }
    if (rightBBIIMageName.length>0) {
        [self createBBIWithImageName:rightBBIIMageName andIsLeft:NO andClassObject:classObject andSEl:sel];
    }


}
//单独做背景图
-(void)createBackGroundViewWithImageName:(NSString *)imageName
{
    UIImage * image=[UIImage imageNamed:imageName];
    UIImageView * imageView=[[UIImageView alloc]initWithImage:image];
    //根据新建的时候导航条的大小创建导航条的大小
   // imageView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    imageView.frame=self.bounds;//这样写和上面那样写都行
    [self addSubview:imageView];

}
//创建标题
-(void)createTitleLableWithTitle:(NSString *)title
{
    UILabel * lable=[[UILabel alloc]init];
    lable.frame=self.bounds;
    lable.text=title;
    lable.textAlignment=NSTextAlignmentCenter;
    lable.textColor=[UIColor whiteColor];
    lable.backgroundColor=[UIColor clearColor];
    lable.font = [UIFont fontWithName:@"Heiti SC" size:19];

    [self addSubview:lable];
    

}
//创建标题图片
-(void)createTitleViewWithImageName:(NSString *)tileimagename
{
    UIImage * image=[UIImage imageNamed:tileimagename];
    UIImageView * imageView=[[UIImageView alloc]initWithImage:image];
    imageView.frame=self.bounds;
    imageView.contentMode=UIViewContentModeCenter;//设置图片内容模式为居中。这样图片就不会被拉伸了
    [self addSubview:imageView];


}
//创建UINavigationBar上的按钮
-(void)createBBIWithImageName:(NSString *)imageName andIsLeft:(BOOL)isLeft andClassObject:(id) classObject andSEl:(SEL)sel
{
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * image=[UIImage imageNamed:imageName];
    if (isLeft) {
        //左侧按钮
        btn.frame=CGRectMake(20, 10, 24,24);
        btn.tag=1;//设置左侧按钮默认的tag为1
    }else{
    //右侧按钮
        btn.frame=CGRectMake(self.frame.size.width-10-image.size.width, (self.frame.size.height-image.size.height)/2, image.size.width, image.size.height);
        btn.tag=2;
    
    }
    
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn addTarget:classObject action:sel forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];

}

@end
