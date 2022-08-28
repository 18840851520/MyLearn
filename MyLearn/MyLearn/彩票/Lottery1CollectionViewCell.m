//
//  Lottery1CollectionViewCell.m
//  MyLearn
//
//  Created by jianhua zhang on 2022/8/14.
//  Copyright © 2022 jianhua zhang. All rights reserved.
//

#import "Lottery1CollectionViewCell.h"

@implementation Lottery1CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.numL.layer.cornerRadius = self.numL.bounds.size.width / 2.f;
}
@end
