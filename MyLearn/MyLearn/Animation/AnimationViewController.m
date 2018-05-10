//
//  AnimationViewController.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/5/10.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "AnimationViewController.h"
#import "ShapeLayerLearn.h"

@interface AnimationViewController ()

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    ShapeLayerLearn *shape = [[ShapeLayerLearn alloc] initWithFrame:CGRectMake(10, 80, 80, 80)];
    
    [self.view addSubview:shape];
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

@end
