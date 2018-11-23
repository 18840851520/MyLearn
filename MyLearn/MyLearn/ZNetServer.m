//
//  ZNetServer.m
//  MyLearn
//
//  Created by 划落永恒 on 2018/11/23.
//  Copyright © 2018 jianhua zhang. All rights reserved.
//

#import "ZNetServer.h"

@implementation ZNetServer

//获取请求实例
/**
 * AFHTTPSessionManager 默认配置
 */
+ (AFHTTPSessionManager *(^)(NSString *, id))getServer{
    __block AFHTTPSessionManager *_sessionManager = [AFHTTPSessionManager manager];
    //支持SSL
    [_sessionManager.securityPolicy setAllowInvalidCertificates:YES];
    _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableSet *acceptableContentTypes = [_sessionManager.responseSerializer.acceptableContentTypes mutableCopy];
    [acceptableContentTypes addObject:@"text/html"];
    _sessionManager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    
    return ^(NSString *url, id parametes){
        
        return _sessionManager;
    };
}

+ (AFHTTPSessionManager *)postValueWithMethod:(NSString *)method andBody:(id)body successBlock:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))successBlock failBlock:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failBlock{
    
    //可以增加加密方式
    NSString * postUrl = method;
    
    postUrl = [postUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSMutableSet *acceptableContentTypes = [sessionManager.responseSerializer.acceptableContentTypes mutableCopy];
    [acceptableContentTypes addObject:@"text/plain"];
    sessionManager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    
    [sessionManager POST:postUrl parameters:body progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        successBlock(task,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(task,error);
    }];
    return sessionManager;
}

@end
