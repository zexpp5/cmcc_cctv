//
//  MyHomeViewController.h
//  EzvizRealPlayDemo
//
//  Created by liyan on 15/7/6.
//  Copyright (c) 2015年 hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHomeViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (retain, nonatomic) IBOutlet UIView *tileView;
@property (retain, nonatomic) IBOutlet UIImageView *userImage;

@end
