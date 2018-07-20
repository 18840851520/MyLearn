//
//  NextAnimationViewController.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/7/20.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "NextAnimationViewController.h"

@interface NextAnimationViewController ()

@end

@implementation NextAnimationViewController

- (UIModalTransitionStyle)modalTransitionStyle{
    return UIModalTransitionStyleCoverVertical;
}
- (UIModalPresentationStyle)modalPresentationStyle{
    return UIModalPresentationOverFullScreen;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
