//
//  MyShowBigPicViewController.m
//  EzvizRealPlayDemo
//
//  Created by liyan on 15/6/29.
//  Copyright (c) 2015年 hikvision. All rights reserved.
//

#import "MyShowBigPicViewController.h"

@interface MyShowBigPicViewController ()

@end

@implementation MyShowBigPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", nil) style:UIBarButtonItemStyleDone target:self action:@selector(finishLoadImage)];
    rightItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIImageView *bigImageView = [[UIImageView alloc] init];
    bigImageView.contentMode = UIViewContentModeScaleAspectFit;
    bigImageView.frame = CGRectMake(0, 0,self.view.bounds.size.width, self.view.bounds.size.height);
    UIImage *image = [UIImage imageNamed:@"pic.jpg"];
    bigImageView.image = image;
    [self.view addSubview:bigImageView];
}
- (void)finishLoadImage
{
    [self.navigationController popViewControllerAnimated:NO];
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

@end
