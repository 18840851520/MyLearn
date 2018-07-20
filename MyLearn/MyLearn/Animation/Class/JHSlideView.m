//
//  JHSlideView.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/7/18.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "JHSlideView.h"

@implementation JHSlideView

- (void)setIsSelect:(BOOL)isSelect{
    if (_isSelect != isSelect) {
        _isSelect = isSelect;
        if (self.selectBlock && isSelect) {
            self.selectBlock();
        }
        [self animation];
    }
}
- (void)setMinT:(CGFloat)minT{
    _minT = minT;
    [self animation];
}
- (void)setMaxT:(CGFloat)maxT{
    _maxT = maxT;
    [self animation];
}
- (instancetype)initWithFrame:(CGRect)frame{
    return [super initWithFrame:frame];
}
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initSetting];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self initSetting];
}
- (void)initSetting{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectView)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
    self.originalTransform = self.transform;
    self.initFrame = self.frame;
    _maxT = 1;
    _minT = 1;
    [self animation];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [super initWithCoder:aDecoder];
}
- (void)selectView{
    if (!self.isSelect) {
        self.isSelect = !self.isSelect;
    }
}
- (void)animation{
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.3];
    if (self.isSelect) {
        CGAffineTransform newTransform =
        CGAffineTransformScale(self.originalTransform, self.maxT, self.maxT);
        [self setTransform:newTransform];
        [[self superview] bringSubviewToFront:self];
    }else{
        CGAffineTransform newTransform =
        CGAffineTransformScale(self.transform, self.minT, self.minT);
        [self setTransform:newTransform];
    }
    [UIView commitAnimations];
}

@end
