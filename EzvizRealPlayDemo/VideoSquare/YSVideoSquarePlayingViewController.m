//
//  YSVideoSquarePlayingViewController.m
//  EzvizRealPlayDemo
//
//  Created by Journey on 1/20/15.
//  Copyright (c) 2015 hikvision. All rights reserved.
//

#import "YSVideoSquarePlayingViewController.h"

#import "YSPlayerController.h"

@interface YSVideoSquarePlayingViewController () <YSPlayerControllerDelegate>
@property (retain, nonatomic) IBOutlet UIView *playingView;
@property (retain, nonatomic) IBOutlet UILabel *lblUrl;

@property (retain, nonatomic) YSPlayerController *player;

@end

@implementation YSVideoSquarePlayingViewController


#pragma mark - YSPlayerControllerDelegate

- (void)playerOperationMessage:(YSPlayerMessageType)msgType withValue:(id)value
{
    switch (msgType)
    {
        case YSPlayerMsgSoundUnvailable:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"该视频不支持播放声音"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
            break;
       case YSPlayerMsgRealPlayFail:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[NSString stringWithFormat:@"播放失败(%d)", [((NSNumber *)value) intValue]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
            break;
        default:
            break;
    }
}

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [_playingView setBackgroundColor:[UIColor blackColor]];
   
    _lblUrl.text = _rtspUrl;
    
    _player = [[YSPlayerController alloc] initWithDelegate:self];
    [_player startRealPlayWithURLString:_rtspUrl inView:_playingView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_player stopRealPlay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)openAudio:(id)sender {
    [_player setAudioOpen:YES];
}


- (void)dealloc {
    [_playingView release];
    [_rtspUrl release];
    _player.delegate = nil;
    [_player stopRealPlay];
    [_player release];
    [_lblUrl release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPlayingView:nil];
    [self setLblUrl:nil];
    [super viewDidUnload];
}
@end
