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
    self.view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);

    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
 
//    self.navigationItem.title = @"报警消息";
    
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"报警消息"];
    customLab.font = [UIFont fontWithName:@"Heiti SC" size:19];
    self.navigationItem.titleView = customLab;
    [customLab release];
    
    
    
    
    UIColor *color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    
    UIImage *backgroundImage = [self imageWithColor:[UIColor colorWithRed:25.0 / 255.0 green:33.0/ 255.0 blue:44.0/255.0 alpha:alphaStage]];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    
    UIButton *leftAddDevice = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftAddDevice setFrame:CGRectMake(0, 0, 11, 19.7)];
    [leftAddDevice setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftAddDevice addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftAddDevice];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
    
    
    UIButton *btnAddDevice = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAddDevice setFrame:CGRectMake(0, 0, 30, 22)];
    [btnAddDevice setTitle:@"清空" forState:UIControlStateNormal];
    btnAddDevice.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:15];
   [btnAddDevice addTarget:self action:@selector(qingli) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnAddDevice];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    
    
    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height-20) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    self.automaticallyAdjustsScrollViewInsets=NO;
    tableView.separatorStyle=NO;
    
    tableView.showsVerticalScrollIndicator = NO;

    
    
    section_arr1=[[NSMutableArray alloc]initWithObjects:@"19:59:21",@"19:32:21",@"15:23:29",nil];
    UIPanGestureRecognizer * pan=[[UIPanGestureRecognizer alloc]init];
    [pan addTarget:self action:@selector(pan:)];
//    [self.view addGestureRecognizer:pan];
    
    // Do any additional setup after loading the view.
}
-(void)pan:(UIPanGestureRecognizer *)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)qingli
{

}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;


}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//
//}



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
    return 2;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIImageView * imageView=[[UIImageView alloc]init];
    imageView.frame=CGRectMake(0, 0, tableView.frame.size.width, 40);
    imageView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:alphaStage];
    UILabel * lable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    lable.backgroundColor=[UIColor clearColor];
    lable.textColor=[UIColor blackColor];
    lable.textAlignment=NSTextAlignmentCenter;

    lable.font = [UIFont fontWithName:@"Heiti SC" size:16];

    if (section==0) {
        lable.text=@"- 今天 -";
    }else{
        lable.text=@"- 6月21日 -";
    }
    [imageView addSubview:lable];
    return imageView;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160.0f;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellName=@"cell";
    InfoTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"InfoTableViewCell" owner:self options:nil] lastObject ];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.timeLable.text = nil;
    cell.timeLable.text = [section_arr1 objectAtIndex:indexPath.row];
    cell.timeLable.font = [UIFont fontWithName:@"Heiti SC" size:18];
    cell.nameLable.font = [UIFont fontWithName:@"Heiti SC" size:13];
    [cell.timeLable setTextColor:[UIColor colorWithRed:102.0 / 255.0 green:102.0/255.0 blue:102.0/255.0 alpha:alphaStage]];
    cell.bigImage.layer.cornerRadius = 6;
    cell.bigImage.layer.masksToBounds = YES;
    cell.blakBackgroundIMage.layer.cornerRadius = 6;
    cell.blakBackgroundIMage.layer.masksToBounds = YES;
    if (indexPath.row == 1 ) {
        cell.smallImage.image = [UIImage imageNamed:@"baojingxiaoxi.png"];
        cell.bigImage.image = [UIImage imageNamed:@"picture11.png"];
        [cell.timeLable setTextColor:[UIColor colorWithRed:223.0 / 255.0 green:83.0/255.0 blue:97.0/255.0 alpha:alphaStage]];
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
