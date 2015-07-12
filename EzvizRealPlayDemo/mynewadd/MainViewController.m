//
//  MainViewController.m
//  MediaPlayer
//
//  Created by liyan on 14-6-3.
//  Copyright (c) 2014年 learn. All rights reserved.
//

#import "MainViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MainViewController ()

@end

@implementation MainViewController
{
    MPMoviePlayerViewController * _mpvc;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
     1：媒体播放器即可以播放音频也可以播放视频,视频支持MP4格式
     2：媒体播放器可以播放网络文件和本地文件
     3：媒体播放器是自带界面的
     */
   // NSURL URLWithString:这个后面接网络路径
   //NSURL fileURLWithPath: 这个后面要接本地路径
   _mpvc=[[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/21_02.mp4",[[NSBundle mainBundle] resourcePath]]]];
    _mpvc.view.frame=CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height);
    [self.view addSubview:_mpvc.view];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
