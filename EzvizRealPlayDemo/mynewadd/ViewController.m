//
//  ViewController.m
//  LNPlayer
//
//  Created by KuiYin on 15-2-11.
//  Copyright (c) 2015年 LarkNan. All rights reserved.
//
//  其中3、4、5代表的是屏幕方向  因为是枚举用数字代表下代码简洁一点
//  但这样可读性不强，我暂时就这样写了。

#import <MediaPlayer/MediaPlayer.h>
#import "ViewController.h"

//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()
{
    MPMoviePlayerViewController *_moviePlayer;
    long _oldDirection;//旧方向
    long _currentDirection;//当前方向
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //屏幕转动通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transContro:) name:UIDeviceOrientationDidChangeNotification object:nil];
//    [self addBut];
    [self playVideo];
}

- (void)addBut
{
    UIButton *but = [[UIButton alloc]init];
    but.frame = CGRectMake(100, 100, 100, 100);
    [but setTitle:@"播放视频" forState:UIControlStateNormal];
    [but setBackgroundColor:[UIColor greenColor]];
    [but addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: but];
}

#pragma mark 创建并播放视频
- (void)playVideo
{
//    NSString *url = @"http://video.qinghi.com/zhegeshijiezenmele.mp4";
//    _moviePlayer = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:url]];
       _moviePlayer=[[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/myvideo.mp4",[[NSBundle mainBundle] resourcePath]]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDone) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    _moviePlayer.modalTransitionStyle = MPMovieControlStyleFullscreen;
    _moviePlayer.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [self presentMoviePlayerViewControllerAnimated:_moviePlayer];
    _moviePlayer.moviePlayer.scalingMode = MPMovieScalingModeNone;
    [_moviePlayer.moviePlayer play];
}

#pragma mark 播放完成
- (void)playDone
{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
//    _moviePlayer = nil;
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark 屏幕旋转
- (void)transContro:(NSNotification *)notification
{
    _currentDirection = [[UIDevice currentDevice] orientation];
    
    if (_oldDirection != _currentDirection) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
                if (_oldDirection != 3 && _oldDirection != 5) {
                    _moviePlayer.view.frame = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
                    _moviePlayer.view.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
                }
                CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(M_PI_2 * 3);
                _moviePlayer.view.transform = landscapeTransform;
                
                _oldDirection = UIDeviceOrientationLandscapeRight;
            }
            if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
                if (_oldDirection != 4 && _oldDirection != 5) {
                    _moviePlayer.view.frame = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
                    _moviePlayer.view.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
                }
                CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(M_PI_2);
                _moviePlayer.view.transform = landscapeTransform;
                
                _oldDirection = UIDeviceOrientationLandscapeLeft;
            }
            if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
                CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(0.0);
                _moviePlayer.view.transform = landscapeTransform;
                _moviePlayer.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                _moviePlayer.view.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
                
                _oldDirection = UIDeviceOrientationPortrait;
            }
            if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
                CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(M_PI);
                _moviePlayer.view.transform = landscapeTransform;
                _moviePlayer.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                _moviePlayer.view.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
                
                _oldDirection = UIDeviceOrientationPortraitUpsideDown;
            }
        } completion:^(BOOL finished) {
            nil;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
