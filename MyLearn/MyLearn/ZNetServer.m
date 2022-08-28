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
+ (AFSecurityPolicy *)getSecretPlicy{
    // 先导入证书 证书由服务端生成，具体由服务端人员操作
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"xxx" ofType:@"cer"];//证书的路径
        NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
          
        // AFSSLPinningModeCertificate 使用证书验证模式
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
             // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
        // 如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
          
        //validatesDomainName 是否需要验证域名，默认为YES;
        //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
        //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        //如置为NO，建议自己添加对应域名的校验逻辑。
        securityPolicy.validatesDomainName = NO;
          
        securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData,nil,nil];
        
        return securityPolicy;
}

+ (AFHTTPSessionManager *)postValueWithMethod:(NSString *)method andBody:(id)body successBlock:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))successBlock failBlock:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failBlock{
    
    //可以增加加密方式
    NSString * postUrl = method;
    
    postUrl = [postUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    [sessionManager setSecurityPolicy:[ZNetServer getSecretPlicy]];
    
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
+ (AFHTTPSessionManager *)getValueWithMethod:(NSString *)method andBody:(id)body successBlock:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))successBlock failBlock:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failBlock{
    
    //可以增加加密方式
    NSString * postUrl = method;
    
    postUrl = [postUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSMutableSet *acceptableContentTypes = [sessionManager.responseSerializer.acceptableContentTypes mutableCopy];
    [acceptableContentTypes addObject:@"text/plain"];
    sessionManager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    
    [sessionManager GET:postUrl parameters:body progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        successBlock(task,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(task,error);
    }];
    return sessionManager;
}
@end
