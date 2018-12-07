//
//  VideoCollectionViewCell.m
//  MyLearn
//
//  Created by 划落永恒 on 2018/12/6.
//  Copyright © 2018 jianhua zhang. All rights reserved.
//

#import "VideoCollectionViewCell.h"

@implementation VideoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)addImage:(id)sender {
    if (self.addBlock) {
        self.addBlock(self);
    }
}
- (IBAction)delAction:(id)sender {
    if (self.delBlock) {
        self.delBlock(self);
    }
}

@end
