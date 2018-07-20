//
//  RuntimeViewController.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/6/28.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "RuntimeViewController.h"
#import <objc/runtime.h>
//#import "RuntimeGetSelector.h"
#import "RuntimeGetSelector+Associated.h"

@interface RuntimeViewController ()

@end

@implementation RuntimeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self performSelector:@selector(foo)];
    
    RuntimeGetSelector *rum = [RuntimeGetSelector new];
    rum.defaultColor = [UIColor whiteColor];
    NSLog(@"%@",rum.defaultColor);
    
    NSLog(@"self->isa:%@",object_getClass(rum));
    NSLog(@"self class:%@",[rum class]);
    
    [rum addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    rum.name = @"123";
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"");
}
//方法替换
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL oriSelector = @selector(viewDidLoad);
        SEL swizzSelector = @selector(jViewDidLoad);
        Method oriMethod = class_getInstanceMethod([self class], oriSelector);
        Method swizzMethod = class_getInstanceMethod([self class], @selector(jViewDidLoad));
        
        BOOL didAddMethod = class_addMethod([self class], @selector(viewDidLoad), method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        NSLog(@"%d",didAddMethod);
        if(didAddMethod){
            class_replaceMethod([self class], @selector(jViewDidLoad), method_getImplementation(class_getInstanceMethod([self class], @selector(viewDidLoad))), method_getTypeEncoding(oriMethod));
        }else{
            method_exchangeImplementations(oriMethod, swizzMethod);
        }
    });
}
- (void)jViewDidLoad{
    NSLog(@"%s",__FUNCTION__);
    [self jViewDidLoad];
}
- (void)viewDidLoad{
    NSLog(@"%s",__FUNCTION__);
    [super viewDidLoad];
}
//是否查找到方法
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    NSLog(@"resolveInstanceMethod = %d",[super resolveInstanceMethod:sel]);
    return [super resolveInstanceMethod:sel];
}
//转发的对象
- (id)forwardingTargetForSelector:(SEL)aSelector{
    if (aSelector == @selector(foo)) {
        return [RuntimeGetSelector new];
    }
    return [super forwardingTargetForSelector:aSelector];
}

void fooMethod(id obj,SEL _cmd){
    NSLog(@"fooMethod %@",obj);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
