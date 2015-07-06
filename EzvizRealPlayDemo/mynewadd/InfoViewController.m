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
    
    
    self.navigationItem.title = @"报警消息";
    

    UIButton *btnAddDevice = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAddDevice setFrame:CGRectMake(0, 0, 22, 22)];
    [btnAddDevice setTitle:@"清空" forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnAddDevice];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];

    
    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width,480) style:UITableViewStylePlain];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230.0f;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"今天";
    }else
    {
        return @"昨天";

    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellName=@"cell";
    InfoTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"InfoTableViewCell" owner:self options:nil] lastObject ];
    }
    if (indexPath.section == 0) {
        cell.infoLable.text =[section_arr1 objectAtIndex:indexPath.row];
    }else{
        cell.infoLable.text = [section_arr2 objectAtIndex:indexPath.row];
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
