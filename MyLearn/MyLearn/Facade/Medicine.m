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
    
    NSLog(@"%@拿药%ld",patient.name,patient.medicineType);
}

@end
