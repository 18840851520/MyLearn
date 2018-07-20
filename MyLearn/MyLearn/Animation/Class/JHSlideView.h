//
//  JHSlideView.h
//  MyLearn
//
//  Created by jianhua zhang on 2018/7/18.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHSlideView : UIView

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, assign) CGFloat maxT;

@property (nonatomic, assign) CGFloat minT;

@property (nonatomic) CGRect initFrame;

@property (nonatomic) CGAffineTransform originalTransform;

@property (nonatomic, strong) void (^selectBlock)();

@end
