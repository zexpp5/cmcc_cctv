//
//  MyCameraListCell.h
//  VideoGo
//
//  Created by zhengwen zhu on 10/14/13.
//
//

#import <UIKit/UIKit.h>


@protocol MyCameraListCellDelegate;

@class YSCameraInfo;

@interface MyCameraListCell : UITableViewCell
{
    YSCameraInfo                     *_cameraInfo;                  // 关联的摄像机对象
    id<MyCameraListCellDelegate>     _delegate;
        
    IBOutlet UIView                  *_containerView;               // 包含所有子控件的父视图
    IBOutlet UIImageView             *_bgImageView;                 // 背景效果
    IBOutlet UILabel                 *_cameraNameLbl;               // 摄像机名称
    
    IBOutlet UIView                  *_coverView;                   // 摄像机封面视图容器(封面图像, 预览按钮, 离线状态)
    IBOutlet UIImageView            *_coverImgView;                // 摄像机封面图像
    IBOutlet UILabel                 *_offLineLbl;                  // 显示离线状态蒙版
    IBOutlet UIImageView             *_offLineImageView;            // 显示离线状态图片
    IBOutlet UIButton                *_realPlayButton;              // 预览按钮
    IBOutlet UIButton                *_playBackButton;              // 回放按钮
    IBOutlet UIButton                *_localPlayButton;             // 本地播放按钮
    IBOutlet UIButton                *_voiceMessageButton;          // 语音留言
    IBOutlet UIView                  *_firstSeporatorView;          // 按钮之间的分割线
    IBOutlet UIView                  *_secondSeporatorView;         // 按钮之间的分割线
}

@property (nonatomic, retain) YSCameraInfo *cameraInfo;
@property (nonatomic, assign) id<MyCameraListCellDelegate> delegate;
@property (nonatomic, retain) UIView        *containerView;
@property (nonatomic, retain) UIImageView   *bgImageView;
@property (nonatomic, retain) UILabel       *cameraNameLbl;
@property (nonatomic, retain) UIView        *coverView;
@property (nonatomic, retain) UIImageView  *coverImgView;
@property (nonatomic, retain) UILabel       *offLineLbl;
@property (nonatomic, retain) UIImageView   *offLineImageView;
@property (nonatomic, retain) UIButton      *realPlayButton;
@property (nonatomic, retain) UIButton      *playBackButton;
@property (nonatomic, retain) UIButton      *localPlayButton;
@property (nonatomic, retain) UIButton      *voiceMessageButton;
@property (nonatomic, retain) UIView        *firstSeporatorView;
@property (nonatomic, retain) UIView        *seconfSeporatorView;

@property (retain, nonatomic) IBOutlet UIButton *capture;

- (IBAction)onClickRealPlayButton:(id)sender;
- (IBAction)onCLickPlayBackButton:(id)sender;
- (IBAction)onClickLocalPlayButton:(id)sender;
- (IBAction)onClickVoiceMesageButton:(id)sender;

- (IBAction)clickCapture:(id)sender;


- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
     withCameraInfo:(YSCameraInfo *)theCameraInfo;

- (void)reloadWithCamera:(YSCameraInfo *)ci;

@end

#pragma mark -

@protocol MyCameraListCellDelegate <NSObject>

@optional
- (void)didClickOnRealPlayButtonInCell:(MyCameraListCell *)cell;
- (void)didClickOnPlayBackButtonInCell:(MyCameraListCell *)cell;
- (void)didClickOnLocalPlayButtonInCell:(MyCameraListCell *)cell;
- (void)didClickOnVoiceMessageButtonInCell:(MyCameraListCell *)cell;

- (void)didClickOnCaptureInCell:(MyCameraListCell *)cell;

@end