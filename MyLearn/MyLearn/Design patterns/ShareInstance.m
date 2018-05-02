//
//  ShareInstance.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/4/16.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "ShareInstance.h"

@implementation ShareInstance

/*
 //线程安全 防止脏数据（数据已不值得信任）
 1.NSLock(同步锁)
 2.dispatch_semaphore_t(信号量)
 3.NSConditionLock(条件锁)
 4.@synchronized (<#token#>) {
 <#statements#>
 }
 
 */

static ShareInstance *__shareInstance;

//+ (void)load{
//    [ShareInstance shareInstance];
//}

+ (void)initialize{
    [ShareInstance shareInstance];
}

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shareInstance = [[ShareInstance alloc] init];
    });
    return __shareInstance;
}

+ (instancetype)alloc{
    
    if(__shareInstance){
        //抛出异常
//        NSException *exception = [NSException exceptionWithName:@"NSInternalInconsistencyException" reason:@"There can only be one ShareInstance instance." userInfo:nil];
//        [exception raise];
        return __shareInstance;
    }
    return [super alloc];
}

@end
