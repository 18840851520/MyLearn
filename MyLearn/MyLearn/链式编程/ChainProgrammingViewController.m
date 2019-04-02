//
//  ChainProgrammingViewController.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/6/25.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "ChainProgrammingViewController.h"
#import "Calculate.h"


@interface ChainProgrammingViewController ()

@end

@implementation ChainProgrammingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//     Do any additional setup after loading the view from its nib.
    NSInteger result = [Calculate markCalculate:^(Calculate *ma) {
        (void)ma.add(arc4random() % 10).printfResult.sub(arc4random() % 20);
    }];
    NSLog(@"%ld",result);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
