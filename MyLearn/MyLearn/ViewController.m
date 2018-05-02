//
//  ViewController.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/4/9.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "ViewController.h"
#import "ShapeLayerLearn.h"
#import "Hospital.h"

@interface ViewController ()

@end

@implementation ViewController

static int i = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    ShapeLayerLearn *shape = [[ShapeLayerLearn alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    
    [self.view addSubview:shape];
    
    Hospital *hospital = [[Hospital alloc] init];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        Patient *pa = [[Patient alloc] init];
        pa.name = [NSString stringWithFormat:@"病人%d",i++];
        pa.isCard = arc4random() % 2;
        pa.outpatientService = arc4random() % 4;
        if((int)pa.outpatientService != 0){
            pa.registrationType = arc4random() % 4;
            if((int)pa.registrationType != 0){
                pa.medicineType = arc4random() % 3;
            }
        }
        [hospital getPatientService:pa];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
