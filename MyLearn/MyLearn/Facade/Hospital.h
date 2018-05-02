//
//  Hospital.h
//  MyLearn
//
//  Created by jianhua zhang on 2018/4/28.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Patient.h"

@interface Hospital : NSObject

//获取服务
- (void)getPatientService:(Patient *)patient;
//咨询挂什么科
- (void)makeAppointmentWithService:(Patient *)patient;
//办卡
- (void)applyCard:(Patient *)patient;

@end
