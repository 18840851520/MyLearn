//
//  RuntimeGetSelector+Associated.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/7/3.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "RuntimeGetSelector+Associated.h"
#import <objc/runtime.h>

@implementation RuntimeGetSelector (Associated)

static char kDefaultColorKey;

- (void)setDefaultColor:(UIColor *)defaultColor{
    
    //关联对象(Objective-C Associated Objects)给分类增加属性
    objc_setAssociatedObject(self, &kDefaultColorKey, defaultColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)defaultColor{
    return objc_getAssociatedObject(self, &kDefaultColorKey);
}

@end
