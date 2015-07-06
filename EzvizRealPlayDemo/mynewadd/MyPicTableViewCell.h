//
//  MyPicTableViewCell.h
//  EzvizRealPlayDemo
//
//  Created by liyan on 15/6/29.
//  Copyright (c) 2015年 hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyPicListCellDelegate;

@interface MyPicTableViewCell : UITableViewCell
{
    id<MyPicListCellDelegate>     _delegate;

}
@property (retain, nonatomic) IBOutlet UILabel *timeLable;
@property (retain, nonatomic) IBOutlet UIImageView *lineImageView;
@property (retain, nonatomic) IBOutlet UIImageView *pointImageView;
@property (retain, nonatomic) IBOutlet UIImageView *PicImageView;
@property (retain, nonatomic) IBOutlet UIButton *picBtn;
@property (nonatomic, assign) id<MyPicListCellDelegate> delegate;

- (IBAction)clickPicBtn:(id)sender;
#pragma mark -
@end

@protocol MyPicListCellDelegate <NSObject>

@optional
- (void)didClickBigPicButtonInCell:(MyPicTableViewCell *)cell;

@end

