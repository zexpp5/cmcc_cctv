//
//  VideoAlarmMsgCell.h
//  VideoGo
//
//  Created by luohs on 11/27/13.
//
//

#import <UIKit/UIKit.h>

@class YSAlarmInfo, VideoAlarmMsgCell;

@protocol VideoAlarmMsgCellDelegate <NSObject>

@optional
- (void)startRealPlayWithCell:(VideoAlarmMsgCell *)cell;
- (void)startPlaybackWithCell:(VideoAlarmMsgCell *)cell;

@end

@interface VideoAlarmMsgCell : UITableViewCell

@property (nonatomic, assign) id<VideoAlarmMsgCellDelegate> delegate;
@property (nonatomic, retain) YSAlarmInfo *alarmInfo;

+ (float)cellHeight;
@end


