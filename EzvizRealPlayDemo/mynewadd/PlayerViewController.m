//
//  PlayerViewController.m
//  EzvizRealPlayDemo
//
//  Created by Lance on 12/07/2015.
//  Copyright (c) 2015 hikvision. All rights reserved.
//

#import "PlayerViewController.h"
#import <ALMoviePlayerController/ALMoviePlayerController.h>

#define KSCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define KSCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

@interface PlayerViewController ()<ALMoviePlayerControllerDelegate>
@property (nonatomic, assign) ALMoviePlayerController *moviePlayer;
@property (nonatomic) CGRect defaultFrame;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    // create a movie player
    self.moviePlayer = [[ALMoviePlayerController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.moviePlayer.delegate = self; //IMPORTANT!
    self.moviePlayer.view.alpha = 0.f;

    

    
    ALMoviePlayerControls *movieControls = [[ALMoviePlayerControls alloc] initWithMoviePlayer:self.moviePlayer style:ALMoviePlayerControlsStyleDefault];
    [movieControls setBarColor:[UIColor clearColor]];
    [movieControls setTimeRemainingDecrements:YES];
    [movieControls setFadeDelay:2.0];
    [movieControls setBarHeight:55.f];
    [movieControls setSeekRate:2.f];
    [movieControls setStyle:1];
    [self.moviePlayer setCurrentPlaybackRate:1.0];
    [self.moviePlayer setControls:movieControls];
    [self.view addSubview:self.moviePlayer.view];
    [self.moviePlayer setContentURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/myvideo.mp4",[[NSBundle mainBundle] resourcePath]]]];
    
    
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self configureViewForOrientation:UIInterfaceOrientationLandscapeLeft];
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            self.moviePlayer.view.alpha = 1.f;
        } completion:nil];
    });
  
    [self.moviePlayer setFullscreen:!self.moviePlayer.isFullscreen animated:YES];
    [self configureViewForOrientation:UIInterfaceOrientationLandscapeLeft];

    
}
-(void)finishmovie
{
    [self.moviePlayer stop];
    [self.moviePlayer release];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)configureViewForOrientation:(UIInterfaceOrientation)orientation {
    CGFloat videoWidth = 0;
    CGFloat videoHeight = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        videoWidth = 700.f;
        videoHeight = 535.f;
    } else {
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            videoWidth = KSCREENWIDTH;
            videoHeight = KSCREENHEIGHT;
        } else {
            videoWidth = [[UIScreen mainScreen]bounds].size.width;
            videoHeight = KSCREENWIDTH*(9.0/16.0);
        }
    }
    
    //calulate the frame on every rotation, so when we're returning from fullscreen mode we'll know where to position the movie plauyer
    self.defaultFrame = CGRectMake(self.view.frame.size.width/2 - videoWidth/2, 0, videoWidth, videoHeight);
    
    //only manage the movie player frame when it's not in fullscreen. when in fullscreen, the frame is automatically managed
    if (self.moviePlayer.isFullscreen)
        return;
    
    [self.moviePlayer setFrame:self.defaultFrame];
    
}

- (void)moviePlayerWillMoveFromWindow {
//    if (![self.view.subviews containsObject:self.moviePlayer.view])
//        [self.view addSubview:self.moviePlayer.view];
//    
//    [self.moviePlayer setFrame:self.view.frame];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    [self.moviePlayer stop];
    [self.moviePlayer release];
    [self.navigationController popToRootViewControllerAnimated:NO];

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
