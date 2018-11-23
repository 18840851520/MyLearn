//
//  Calculate.h
//  MyLearn
//
//  Created by jianhua zhang on 2018/6/25.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^successBlock)(void);
typedef void (^failBlock)(NSString *errorMessage);

@interface Calculate : NSObject

//计算结果
@property (nonatomic,assign) NSInteger result;
//清零
- (Calculate *)clear;
//打印结果
- (Calculate *)printfResult;
//在结果上加
- (Calculate *(^)(NSInteger))add;
//在结果上减
- (Calculate *(^)(NSInteger))sub;

+(NSInteger)markCalculate:(void (^)(Calculate *))block;

@end
