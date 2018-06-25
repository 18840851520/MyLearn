//
//  BlueToothInstance.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/5/16.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "BlueToothInstance.h"

@implementation BlueToothInstance

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self centralManager];
    }
    return self;
}
//单例
static BlueToothInstance *__share = nil;
+ (BlueToothInstance *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __share = [[BlueToothInstance alloc] init];
    });
    return __share;
}
//中央管理器
- (CBCentralManager *)centralManager{
    if(!_centralManager){
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _centralManager;
}
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case 0:
        {
            NSLog(@"CBCentralManagerStateUnknown");         //未知
        }
            break;
        case 1:
        {
            NSLog(@"CBCentralManagerStateResetting");       //中心管理者已被重置
        }
            break;
        case 2:
        {
            NSLog(@"CBCentralManagerStateUnsupported");     //不支持蓝牙
        }
            break;
        case 3:
        {
            NSLog(@"CBCentralManagerStateUnauthorized");    //蓝牙未授权
        }
            break;
        case 4:
        {
            NSLog(@"CBCentralManagerStatePoweredOff");      //蓝牙未开启
        }
            break;
        case 5:
        {
            NSLog(@"CBCentralManagerStatePoweredOn");       //蓝牙已开启
        }
            break;
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
}

@end
