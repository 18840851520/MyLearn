//
//  JHBounceView.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/7/19.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "JHBounceView.h"

@interface JHBounceView()

@property (nonatomic, strong) CABasicAnimation *bounceAnimation;

@property (nonatomic, strong) void (^stopAnimation)(void);
@end

@implementation JHBounceView

- (UIView *)bounceView{
    if (!_bounceView) {
        _bounceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _bounceView.center = self.center;
        _bounceView.backgroundColor = [UIColor whiteColor];
        
        _bounceView.layer.cornerRadius = _bounceView.frame.size.width/2.f;
        _bounceView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor;
        _bounceView.layer.shadowOffset = CGSizeMake(1, 1.5);
        _bounceView.layer.shadowOpacity = 1;
 
    }
    return _bounceView;
}
- (instancetype)initWithSuperView:(UIView *)superView{
    JHBounceView *view = [self initWithFrame:superView.bounds];
    view.backgroundColor = [UIColor clearColor];
    [superView addSubview:self];
    
    [self addSubview:self.bounceView];
    return view;
}
- (void)setBounceViewFrame:(CGRect)frame{
    self.bounceView.frame = frame;
}
- (void)setStartAnimation:(BOOL)startAnimation{
    _startAnimation = startAnimation;
    [self animation];
}
- (void)animation{
    if (!_bounceAnimation) {
        _bounceAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    }
    _bounceAnimation.fromValue=[NSNumber numberWithFloat:1];
    _bounceAnimation.toValue=[NSNumber numberWithFloat:3];
    _bounceAnimation.duration=0.2;
    _bounceAnimation.autoreverses = YES;
    _bounceAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];;
    _bounceAnimation.repeatCount = CGFLOAT_MAX;
    [self.bounceView.layer addAnimation:_bounceAnimation forKey:@"zoom"];
}
- (void)endAnimation:(void (^)(void))stopAnimation{
    self.stopAnimation = stopAnimation;
    [self.bounceView.layer removeAnimationForKey:@"zoom"];
    
    CABasicAnimation *bounceAnimation=[CABasicAnimation animationWithKeyPath:@"bounds"];
    bounceAnimation.fromValue=[NSValue valueWithCGRect:self.bounceView.frame];

    bounceAnimation.toValue=[NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetHeight(self.bounds), CGRectGetHeight(self.bounds))];
    bounceAnimation.delegate = self;
    bounceAnimation.duration=0.5;
    bounceAnimation.repeatCount = 1;
    bounceAnimation.removedOnCompletion = NO;
    bounceAnimation.fillMode = kCAFillModeForwards;
    [self.bounceView.layer addAnimation:bounceAnimation forKey:@"bou"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([self.bounceView.layer animationForKey:@"bou"] == anim) {
        if (self.stopAnimation) {
            self.stopAnimation();
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }
}
@end
