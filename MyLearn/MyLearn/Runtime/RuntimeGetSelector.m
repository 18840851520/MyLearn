//
//  RuntimeGetSelector.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/7/2.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "RuntimeGetSelector.h"

@implementation RuntimeGetSelector

- (void)willChangeValueForKey:(NSString *)key{
    [super willChangeValueForKey:key];
    NSLog(@"willChangeValueForKey=%@",key);
}
- (void)setName:(NSString *)name{
    _name = name;
//    [self willChangeValueForKey:@"name"];    //KVO 在调用存取方法之前总调用
//    [super setValue:name forKey:@"name"]; //调用父类的存取方法
//    [self didChangeValueForKey:@"name"];     //KVO 在调用存取方法之后总调用
}
- (void)foo{
    NSLog(@"RuntimeGetSelector = %s",__FUNCTION__);
}

@end
