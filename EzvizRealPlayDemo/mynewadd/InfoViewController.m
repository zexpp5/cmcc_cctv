//
//  InfoViewController.m
//  EzvizRealPlayDemo
//
//  Created by liyan on 15/7/6.
//  Copyright (c) 2015年 hikvision. All rights reserved.
//

#import "InfoViewController.h"
#import "InfoTableViewCell.h"
#import "MyShowBigPicViewController.h"



@interface InfoViewController ()

@end

@implementation InfoViewController
{
    NSArray * section_arr1;
    NSArray * section_arr2;


}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    self.navigationItem.title = @"报警消息";
    UIColor *color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    
    UIImage *backgroundImage = [self imageWithColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    
    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    self.automaticallyAdjustsScrollViewInsets=NO;
    tableView.separatorStyle=NO;
    
    tableView.showsVerticalScrollIndicator = NO;

    
    
    section_arr1=[[NSMutableArray alloc]initWithObjects:@"19:59:21",@"09:59:21",@"19:23:21",nil];
    section_arr2=[[NSMutableArray alloc]initWithObjects:@"05:33:21",@"11:59:21",@"19:11:21", nil];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{

}
-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(void)backBtn
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)dealloc
{
    [section_arr1 release];
    [section_arr2 release];
    [super dealloc];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 232.0f;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellName=@"cell";
    InfoTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"InfoTableViewCell" owner:self options:nil] lastObject ];
    }
       return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyShowBigPicViewController * showBigPicViewController = [[MyShowBigPicViewController alloc] init];
    [self.navigationController pushViewController:showBigPicViewController animated:NO];
    [showBigPicViewController release];
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
