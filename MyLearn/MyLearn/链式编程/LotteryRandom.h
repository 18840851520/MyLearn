//
//  LotteryRandom.h
//  MyLearn
//
//  Created by jianhua zhang on 2019/4/1.
//  Copyright © 2019 jianhua zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LotteryRandom : NSObject

+ (NSArray *)getResultNumber:(NSDictionary *)dict andCount:(int)count andKillNo:(NSArray *)killArr;

+ (NSString *)getWinningNumber:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
