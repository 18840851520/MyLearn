//
//  BlueToothInstance.h
//  MyLearn
//
//  Created by jianhua zhang on 2018/5/16.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//  中心者模式
//

#import <Foundation/Foundation.h>
#import "CentralManager.h"

@interface BlueToothInstance : NSObject

/* 中心管理者 */
@property (nonatomic, strong) CBCentralManager *centralManager;

/* 单例 */
+ (BlueToothInstance *)shareInstance;
// 通过某些服务筛选外设
- (void)scanForPeripheralsWithServices:(nullable NSArray<CBUUID *> *)serviceUUIDs options:(nullable NSDictionary<NSString *, id> *)options;

@end
