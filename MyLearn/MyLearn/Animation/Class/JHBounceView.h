//
//  JHBounceView.h
//  MyLearn
//
//  Created by jianhua zhang on 2018/7/19.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHBounceView : UIView<CAAnimationDelegate>

@property (nonatomic, strong) UIView *bounceView;

@property (nonatomic, assign) BOOL startAnimation;

- (instancetype)initWithSuperView:(UIView *)superView;

- (void)setBounceViewFrame:(CGRect)frame;

- (void)endAnimation:(void (^)(void))stopAnimation;

@end
