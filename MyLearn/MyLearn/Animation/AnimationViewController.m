//
//  AnimationViewController.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/5/10.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "AnimationViewController.h"
#import "ShapeLayerLearn.h"
#import "LoginView.h"
#import "JHBounceView.h"
#import "NextAnimationViewController.h"

@interface AnimationViewController ()

@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) LoginView *forgetView;

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgImage.image = [UIImage imageNamed:@"123456"];
    bgImage.contentMode = UIViewContentModeRight;
    [self.view addSubview:bgImage];
    
//    ShapeLayerLearn *shape = [[ShapeLayerLearn alloc] initWithFrame:CGRectMake(10, 80, 80, 80)];
//
//    [self.view addSubview:shape];
    
    self.loginView = [[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:nil options:nil].lastObject;
    self.loginView.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds) * 6 / 5);
    self.loginView.minT = 0.9;
    
    __weak typeof(self)weakSelf = self;
    self.loginView.selectBlock = ^{
        weakSelf.forgetView.isSelect = NO;
    };
    self.loginView.loginBlock = ^{
        JHBounceView *view = [[JHBounceView alloc] initWithSuperView:weakSelf.view];
        view.startAnimation = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __block typeof(view)blockview = view;
            [view endAnimation:^{
                [weakSelf presentNextVC];
            }];
        });
    };
    [self.view addSubview:self.loginView];
    
    self.forgetView = [[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:nil options:nil].lastObject;
    self.forgetView.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds) * 8 / 5);
    self.forgetView.minT = 0.9;
    
    self.forgetView.selectBlock = ^{
        weakSelf.loginView.isSelect = NO;
    };
    [self.view addSubview:self.forgetView];
    
    self.forgetView.isSelect = NO;
    self.loginView.isSelect = YES;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [UIView animateWithDuration:0.8 animations:^{
        self.loginView.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds) * 3 / 7);
        
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:1 animations:^{
        self.forgetView.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds) * 4 / 7);
    }];
}
- (void)presentNextVC{
    NextAnimationViewController *vc = [[NextAnimationViewController alloc] init];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
