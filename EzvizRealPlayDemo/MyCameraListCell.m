//
//  MyCameraListCell.m
//  VideoGo
//
//  Created by zhengwen zhu on 10/14/13.
//
//

#import "MyCameraListCell.h"
#import "YSCameraInfo.h"

#define CAMERA_NAME_HEIGHT                   30
#define CAMERA_COVER_HEIGHT                  100
#define CAMERA_FUNCGION_BUTTON_HEIGHT        50
#define CELL_EDGE_SPACE                      10
#define CELL_INSIDE_SPACE                    5


@implementation MyCameraListCell

@synthesize cameraInfo = _cameraInfo;
@synthesize delegate = _delegate;

@synthesize containerView = _containerView;
@synthesize bgImageView = _bgImageView;
@synthesize cameraNameLbl = _cameraNameLbl;
@synthesize coverImgView = _coverImgView;
@synthesize coverView = _coverView;
@synthesize offLineLbl = _offLineLbl;
@synthesize offLineImageView = _offLineImageView;
@synthesize realPlayButton = _realPlayButton;
@synthesize playBackButton = _playBackButton;
@synthesize localPlayButton = _localPlayButton;
@synthesize voiceMessageButton = _voiceMessageButton;
@synthesize firstSeporatorView = _firstSeporatorView;
@synthesize seconfSeporatorView = _secondSeporatorView;

/**
 *  初始化
 *
 *  @param style           单元格风格
 *  @param reuseIdentifier 复用标识
 *  @param theCameraInfo   关联摄像机对象
 *
 *  @return MyCameraListCell
 */
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
     withCameraInfo:(YSCameraInfo *)theCameraInfo
{
    if (nil == theCameraInfo) {
        return nil;
    }
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cameraInfo = theCameraInfo;
    }
    
    return self;
}

- (void)dealloc
{
    _delegate = nil;
    [_cameraInfo release];
    [_bgImageView release];
    [_cameraNameLbl release];
    [_coverView release];
    [_coverImgView release];
    [_offLineLbl release];
    [_offLineImageView release];
    [_realPlayButton release];
    [_playBackButton release];
    [_localPlayButton release];
    [_voiceMessageButton release];
    [_firstSeporatorView release];
    [_secondSeporatorView release];
    
    [_capture release];
    [super dealloc];
}

#pragma mark - Public

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)reloadWithCamera:(YSCameraInfo *)ci
{
    if (nil == ci) {
        return;
    }
    
    self.cameraInfo = ci;
    _cameraNameLbl.text = ci.cameraName;
    
    if (0 == [self.cameraInfo.status intValue])
    { // 设备不在线
        [_offLineImageView setHidden:NO];
    }
    else
    { // 设备在线
        [_offLineImageView setHidden:YES];
    }
}


#pragma mark - MyCameraListCellDelegate

- (IBAction)onClickRealPlayButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickOnRealPlayButtonInCell:)]) {
        [self.delegate didClickOnRealPlayButtonInCell:self];
    }
}

- (IBAction)onCLickPlayBackButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickOnPlayBackButtonInCell:)]) {
        [self.delegate didClickOnPlayBackButtonInCell:self];
    }
}

- (IBAction)onClickLocalPlayButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickOnLocalPlayButtonInCell:)]) {
        [self.delegate didClickOnLocalPlayButtonInCell:self];
    }
}

- (IBAction)onClickVoiceMesageButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickOnVoiceMessageButtonInCell:)]) {
        [self.delegate didClickOnVoiceMessageButtonInCell:self];
    }
}

- (IBAction)clickCapture:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickOnCaptureInCell:)]) {
        [self.delegate didClickOnCaptureInCell:self];
    }
}


@end
