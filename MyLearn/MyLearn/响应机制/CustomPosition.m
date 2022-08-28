//
//  CustomPosition.m
//  MyLearn
//
//  Created by jianhua zhang on 2021/7/15.
//  Copyright © 2021 jianhua zhang. All rights reserved.
//

#import "CustomPosition.h"

@implementation CustomPosition

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect btnBounds = self.bounds;
    btnBounds = CGRectInset(btnBounds, -30, -30);
    return CGRectContainsPoint(btnBounds, point);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

@end
