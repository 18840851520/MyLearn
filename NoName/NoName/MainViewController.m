//
//  MainViewController.m
//  NoName
//
//  Created by jianhua zhang on 2020/12/3.
//  Copyright © 2020 com.hualuoyongheng. All rights reserved.
//

#import "MainViewController.h"
#import "ToolsVideo.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self testCode];
}
- (void)testCode{
    NSLog(@"testCode");
    [ToolsVideo addWaterPicWithVideoAsset:[AVURLAsset assetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"]]] withWaterMarkImage:[UIImage imageNamed:@"videoWater"]];
}


@end
