//
//  Registration.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/4/28.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "Registration.h"
#import "OutpatientService.h"

@implementation Registration

+ (void)needRegistration:(Patient *)patient{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random() % 5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@挂了%ld科",patient.name,patient.registrationType);
        patient.outpatientService = (NSInteger)patient.registrationType;
        [OutpatientService needDiagnose:patient];
    });
}

@end
