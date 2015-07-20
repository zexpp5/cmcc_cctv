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
#import "MyPicTableViewCell.h"
#import "MyShowBigPicViewController.h"
#import "MyHomeViewController.h"
#import "InfoViewController.h"
#import "MainViewController.h"
#import "ViewController.h"
#import <PlayerViewController.h>

@interface CMyCameraListViewController () <MyCameraListCellDelegate, UITableViewDataSource,
UITableViewDelegate, UIAlertViewDelegate,MyPicListCellDelegate>
{
}

@property (nonatomic, retain) NSMutableArray *cameraList;
@property (nonatomic, retain) YSMobilePages *mp;

@property (nonatomic, retain) NSMutableDictionary *coverDict;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (retain, nonatomic) IBOutlet UIButton *reloadBtn;

@end

@implementation CMyCameraListViewController

{
    UIButton * largeImageBtn;
    YSCameraInfo          *cameraInfo;               // 当前正在播放的摄像机信息
    NSMutableArray * _timeArrayList;

}
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
    [_timeArrayList release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _cameraList = [[NSMutableArray alloc] init];
        _coverDict = [[NSMutableDictionary alloc] init];
        _timeArrayList = [[NSMutableArray alloc]init];
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
    

    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
//    self.navigationItem.title = @"我的设备";
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 22, 22)];
    //    [btnAddDevice setTitle:@"+" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(myhomeview) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"home_icon_02"] forState:UIControlStateNormal];
    UIBarButtonItem *lestItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = lestItem;
    [lestItem release];
    
    
    UIButton *btnAddDevice = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAddDevice setFrame:CGRectMake(0, 0, 22, 22)];
//    [btnAddDevice setTitle:@"+" forState:UIControlStateNormal];
    [btnAddDevice setBackgroundImage:[UIImage imageNamed:@"home_icon_01"] forState:UIControlStateNormal];
    [btnAddDevice addTarget:self action:@selector(addDevice) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnAddDevice];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    [[_reloadBtn layer] setBorderWidth:1.0];
    [[_reloadBtn layer] setBorderColor:[UIColor grayColor].CGColor];
    
    [_indicator setHidden:YES];
    [_tableView setHidden:NO];
    
    _tableView.frame = CGRectMake(0, 205+56, self.view.bounds.size.width, self.view.bounds.size.height-200);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addLargeImageView];//新加的大图片
    [self addTwoLargeBtn];
//     [_timeArrayList addObjectsFromArray:@[@"19:59",@"18:57",@"11:03",@"08:58"] ];
    [_timeArrayList addObjectsFromArray:@[@"19:59:01",@"19:57:08",@"16:42:03",@"16:32:06"] ];

    YSMobilePages *mobilePage = [[YSMobilePages alloc] init];
    self.mp = mobilePage;
    [mobilePage release];
}
-(void)myhomeview
{
    MyHomeViewController * homeVC = [[MyHomeViewController alloc]init];
    [self.navigationController pushViewController:homeVC animated:NO];
    [homeVC release];
}
-(void)addTwoLargeBtn
{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, largeImageBtn.frame.size.height, self.view.bounds.size.width, 56)];
    [self.view addSubview:backView];
     UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(5, 5, (self.view.bounds.size.width-15)/2, 46);
    [leftBtn setImage:[UIImage imageNamed:@"greenbtn.png"] forState:UIControlStateNormal];
    [backView addSubview:leftBtn];
    
    UIImageView * leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 14, 18, 18)];
    leftImage.image = [UIImage imageNamed:@"jikong.png"];
   [leftBtn addSubview:leftImage];
    UILabel * leftLable = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, 80, 26)];
    leftLable.font = [UIFont systemFontOfSize:15];
    leftLable.textColor = [UIColor whiteColor];
    leftLable.text = @"监测开启";
    [leftBtn addSubview:leftLable];

    

    UIButton *rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(10+ leftBtn.frame.size.width, 5, (self.view.bounds.size.width-15)/2, 46);
    [rightBtn setImage:[UIImage imageNamed:@"greenbtn.png"] forState:UIControlStateNormal];
    [backView addSubview:rightBtn];
    
    
    UIImageView * rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 14, 18, 18)];
    rightImage.image = [UIImage imageNamed:@"refresh.png"];
    [rightBtn addSubview:rightImage];
    UILabel * rightLable = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, 80, 26)];
    rightLable.font = [UIFont systemFontOfSize:15];
    rightLable.textColor = [UIColor whiteColor];
    rightLable.text = @"刷新影像";
    [rightBtn addSubview:rightLable];
}
-(void)addLargeImageView
{
    largeImageBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    largeImageBtn.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
//    [largeImageBtn setTitle:@"直播" forState:UIControlStateNormal];
    largeImageBtn.backgroundColor = [UIColor grayColor];
//    [largeImageBtn addTarget:self action:@selector(oneTapView) forControlEvents:UIControlEventTouchUpInside];
    [largeImageBtn setImage:[UIImage imageNamed:@"first.jpg"] forState:UIControlStateNormal];

    [self.view addSubview:largeImageBtn];
    
    
    UIButton * startbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startbtn addTarget:self action:@selector(oneTapView) forControlEvents:UIControlEventTouchUpInside];
     startbtn.frame = CGRectMake((largeImageBtn.bounds.size.width-58)/2, (largeImageBtn.bounds.size.height-58)/2, 58, 58);
    [startbtn setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    [largeImageBtn addSubview:startbtn];
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
-(void)oneTapView//:(UIRotationGestureRecognizer *)sender
{
//    RealPlayViewController *realPlayController = [[RealPlayViewController alloc] init];
//    if (_cameraList.count) {
//        YSCameraInfo *ci = [_cameraList objectAtIndex:0];
//        cameraInfo= ci;
//    }
//    realPlayController.cameraInfo = cameraInfo;
//    [self.navigationController pushViewController:realPlayController animated:YES];
//    [realPlayController release];
    
    
//    ViewController * mvc = [[ViewController alloc]init];
    
    
    PlayerViewController * mvc = [[PlayerViewController alloc] init];
    
    
    [self.navigationController pushViewController:mvc animated:NO];
    [mvc release];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"我的设备";
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    UIImage *backgroundImage = [self imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
//    [self searchCameras];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [_cameraList count];
   return  4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identifierLinear = @"myCameraListLinearCell";
//    
//    MyCameraListCell *cell = (MyCameraListCell *)[tableView dequeueReusableCellWithIdentifier:identifierLinear];
//    
//    if (nil == cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCameraListCell" owner:self options:nil] objectAtIndex:0];
//    }
//
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.delegate = self;
//    YSCameraInfo *ci = [_cameraList objectAtIndex:indexPath.row];
//    
//    [cell reloadWithCamera:ci];
//    
//    UIImage *coverImage = [_coverDict objectForKey:ci.cameraId];
//    [cell.coverImgView setImage:coverImage];
//    if (indexPath.row == 0) {
//        [largeImageBtn setImage:coverImage forState:UIControlStateNormal];
//        cameraInfo = cell.cameraInfo;
//        NSLog(@"===显示大图片====");
//    }
    static NSString *identifierLinear = @"myCameraListLinearCell";
    
    MyPicTableViewCell *cell = (MyPicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifierLinear];
    
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyPicTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.timeLable.text = [_timeArrayList objectAtIndex:indexPath.row];
//    cell.dateLable.text = @"6月21日";
    cell.picBtn.tag = indexPath.row;
    if (indexPath.row == 1) {
        cell.jingbaoImageView.image = [UIImage imageNamed:@"jingbaochudong.png"];
    }
    
    return cell;
}

-(void)addLargeIMageVideo{
    if (_cameraList.count>0) {
        YSCameraInfo *ci = [_cameraList objectAtIndex:0];
        UIImage *coverImage = [_coverDict objectForKey:ci.cameraId];
        [largeImageBtn setImage:coverImage forState:UIControlStateNormal];
    }
}
- (void)didClickBigPicButtonInCell:(MyPicTableViewCell *)cell
{
    MyShowBigPicViewController * showBigPicViewController = [[MyShowBigPicViewController alloc] init];
    [self.navigationController pushViewController:showBigPicViewController animated:NO];
    [showBigPicViewController release];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 98;
    return 180;
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
                
//                [_tableView reloadData];
                [self addLargeIMageVideo];
                
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
//    CSNAddByQRcodeViewController * snScanViewController = [[CSNAddByQRcodeViewController alloc] initWithNibName:@"CSNAddByQRcodeViewController"
//                                                                                                         bundle:nil];
//    [self.navigationController pushViewController:snScanViewController animated:YES];
//    [snScanViewController release];
    InfoViewController * infoVC = [[InfoViewController alloc]init];

    [self.navigationController pushViewController:infoVC animated:NO];
    [infoVC release];
    
    
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
