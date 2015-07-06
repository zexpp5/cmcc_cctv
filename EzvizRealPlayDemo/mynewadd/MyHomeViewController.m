//
//  MyHomeViewController.m
//  EzvizRealPlayDemo
//
//  Created by liyan on 15/7/6.
//  Copyright (c) 2015年 hikvision. All rights reserved.
//

#import "MyHomeViewController.h"
#import "MyCollectionViewCell.h"

@interface MyHomeViewController ()

@end

@implementation MyHomeViewController
{
    UICollectionView *collectionV;
    NSArray * section_arr;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userImage.layer.cornerRadius = 20;
    self.userImage.layer.masksToBounds = YES;
    // 布局方式
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置Item大小
    [layout setItemSize:CGSizeMake(155, 110)];
    // 设置排列方式
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.tileView.bounds.size.height+64, self.view.bounds.size.width, self.view.bounds.size.height-(self.tileView.bounds.size.height+64)) collectionViewLayout:layout];
    collectionV.delegate = self;
    collectionV.dataSource = self;
    collectionV.backgroundColor = [UIColor grayColor];
    [collectionV registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collectionV];
    section_arr=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",nil];


}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return  CGSizeMake(1, 1);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
      return  CGSizeMake(1, 1);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    
    // 1.清理操作
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.infoImge.image = [UIImage imageNamed:[section_arr objectAtIndex:indexPath.row]];
    cell.infoLable.text = @"111111111";
    return cell;
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

- (void)dealloc {

    [_tileView release];
    [_userImage release];
    [super dealloc];
}
@end
