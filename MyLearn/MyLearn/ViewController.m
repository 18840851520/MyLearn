//
//  ViewController.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/4/9.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "ViewController.h"
#import "ShapeLayerLearn.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ShapeLayerLearn *shape = [[ShapeLayerLearn alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    
    [self.view addSubview:shape];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
