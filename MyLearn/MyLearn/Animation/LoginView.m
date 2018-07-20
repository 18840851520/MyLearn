//
//  LoginView.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/7/18.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (IBAction)loginAction:(id)sender {
    if (self.loginBlock) {
        self.loginBlock();
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 8;

    self.layer.shadowRadius = 20;
    self.layer.shadowOffset = CGSizeMake(1.5, 1.5);
    self.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor;
    self.layer.shadowOpacity = 1;
}

@end
