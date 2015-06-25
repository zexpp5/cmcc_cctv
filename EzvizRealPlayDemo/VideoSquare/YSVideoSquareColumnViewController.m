//
//  YSVideoSquareColumnViewController.m
//  EzvizRealPlayDemo
//
//  Created by Journey on 1/19/15.
//  Copyright (c) 2015 hikvision. All rights reserved.
//

#import "YSVideoSquareColumnViewController.h"

#import "YSHTTPClient.h"
#import "YSVideoSquareColumn.h"
#import "YSVideoSquareVideoListViewController.h"

@interface YSVideoSquareColumnViewController ()

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) UIActivityIndicatorView *indicator;

@property (retain, nonatomic) NSMutableArray *columns;

@end

@implementation YSVideoSquareColumnViewController

- (void)searchColumn
{
    [[YSHTTPClient sharedInstance] requestSquareColumnWithComplication:^(id responseObject, NSError *error) {
        if (responseObject)
        {
            NSDictionary *dict = (NSDictionary *)responseObject;
            if (dict)
            {
                NSDictionary *result = [dict objectForKey:@"result"];
                int code = [[result objectForKey:@"code"] intValue];
                if (HTTP_REQUEST_OK_CODE == code)
                {
                    NSArray *data = [result objectForKey:@"data"];
                    for (NSDictionary *columnDict in data)
                    {
                        YSVideoSquareColumn *column = [[YSVideoSquareColumn alloc] init];
                        column.channelCode = [columnDict objectForKey:@"channelCode"];
                        column.channelName = [columnDict objectForKey:@"channelName"];
                        column.channelLevel = [columnDict objectForKey:@"channelLevel"];
                        column.parentId = [columnDict objectForKey:@"parentId"];
                        column.showFlag = [columnDict objectForKey:@"showFlag"];
                        [_columns addObject:column];
                        [column release];
                    }
                   
                    [_tableView setHidden:NO];
                    [_tableView reloadData];
                }
            }
        }
        
        [_indicator stopAnimating];
        [_indicator removeFromSuperview];
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_columns count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierLinear = @"columnCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifierLinear];
    
    if (nil == cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierLinear] autorelease];
    }
    
    YSVideoSquareColumn *column = [_columns objectAtIndex:indexPath.row];
    cell.textLabel.text = column.channelName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSVideoSquareVideoListViewController *controller  = [[YSVideoSquareVideoListViewController alloc] initWithNibName:NSStringFromClass([YSVideoSquareVideoListViewController class])
                                                                                                               bundle:nil];
    controller.column = [_columns objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.columns = [NSMutableArray array];

    [_tableView setHidden:YES];
    
    UIActivityIndicatorView *iv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    iv.center = self.view.center;
    [iv startAnimating];
    [self.view addSubview:iv];
    self.indicator = iv;
    [iv release];
    
    [self searchColumn];
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
    [_tableView release];
    [_columns release];
    [_indicator release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [self setIndicator:nil];
    [super viewDidUnload];
}
@end
