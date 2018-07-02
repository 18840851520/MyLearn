//
//  Medicine.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/4/28.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "Medicine.h"

@implementation Medicine

+ (void)needGetMedicin:(Patient *)patient{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random() % 5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@拿药%ld",patient.name,patient.medicineType);
    });
}

@end
