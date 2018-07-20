//
//  ShapeLayerLearn.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/4/9.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "ShapeLayerLearn.h"

#define blueToothWidth 15

@implementation ShapeLayerLearn

- (void)drawRect:(CGRect)rect{
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 3;
    
    //贝塞尔路径
    UIBezierPath *path = [self blueToothPath];
    
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = nil;
    
    //填充颜色
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    
    //绘制起始点和终点
    shapeLayer.strokeStart = 0.f;
    shapeLayer.strokeEnd = 1.f;
    
    //第一个动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
//    [shapeLayer addAnimation:animation forKey:nil];
    
    //第二个动画
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation1.fromValue = [NSNumber numberWithFloat:1.0f];
    animation1.toValue = [NSNumber numberWithFloat:0.0f];
//    [shapeLayer addAnimation:animation forKey:nil];

    //组合动画
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = 2.f;
    groupAnimation.animations = @[animation, animation1];
    //结束时是否手动移除动画 为NO需要手动释放代码在下面
    groupAnimation.removedOnCompletion = YES;
    //重复次数
    groupAnimation.repeatCount = MAXFLOAT;
    groupAnimation.fillMode = kCAFillModeForwards;
    [shapeLayer addAnimation:groupAnimation forKey:@"animation"];
    //手动释放的代码
//    [shapeLayer removeAnimationForKey:@"animation"];
    [self.layer addSublayer:shapeLayer];
    
}
- (UIBezierPath *)blueToothPath{
    //贝塞尔路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint p1 = CGPointMake(self.frame.size.width/2-blueToothWidth, self.frame.size.height/2-blueToothWidth);
    CGPoint p2 = CGPointMake(self.frame.size.width/2+blueToothWidth, self.frame.size.height/2+blueToothWidth);
    CGPoint p3 = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+blueToothWidth*2);
    CGPoint p4 = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-2*blueToothWidth);
    CGPoint p5 = CGPointMake(self.frame.size.width/2+blueToothWidth, self.frame.size.height/2-blueToothWidth);
    CGPoint p6 = CGPointMake(self.frame.size.width/2-blueToothWidth, self.frame.size.height/2+blueToothWidth);
    
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    [path addLineToPoint:p3];
    [path addLineToPoint:p4];
    [path addLineToPoint:p5];
    [path addLineToPoint:p6];
    
    return path;
}
- (void)removeFromSuperview{
    //手动释放动画
}
@end
