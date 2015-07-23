//
//  MyShowBigPicViewController.m
//  EzvizRealPlayDemo
//
//  Created by liyan on 15/6/29.
//  Copyright (c) 2015年 hikvision. All rights reserved.
//

#import "MyShowBigPicViewController.h"
#import "MyNavigationBar.h"
@interface MyShowBigPicViewController ()

@end

@implementation MyShowBigPicViewController
{
    UIButton * largeImageBtn;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBarHidden = YES;
   self.view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);

    self.navigationItem.hidesBackButton = YES;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

//    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", nil) style:UIBarButtonItemStyleDone target:self action:@selector(finishLoadImage)];
//    rightItem.tintColor = [UIColor blackColor];
//    self.navigationItem.rightBarButtonItem = rightItem;
//    self.view.backgroundColor = [UIColor redColor];
//    NSLog(@"========%f=======%f",self.view.bounds.size.height,self.view.bounds.size.width);
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backpictrue.png"]];
    
  self.view.backgroundColor = [UIColor blackColor];

    
    UIImageView *bigImageView = [[UIImageView alloc] init];
    bigImageView.contentMode = UIViewContentModeScaleAspectFit;
    bigImageView.frame = CGRectMake(0, 0,self.view.bounds.size.width, self.view.bounds.size.height);
    UIImage *image = [UIImage imageNamed:@"pictrue.png"];
    bigImageView.image = image;
    bigImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(finishLoadImage)];
    [bigImageView addGestureRecognizer:singleTap];
    
    [self.view addSubview:bigImageView];
//    [self addTwoLargeBtn];
    
//    UILabel * eventLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 480, 140, 40)];
//    eventLable.backgroundColor=[UIColor clearColor];
//    eventLable.textColor=[UIColor whiteColor];
//    eventLable.textAlignment=NSTextAlignmentCenter;
//    eventLable.font=[UIFont fontWithName:@"Heiti TC" size:36];
//    eventLable.text=@"18:59:21";
//    [self.view addSubview:eventLable];
//    UILabel * eventLable1=[[UILabel alloc]initWithFrame:CGRectMake(10, 502, 90, 40)];
//    eventLable1.backgroundColor=[UIColor clearColor];
//    eventLable1.textColor=[UIColor whiteColor];
//    eventLable1.textAlignment=NSTextAlignmentCenter;
//    eventLable1.font=[UIFont fontWithName:@"Heiti TC" size:12];
//    eventLable1.text=@"2015年6月21日";
//    [self.view addSubview:eventLable1];
    
    MyNavigationBar * myNavigationBar=[[MyNavigationBar alloc]init];
    myNavigationBar.frame=CGRectMake(0, 20, self.view.bounds.size.width, 44);
    [myNavigationBar   createMyNavigationBarWithBackGroundImage:@"" andTitle:@"实时影像" andTitleImageName:@"" andLeftBBIImageName:@"back.png" andRightBBIImageName:@"" andClass:self andSEL:@selector(backClick)];
    
    [self.view addSubview:myNavigationBar];

}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:NO];

}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;

}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
- (void)finishLoadImage
{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addTwoLargeBtn
{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, largeImageBtn.frame.size.height, self.view.bounds.size.width, 56)];
    [self.view addSubview:backView];
    UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(5, self.view.bounds.size.height-51, (self.view.bounds.size.width-15)/2, 46);
    [leftBtn setImage:[UIImage imageNamed:@"greenbtn.png"] forState:UIControlStateNormal];
    [backView addSubview:leftBtn];
    
    UIImageView * leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(55, 14, 21.6, 18)];
    leftImage.image = [UIImage imageNamed:@"cloud.png"];
    [leftBtn addSubview:leftImage];
    UILabel * leftLable = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 80, 26)];
    leftLable.font = [UIFont systemFontOfSize:19];
    leftLable.textColor = [UIColor whiteColor];
    leftLable.text = @"云存储";
    [leftBtn addSubview:leftLable];
    
    
    
    UIButton *rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(10+ leftBtn.frame.size.width, self.view.bounds.size.height-51, (self.view.bounds.size.width-15)/2, 46);
    [rightBtn setImage:[UIImage imageNamed:@"greenbtn.png"] forState:UIControlStateNormal];
    [backView addSubview:rightBtn];
    
    
    UIImageView * rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(65, 11, 18, 22.14)];
    rightImage.image = [UIImage imageNamed:@"delete.png"];
    [rightBtn addSubview:rightImage];
    UILabel * rightLable = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 80, 26)];
    rightLable.font = [UIFont systemFontOfSize:19];
    rightLable.textColor = [UIColor whiteColor];
    rightLable.text = @"删除";
    [rightBtn addSubview:rightLable];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
