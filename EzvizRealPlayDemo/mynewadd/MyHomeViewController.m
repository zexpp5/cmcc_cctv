//
//  MyHomeViewController.m
//  EzvizRealPlayDemo
//
//  Created by liyan on 15/7/6.
//  Copyright (c) 2015年 hikvision. All rights reserved.
//

#import "MyHomeViewController.h"
#import "MyCollectionViewCell.h"

@interface MyHomeViewController ()

@end

@implementation MyHomeViewController
{
    UICollectionView *collectionV;
    NSArray * section_arr;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);

    self.navigationController.navigationBarHidden = YES;
    

    UIImageView * imageView = [[UIImageView alloc]init];
//    imageView.backgroundColor = [UIColor redColor];
    imageView.image = [UIImage imageNamed:@"spec.png"];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleToFill;
    
    UIButton * startbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startbtn addTarget:self action:@selector(oneTapView) forControlEvents:UIControlEventTouchUpInside];
    startbtn.frame = CGRectMake(0,20, 60, 60);
    [self.view addSubview:startbtn];

  
}
-(void)oneTapView
{
    [self.navigationController popViewControllerAnimated:NO];

}
- (UIImage *)rescaleImageToSize:(CGSize)size {
    
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    [self drawInRect:rect];  // scales image to rect
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resImage;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {

    [super dealloc];
}
@end
