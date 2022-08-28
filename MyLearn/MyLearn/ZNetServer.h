//
//  ZNetServer.h
//  MyLearn
//
//  Created by 划落永恒 on 2018/11/23.
//  Copyright © 2018 jianhua zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "URLConfigs.h"

typedef void (^SuccessBlock)(NSDictionary *data);
typedef void (^FailBlock)(NSString *errorMessage);

NS_ASSUME_NONNULL_BEGIN

@interface ZNetServer : NSObject

+ (AFHTTPSessionManager *(^)(NSString *,id))getSessionManager;

/**
 * post 请求服务端数据
 */
+ (AFHTTPSessionManager *)requestServerSuccess:(SuccessBlock)successBlock AndFailBlock:(FailBlock)failBlock;

+ (AFHTTPSessionManager *)postValueWithMethod:(NSString *)method andBody:(id)body successBlock:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))successBlock failBlock:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failBlock;
+ (AFHTTPSessionManager *)getValueWithMethod:(NSString *)method andBody:(id)body successBlock:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))successBlock failBlock:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failBlock;
@end

NS_ASSUME_NONNULL_END
