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
 
 内存区块 5块
 1.栈区   临时变量没有分配空间 像[NSString StringWithFormate:@""]
 2.堆区   （程序员手动分配空间，释放也是程序员释放，alloc，malloc calloc    ARC（自动管理 需注意循环引用）MRC release CFRelease()）
 3.全局区  （静态，全区）编译时分配，app结束时由系统释放
 4.常量区  编译时分配，app结束时由系统释放
 5.代码区
 
 单例有没有子类 （没有）
 
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
