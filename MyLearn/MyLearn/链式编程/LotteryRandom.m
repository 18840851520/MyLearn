//
//  LotteryRandom.m
//  MyLearn
//
//  Created by jianhua zhang on 2019/4/1.
//  Copyright © 2019 jianhua zhang. All rights reserved.
//

#import "LotteryRandom.h"

@implementation LotteryRandom

static int statistical;
+ (NSArray *)getResultNumber:(NSDictionary *)dict andCount:(int)count andKillNo:(NSArray *)killArr{
    if (dict == nil) {
        return @[];
    }
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:dict];
    //移除杀号
    for (NSString *killNo in killArr) {
        killNo.length == 1 ? [data removeObjectForKey:[NSString stringWithFormat:@"0%@",killNo]] : [data removeObjectForKey:killNo];
    }
    //生成中奖号码
    NSMutableArray *arr = [NSMutableArray array];
    statistical = 0;
    for (int i = 0; i < count; i++) {
        //每次获取概率总值
        NSString *key = [LotteryRandom getWinningNumber:data];
        [arr addObject:key];
        statistical -= (int)[[data valueForKey:key] integerValue];
        [data removeObjectForKey:key];
    }
    return arr;
}
//生成中奖概率
+ (NSString *)getWinningNumber:(NSDictionary *)dict{
    //中奖统计总和
    if (statistical == 0) {
        for (NSString *countStr in [dict allValues]) {
            statistical = statistical + (int)[countStr integerValue];
        }
    }
    //获取中奖随机数
    double timein = [[NSDate date] timeIntervalSince1970] * 10000000;
    int arc = abs((int)arc4random());
    
    int random = (int)((long)timein % arc % statistical);
    NSLog(@"statistical = %ld",(long)timein % arc);
    for (int i = 1; i <= dict.count; i++) {
        NSString *key = [NSString stringWithFormat:@"%@%d",i < 10 ? @"0":@"",i];
        int firstInterval = (int)[[dict valueForKey:key] integerValue];
        //遍历获取到中奖号所在index
        if (firstInterval > random) {
            //获取得是index为i的key
            return key;
        }else{
            //随机数减去未中区域
            random -= firstInterval;
        }
    }
    return [dict.allKeys lastObject];
}

@end
