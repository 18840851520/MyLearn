//
//  RuntimeViewController.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/6/28.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "RuntimeViewController.h"
#import <objc/runtime.h>
@interface RuntimeViewController ()

@end

@implementation RuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    class_addMethod([self class], @selector(foo:), (IMP)fooMethod, "v@:");
    [self performSelector:@selector(foo:)];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
//    if (sel == @selector(foo:)) {
//
//
//        return YES;
//    }
    return [super resolveInstanceMethod:sel];
}
void fooMethod(id obj,SEL _cmd){
    NSLog(@"fooMethod %@",obj);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
