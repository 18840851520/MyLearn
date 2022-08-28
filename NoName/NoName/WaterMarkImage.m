//
//  WaterMarkImage.m
//  NoName
//
//  Created by jianhua zhang on 2020/11/23.
//  Copyright © 2020 com.hualuoyongheng. All rights reserved.
//

#import "WaterMarkImage.h"

@implementation WaterMarkImage
- (instancetype)init{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];

            [pinchRecognizer setDelegate:self];

            [self addGestureRecognizer:pinchRecognizer];
    }
    return self;
}
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    
    UIView *view = pinchGestureRecognizer.view;
    
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = (UITouch *)[touches anyObject];
    CGPoint currentP = [touch locationInView:self];
    CGPoint preP = [touch previousLocationInView:self];
            
    CGFloat offsetX= currentP.x - preP.x;
    CGFloat offsetY= currentP.y - preP.y;
            
    self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
}

@end
