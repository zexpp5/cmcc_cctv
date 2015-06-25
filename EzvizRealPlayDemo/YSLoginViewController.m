//
//  YSLoginViewController.m
//  EzvizRealPlayDemo
//
//  Created by Journey on 12/8/14.
//  Copyright (c) 2014 hikvision. All rights reserved.
//

#import "YSLoginViewController.h"

#import "YSHTTPClient.h"
#import "YSMobilePages.h"
#import "YSPlayerController.h"
#import "YSConstStrings.h"

#import "YSDemoDataModel.h"
#import "YSCheckSMSCodeViewController.h"
#import "CMyCameraListViewController.h"
#import "YSVideoSquareColumnViewController.h"

@interface YSLoginViewController () <UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UIButton *btnSDKLogin;

@property (retain, nonatomic) IBOutlet UIButton *btnCheckCode;

@property (retain, nonatomic) IBOutlet UIButton *btnVideoSquare;

@property (retain, nonatomic) YSMobilePages *page;

@end

@implementation YSLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    YSMobilePages *mp = [[YSMobilePages alloc] init];
    self.page = mp;
    [mp release];
}

- (IBAction)clickOnLogin:(id)sender {
    [self login];
}

- (IBAction)clickOnCheck:(id)sender {
    YSCheckSMSCodeViewController *controller = [[YSCheckSMSCodeViewController alloc] initWithNibName:@"YSCheckSMSCodeViewController"
                                                                                              bundle:nil];
    controller.type = RegisteCheck;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)clickOnCameraList:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"请输入Token"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    [alert release];
}

- (IBAction)clickVideoSquare:(id)sender {
    YSVideoSquareColumnViewController *controller = [[YSVideoSquareColumnViewController alloc] initWithNibName:NSStringFromClass([YSVideoSquareColumnViewController class])
                                                                                                        bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


- (void)login
{
//    NSString *pbApiKey = @"99bec62406534c6787323575c87d5ef4";
//    NSString *testApiKey = @"e503c597aba04b5487a3d06572a4bbe4";
//    NSString *openApiKey = @"8698d52f6ac34929b5286698fe7a10e8";
//    NSString *test_1_apiKey = @"c279ded87d3f4fdca7658f95fb5f1d9e";
    
    [_page login:self.navigationController withAppKey:AppKey complition:^(NSString *accessToken) {
        if (accessToken)
        {
            NSLog(@"Client access token is: %@", accessToken);
            [[YSDemoDataModel sharedInstance] saveUserAccessToken:accessToken];
            [[YSHTTPClient sharedInstance] setClientAccessToken:accessToken];
        }
        
        [self.navigationController popViewControllerAnimated:NO];
        
        [self pushCameraListController];
    }];
    
}

- (void)pushCameraListController
{
    CMyCameraListViewController *controller = [[CMyCameraListViewController alloc] initWithNibName:@"CMyCameraListViewController"
                                                                                            bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)dealloc {
    [_btnSDKLogin release];
    [_btnCheckCode release];
    [_page release];
    
    [_btnVideoSquare release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBtnSDKLogin:nil];
    [self setBtnCheckCode:nil];
    [self setBtnVideoSquare:nil];
    [super viewDidUnload];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *accessToken = [alertView textFieldAtIndex:0].text;
    
    if (0 == [accessToken length]) {
        return;
    }
    
    [[YSDemoDataModel sharedInstance] saveUserAccessToken:accessToken];
    [[YSHTTPClient sharedInstance] setClientAccessToken:accessToken];
    
    [self pushCameraListController];
}

@end
