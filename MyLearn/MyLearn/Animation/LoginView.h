//
//  LoginView.h
//  MyLearn
//
//  Created by jianhua zhang on 2018/7/18.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "JHSlideView.h"

@interface LoginView : JHSlideView

@property (nonatomic, strong) void (^loginBlock)();

@end
