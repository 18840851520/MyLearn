//
//  MasonryTableViewCell.m
//  MyLearn
//
//  Created by 划落永恒 on 2018/11/12.
//  Copyright © 2018 jianhua zhang. All rights reserved.
//

#import "MasonryTableViewCell.h"

@implementation MasonryTableViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadMakeConstraints];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    return self;
}
- (void)updateConstraints{
    [super updateConstraints];
}
- (void)layoutSubviews{
      [super layoutSubviews];
    [self loadMakeConstraints];
}
- (void)loadMakeConstraints{
    UIView *bgView = self.bgView;

    bgView.frame = self.bounds;
    [self.payStatusLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(15);
        make.top.equalTo(bgView.mas_top).offset(12);
    }];
    [self.statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payStatusLB.mas_centerY);
        make.left.equalTo(bgView.mas_right).offset(-15);
    }];
    [self.createTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payStatusLB.mas_centerY);
        make.left.equalTo(self.payStatusLB.mas_right).offset(10);
        make.right.equalTo(self.statusLB.mas_left).offset(-15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left);
        make.right.equalTo(bgView.mas_right);
    }];
    [self.shopImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.equalTo(bgView.mas_left).offset(15);
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
