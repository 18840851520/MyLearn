//
//  ShareInstance.h
//  MyLearn
//
//  Created by jianhua zhang on 2018/4/16.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

/*
 何为单例  保证一个类只有一个实例并且提供一个全局的访问入口这个实例
 像定位CLLocationManager和UIApplication 都只提供了一个实例对象
 
*/
#import <Foundation/Foundation.h>

@interface ShareInstance : NSObject

+ (instancetype)shareInstance;

@end
