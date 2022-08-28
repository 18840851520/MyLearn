//
//  PageFlowLayout.m
//  MyLearn
//
//  Created by jianhua zhang on 2021/7/23.
//  Copyright © 2021 jianhua zhang. All rights reserved.
//

#import "PageFlowLayout.h"

@implementation PageFlowLayout
- (void)prepareLayout{
    NSLog(@"PageFlowLayout - prepareLayout");
    [super prepareLayout];
}
- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSLog(@"PageFlowLayout - layoutAttributesForElementsInRect %@ ",NSStringFromCGRect(rect));
    // 1.获取当前显示cell的布局
        NSArray *attrs = [super layoutAttributesForElementsInRect:self.collectionView.bounds];
        for (UICollectionViewLayoutAttributes *attr in attrs) {
            //2计算到中心的距离
            CGFloat dinstance = fabs((attr.center.x - self.collectionView.contentOffset.x) - self.collectionView.bounds.size.width * 0.5);
            //3.计算比例
            CGFloat scale = 1 -  dinstance / (self.collectionView.bounds.size.width * 0.5 ) * 0.5;
            attr.transform = CGAffineTransformMakeScale(scale, scale);
        }
        return attrs;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    NSLog(@"PageFlowLayout - shouldInvalidateLayoutForBoundsChange %@ ",NSStringFromCGRect(newBounds));
    return true;
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    NSLog(@"PageFlowLayout - targetContentOffsetForProposedContentOffset %@ %@",NSStringFromCGPoint(proposedContentOffset),NSStringFromCGPoint(velocity));
    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
}
- (CGSize)collectionViewContentSize{
    CGSize size = [super collectionViewContentSize];
    NSLog(@"PageFlowLayout - collectionViewContentSize %@",NSStringFromCGSize(size));
    return size;
}
@end
