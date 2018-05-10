//
//  FacadeViewController.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/5/10.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "FacadeViewController.h"
#import "Hospital.h"
#import "Patient.h"

@interface FacadeViewController ()

@end

@implementation FacadeViewController

static int i = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    // Dispose of any resources that can be recreated.
}

@end
