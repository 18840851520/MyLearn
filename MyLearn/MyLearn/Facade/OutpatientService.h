//
//  OutpatientService.h
//  MyLearn
//
//  Created by jianhua zhang on 2018/4/28.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Patient.h"

@interface OutpatientService : NSObject

+ (void)needDiagnose:(Patient *)patient;

@end
