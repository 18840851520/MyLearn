//
//  Lottery1ViewController.m
//  MyLearn
//
//  Created by jianhua zhang on 2022/8/14.
//  Copyright © 2022 jianhua zhang. All rights reserved.
//

#import "Lottery1ViewController.h"
#import "Lottery1CollectionViewCell.h"

@interface Lottery1ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *blueL;
@property (weak, nonatomic) IBOutlet UILabel *redL;

@property (nonatomic, strong) NSMutableArray *selectRed;
@property (nonatomic, strong) NSMutableArray *selectBlue;

@property (nonatomic, strong) NSMutableArray *randomR;
@property (nonatomic, strong) NSMutableArray *randomB;

@end

@implementation Lottery1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"Lottery1CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Lottery1CollectionViewCell"];
    
    self.selectRed = [NSMutableArray array];
    self.selectBlue = [NSMutableArray array];
    self.randomB = [NSMutableArray array];
    self.randomR = [NSMutableArray array];
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([self.selectBlue containsObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]]) {
            [self.selectBlue removeObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
        }else{
            [self.selectBlue addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
        }
    }else{
        if ([self.selectRed containsObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]]) {
            [self.selectRed removeObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
        }else{
            [self.selectRed addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
        }
    }
    [self.collectionView reloadData];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 35;
    }else{
        return 12;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Lottery1CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Lottery1CollectionViewCell" forIndexPath:indexPath];
    cell.numL.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    
    
    if (indexPath.section == 0 && [self.selectBlue containsObject:[NSString stringWithFormat:@"%ld",indexPath.row+1]]) {
        cell.numL.textColor = [UIColor blueColor];
        cell.numL.backgroundColor = [UIColor secondarySystemBackgroundColor];
    }else if (indexPath.section == 1 && [self.selectRed containsObject:[NSString stringWithFormat:@"%ld",indexPath.row+1]]) {
        cell.numL.textColor = [UIColor redColor];
        cell.numL.backgroundColor = [UIColor secondarySystemBackgroundColor];
    }else{
        cell.numL.textColor = [UIColor whiteColor];
        cell.numL.backgroundColor = indexPath.section == 0 ? [UIColor systemBlueColor] : [UIColor redColor];
    }
    
    
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(40, 40);
}

- (void)random{
    self.randomB = [NSMutableArray array];
    self.randomR = [NSMutableArray array];
    
    NSInteger type = 5;
    while (type) {
        NSInteger index = arc4random() % 19930625 % 35 + 1;
        if (![self.selectBlue containsObject:[NSNumber numberWithInteger:index].stringValue] && ![self.randomB containsObject:[NSNumber numberWithInteger:index].stringValue]) {
            [self.randomB addObject:[NSNumber numberWithInteger:index].stringValue];
            type--;
        }
    }
    type = 2;
    while (type) {
        NSInteger index = arc4random() % 19930625 % 12 + 1;
        if (![self.selectRed containsObject:[NSNumber numberWithInteger:index].stringValue] && ![self.randomR containsObject:[NSNumber numberWithInteger:index].stringValue]) {
            [self.randomR addObject:[NSNumber numberWithInteger:index].stringValue];
            type--;
        }
    }
//    [self.randomB sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        if ([obj1 intValue] > [obj2 intValue])
//            return NSOrderedDescending;
//        return NSOrderedAscending;
//    }];
//    [self.randomR sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        if ([obj1 intValue] > [obj2 intValue])
//            return NSOrderedDescending;
//        return NSOrderedAscending;
//    }];
    self.blueL.text = [[self.randomB sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 intValue] > [obj2 intValue])
            return NSOrderedDescending;
        return NSOrderedAscending;
    }] componentsJoinedByString:@","];
    self.redL.text = [[self.randomR sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 intValue] > [obj2 intValue])
            return NSOrderedDescending;
        return NSOrderedAscending;
    }] componentsJoinedByString:@","];
}
- (IBAction)randomAc:(id)sender {
    [self random];
}


@end
