//
//  Hospital.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/4/28.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "Hospital.h"
#import "OutpatientService.h"
#import "Registration.h"
#import "Medicine.h"

@implementation Hospital

- (void)getPatientService:(Patient *)patient{
    if (patient.isCard) {
        
        if (!patient.registrationType) {
            //咨询挂什么号
            [self makeAppointmentWithService:patient];
        }else{
            if(patient.registrationType){
                [Registration needRegistration:patient];
            }else if(!patient.outpatientService){
                //门诊
                [OutpatientService needDiagnose:patient];
            }else{
                [Medicine needGetMedicin:patient];
            }
        }
    }else{
        [self applyCard:patient];
    }
}
//咨询挂什么科
- (void)makeAppointmentWithService:(Patient *)patient{
    patient.registrationType = random()/10000/3 % 3;
    [self getPatientService:patient];
}
//办卡
- (void)applyCard:(Patient *)patient{
    patient.isCard = YES;
    NSLog(@"%@已办卡",patient.name);
    [self getPatientService:patient];
}
@end
