//
//  CMyCameraListViewController.m
//  VideoGo
//
//  Created by hikvision hikvision on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CMyCameraListViewController.h"

#import "YSHTTPClient.h"
#import "YSMobilePages.h"
#import "YSPlayerController.h"
#import "YSConstStrings.h"

#import "MyCameraListCell.h"
#import "YSCameraInfo.h"
#import "CPlaybackController.h"
#import "YSDemoDataModel.h"
#import "YSDemoAlarmListViewController.h"
#import "RealPlayViewController.h"
#import "YSShowDeviceCaptureViewController.h"
#import "CSNAddByQRcodeViewController.h"

@interface CMyCameraListViewController () <MyCameraListCellDelegate, UITableViewDataSource,
UITableViewDelegate, UIAlertViewDelegate>
{
}

@property (nonatomic, retain) NSMutableArray *cameraList;
@property (nonatomic, retain) YSMobilePages *mp;

@property (nonatomic, retain) NSMutableDictionary *coverDict;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (retain, nonatomic) IBOutlet UIButton *reloadBtn;

@end

@implementation CMyCameraListViewController


#pragma -
#pragma mark - object
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_cameraList release];
    [_tableView release];
    [_mp release];
    [_coverDict release];
    [_indicator release];
    [_reloadBtn release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _cameraList = [[NSMutableArray alloc] init];
        _coverDict = [[NSMutableDictionary alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cameraCoverRequestDidFinished:)
                                                     name:kRequestCameraCaptureDidFinishedNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceDidAddNotification:)
                                                     name:kAddDeviceSuccessNotification
                                                   object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    self.navigationItem.title = @"摄像机";
    
    UIButton *btnAddDevice = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAddDevice setFrame:CGRectMake(0, 0, 60, 44)];
    [btnAddDevice setTitle:@"+" forState:UIControlStateNormal];
    [btnAddDevice setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnAddDevice.titleLabel.font = [UIFont systemFontOfSize:30];
    [btnAddDevice addTarget:self action:@selector(addDevice) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnAddDevice];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    [[_reloadBtn layer] setBorderWidth:1.0];
    [[_reloadBtn layer] setBorderColor:[UIColor grayColor].CGColor];
    
    [_indicator setHidden:YES];
    [_tableView setHidden:YES];
    
    YSMobilePages *mobilePage = [[YSMobilePages alloc] init];
    self.mp = mobilePage;
    [mobilePage release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self searchCameras];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cameraList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierLinear = @"myCameraListLinearCell";
    
    MyCameraListCell *cell = (MyCameraListCell *)[tableView dequeueReusableCellWithIdentifier:identifierLinear];
    
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCameraListCell" owner:self options:nil] objectAtIndex:0];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    YSCameraInfo *ci = [_cameraList objectAtIndex:indexPath.row];
    
    [cell reloadWithCamera:ci];
    
    UIImage *coverImage = [_coverDict objectForKey:ci.cameraId];
    [cell.coverImgView setImage:coverImage];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        YSCameraInfo *ci = [_cameraList objectAtIndex:indexPath.row];
        [[YSHTTPClient sharedInstance] requestDeleteDeviceWithDeviceId:ci.deviceId complition:^(id responseObject, NSError *error) {
            if (responseObject) {
                NSDictionary *dictionary = (NSDictionary *)responseObject;
                NSNumber *resultCode = [dictionary objectForKey:@"resultCode"];
                if (HTTP_REQUEST_OK_CODE == [resultCode intValue])
                {
                    [_cameraList removeObject:ci];
                    [_tableView reloadData];
                }
            }
        }];
    }
    
}


#pragma mark - MyCameraListCellDelegate


- (void)didClickOnRealPlayButtonInCell:(MyCameraListCell *)cell
{
    RealPlayViewController *realPlayController = [[RealPlayViewController alloc] init];
    realPlayController.cameraInfo = cell.cameraInfo;
    [self.navigationController pushViewController:realPlayController animated:YES];
    [realPlayController release];
}

- (void)didClickOnPlayBackButtonInCell:(MyCameraListCell *)cell
{
    CPlaybackController *playbackController = [[CPlaybackController alloc] initWithNibName:@"CPlaybackController"
                                                                                    bundle:nil
                                                                                    camera:cell.cameraInfo];
    [self.navigationController pushViewController:playbackController animated:YES];
    [playbackController release];
}

- (void)didClickOnLocalPlayButtonInCell:(MyCameraListCell *)cell
{
    YSDemoAlarmListViewController *controller = [[YSDemoAlarmListViewController alloc] initWithNibName:@"YSDemoAlarmListViewController"
                                                                                                bundle:nil
                                                                                              cameraId:cell.cameraInfo.cameraId];
    controller.cameraInfo = cell.cameraInfo;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)didClickOnVoiceMessageButtonInCell:(MyCameraListCell *)cell
{
    [_mp manageDevice:self.navigationController withDeviceId:cell.cameraInfo.deviceId accessToken:[[YSDemoDataModel sharedInstance] userAccessToken]];
}

- (void)didClickOnCaptureInCell:(MyCameraListCell *)cell
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入图片uuid"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
    [alertView release];
}

- (IBAction)reloadList:(id)sender {
    
    [self searchCameras];
}


/**
 *  查询摄像头列表
 *
 */
- (void)searchCameras
{
    if (0 == [[[YSDemoDataModel sharedInstance] userAccessToken] length])
    {
        return;
    }
    
    [[YSHTTPClient sharedInstance] requestSearchCameraListPageFrom:0 pageSize:30 complition:^(id responseObject, NSError *error) {
        if (responseObject) {
            NSDictionary *dictionary = (NSDictionary *)responseObject;
            NSNumber *resultCode = [dictionary objectForKey:@"resultCode"];
            if (HTTP_REQUEST_OK_CODE == [resultCode intValue])
            {
                [self parseCameraList:dictionary];
                
                [_tableView reloadData];
                
                [self captureRealTimeImages];
                
                [_tableView setHidden:NO];
                
            }
            else
            {
                [_reloadBtn setHidden:NO];
            }
        }
        else
        {
            [_reloadBtn setHidden:NO];
        }
        
        [_indicator setHidden:YES];
        [_indicator stopAnimating];
    }];
    
    [_reloadBtn setHidden:YES];
    [_tableView setHidden:YES];
    [_indicator setHidden:NO];
    [_indicator startAnimating];
}

- (void)parseCameraList:(NSDictionary *)dictionary
{
    [_cameraList removeAllObjects];

    NSArray *array = [dictionary objectForKey:@"cameraList"];
    for (int i = 0; i < [array count]; i++)
    {
        YSCameraInfo *camera = [[YSCameraInfo alloc] init];
        NSDictionary *dic = [array objectAtIndex:i];
        [camera setCameraFromDict:dic];
        [_cameraList addObject:camera];
        [camera release];
    }
}

- (void)login
{
    [_mp login:self.navigationController withAppKey:AppKey complition:^(NSString *accessToken) {
        if (accessToken)
        {
            NSLog(@"Client access token is: %@", accessToken);
            [[YSDemoDataModel sharedInstance] saveUserAccessToken:accessToken];
            [[YSHTTPClient sharedInstance] setClientAccessToken:accessToken];
        }
    }];

}

- (void)addDevice {
    CSNAddByQRcodeViewController * snScanViewController = [[CSNAddByQRcodeViewController alloc] initWithNibName:@"CSNAddByQRcodeViewController"
                                                                                                         bundle:nil];
    [self.navigationController pushViewController:snScanViewController animated:YES];
    [snScanViewController release];
}

- (void)captureRealTimeImages
{
    NSMutableArray *arrayId = [NSMutableArray array];
    for (YSCameraInfo *ci in _cameraList)
    {
        [arrayId addObject:ci.cameraId];
    }
    
    if (0 != [arrayId count])
    {
        [YSPlayerController requestCapturesWithCameraId:arrayId];
    }
}

- (void)cameraCoverRequestDidFinished:(NSNotification *)notification
{
    NSDictionary *dict = [notification object];
    if (dict)
    {
        [_coverDict addEntriesFromDictionary:dict];
        
        [_tableView reloadData];
    }
}

- (void)deviceDidAddNotification:(NSNotification *)notification
{
    // 开发者根据实际需要控制跳转
    [self.navigationController popViewControllerAnimated:YES];
    
    NSString *deviceId = [notification object];
    
    NSLog(@"device: %@ did add.", deviceId);
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        NSString *uuid = [alertView textFieldAtIndex:0].text;
        [[YSHTTPClient sharedInstance] requestGetDevicePictureWithUUID:uuid imageWidth:200 complication:^(id responseObject, NSError *error) {
            
            UIImage *capture = (UIImage *)responseObject;
            
            if (capture)
            {
               YSShowDeviceCaptureViewController *controller = [[YSShowDeviceCaptureViewController alloc] initWithNibName:@"YSShowDeviceCaptureViewController" bundle:nil];
                controller.image = capture;
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
            else
            {
                NSLog(@"error msg:%@, error code:%d", error.domain, error.code);
            }
        }];
    }

}


- (void)viewDidUnload {
    [self setIndicator:nil];
    [self setReloadBtn:nil];
    [super viewDidUnload];
}
@end
