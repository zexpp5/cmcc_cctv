//
//  YSVideoSquareVideoListViewController.m
//  EzvizRealPlayDemo
//
//  Created by Journey on 1/20/15.
//  Copyright (c) 2015 hikvision. All rights reserved.
//

#import "YSVideoSquareVideoListViewController.h"

#import "YSHTTPClient.h"
#import "YSVideoSquareVideoInfo.h"
#import "YSVideoSquareColumn.h"
#import "YSVideoSquarePlayingViewController.h"

@interface YSVideoSquareVideoListViewController ()
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) UIActivityIndicatorView *indicator;
@property (retain, nonatomic) NSMutableArray *infos;

@end

@implementation YSVideoSquareVideoListViewController

- (void)searchVideoList
{
    [[YSHTTPClient sharedInstance] requestSquareVideoListWithLongitude:nil
                                                              latitude:nil
                                                                 range:nil
                                                          thirdComment:nil
                                                            cameraName:nil
                                                              viewSort:0
                                                        cameraNameSort:0
                                                             rangeSort:0
                                                               channel:[_column.channelCode integerValue]
                                                              pageFrom:0
                                                              pageSize:100
                                                            complition:^(id responseObject, NSError *error) {
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
                                                                            for (NSDictionary *infoDict in data)
                                                                            {
                                                                                YSVideoSquareVideoInfo *vi = [[YSVideoSquareVideoInfo alloc] init];
                                                                                vi.title = [infoDict objectForKey:@"title"];
                                                                                vi.address = [infoDict objectForKey:@"address"];
                                                                                vi.viewedCount = [[infoDict objectForKey:@"viewedCount"] integerValue];
                                                                                vi.likeCount = [[infoDict objectForKey:@"likeCount"] integerValue];
                                                                                vi.commentCount = [[infoDict objectForKey:@"commentCount"] integerValue];
                                                                                vi.coverUrl = [infoDict objectForKey:@"coverUrl"];
                                                                                vi.playUrl = [infoDict objectForKey:@"playUrl"];
                                                                                [_infos addObject:vi];
                                                                                [vi release];
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
    return [_infos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierLinear = @"columnCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifierLinear];
    
    if (nil == cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierLinear] autorelease];
    }
    
    YSVideoSquareVideoInfo *info = [_infos objectAtIndex:indexPath.row];
    cell.textLabel.text = info.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSVideoSquareVideoInfo *info = [_infos objectAtIndex:indexPath.row];
    
    YSVideoSquarePlayingViewController *controller = [[YSVideoSquarePlayingViewController alloc] initWithNibName:NSStringFromClass([YSVideoSquarePlayingViewController class]) bundle:nil];
    controller.rtspUrl = info.playUrl;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.infos = [NSMutableArray array];
    
    [_tableView setHidden:YES];
    
    UIActivityIndicatorView *iv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    iv.center = self.view.center;
    [iv startAnimating];
    [self.view addSubview:iv];
    self.indicator = iv;
    [iv release];
   
    [self searchVideoList];
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
    [_infos release];
    [_column release];
    [_indicator release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [self setIndicator:nil];
    [super viewDidUnload];
}
@end
