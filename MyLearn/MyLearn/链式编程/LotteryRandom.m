//
//  LotteryRandom.m
//  MyLearn
//
//  Created by jianhua zhang on 2019/4/1.
//  Copyright © 2019 jianhua zhang. All rights reserved.
//

#import "LotteryRandom.h"

@implementation LotteryRandom

+ (NSArray *)getResultNumber:(NSDictionary *)dict andCount:(int)count andKillNo:(NSArray *)killArr{
    if (dict == nil) {
        return @[];
    }
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:dict];
    //移除杀号
    for (NSString *killNo in killArr) {
        if (killNo.length == 1) {
            [data removeObjectForKey:[NSString stringWithFormat:@"0%@",killNo]];
        }else{
            [data removeObjectForKey:killNo];
        }
    }
    //生成中奖号码
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        //每次获取概率总值
        NSString *key = [LotteryRandom getWinningNumber:data];
        [arr addObject:key];
        [data removeObjectForKey:key];
    }
    return arr;
}
//生成中奖概率
+ (NSString *)getWinningNumber:(NSDictionary *)dict{
    int statistical = 0;
    //中奖统计总和
    for (NSString *countStr in [dict allValues]) {
        statistical = statistical + (int)[countStr integerValue];
    }
    NSLog(@"statistical = %d",statistical);
    //获取中奖者
    int random = (int)((long)([[NSDate date] timeIntervalSince1970] * 10000000) % arc4random() % statistical);
    for (int i = 1; i <= dict.count; i++) {
        NSString *key = i < 10 ? [NSString stringWithFormat:@"0%d",i] : [NSString stringWithFormat:@"%d",i];
        int firstInterval = (int)[[dict valueForKey:key] integerValue];
        //遍历获取到中奖号所在index
        if (firstInterval > random) {
            //获取得是index为i的key
            return [dict.allKeys objectAtIndex:i-1];
        }else{
            random -= firstInterval;
        }
    }
    return [dict.allKeys lastObject];
}

@end
