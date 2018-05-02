//
//  Patient.h
//  MyLearn
//
//  Created by jianhua zhang on 2018/4/28.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

//门诊
typedef enum : NSUInteger {
    OutpatientServiceTypeDefault,
    OutpatientServiceTypeDepartment,
    OutpatientServiceTypeSurgeryDepartment,
    OutpatientServiceTypeOrthopedicsDepartment,
} OutpatientServiceType;
//挂号类型
typedef enum : NSUInteger {
    RegistrationTypeDefault,
    RegistrationTypeInternalMedicineDepartment,//内科
    RegistrationTypeSurgeryDepartment,//外科
    RegistrationTypeOrthopedicsDepartment,//骨科
} RegistrationType;
//药
typedef enum : NSUInteger {
    MedicineTypeDefault,
    RegistrationTypeXi,
    RegistrationTypeZhong,
} MedicineType;

@interface Patient : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) BOOL isCard;

@property (nonatomic, assign) OutpatientServiceType outpatientService;

@property (nonatomic, assign) RegistrationType registrationType;

@property (nonatomic, assign) MedicineType medicineType;

@end
