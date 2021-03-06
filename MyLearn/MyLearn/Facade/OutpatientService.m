//
//  OutpatientService.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/4/28.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "OutpatientService.h"
#import "Medicine.h"

@implementation OutpatientService

+ (void)needDiagnose:(Patient *)patient{
    if(!patient.medicineType){
        patient.medicineType = arc4random() % 2;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random() % 3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@进入门诊%ld",patient.name,patient.outpatientService);
        sleep(arc4random()%200/100.f);
        [Medicine needGetMedicin:patient];
    });
}

@end
