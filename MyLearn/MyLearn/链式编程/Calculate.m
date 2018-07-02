//
//  Calculate.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/6/25.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "Calculate.h"

@implementation Calculate

- (instancetype)init{
    if (self = [super init]) {
        self.result = 0;
    }
    return self;
}
- (Calculate *)clear{
    self.result = 0;
    return self;
}
- (Calculate *)printfResult{
    NSLog(@"计算结果为%ld",self.result);
    return self;
}
- (Calculate *(^)(NSInteger))add{
    return ^(NSInteger i){
        NSLog(@"+%ld",i);
        self.result += i;
        return self;
    };
}
- (Calculate *(^)(NSInteger))sub{
    return ^(NSInteger i){
         NSLog(@"-%ld",i);
        self.result -= i;
        return self;
    };
}
+(NSInteger)markCalculate:(void (^)(Calculate *))block
{
    //创建管理计算者
    Calculate *cal = [[Calculate alloc]init];
    //给参数赋值
    block(cal);
    return cal.result;
}

@end
