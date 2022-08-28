//
//  5000  Broken line  BrokenLineView.m
//  GChoiceShop
//
//  Created by jianhua zhang on 2019/11/25.
//  Copyright © 2019 ganqishi. All rights reserved.
//

#import "BrokenLineView.h"


@interface BrokenLineView ()

@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat rowWidth;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) NSInteger maxCounnt;

@end

@implementation BrokenLineView


- (instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)dataArr{
    if (self = [super initWithFrame:frame]) {
        self.dataArray = dataArr;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [self drawXYLine];
}

- (void)drawXYLine{
    self.verticalArray = @[@"60",@"50",@"40",@"30",@"20",@"10",@"0"];
    self.maxCounnt = 60;
    
    CGContextRef context= UIGraphicsGetCurrentContext(); //设置上下文
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 1.0);//线条宽度
    
    CGPoint origin = CGPointMake(100, 40);
    self.maxHeight = self.frame.size.height - origin.y;
    self.maxWidth = self.frame.size.width - origin.x;
    
    self.rowHeight = self.maxHeight / 7;
    self.rowWidth = self.maxWidth / self.dataArray.count;
    
    //画竖线
    for (int i = 0; i < self.dataArray.count; i++) {
        NSDictionary *day = [self.dataArray objectAtIndex:i];
        CGContextSetStrokeColorWithColor(context,[[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor);//线条颜色
        CGFloat startX = origin.x + i * self.rowWidth;
        CGContextMoveToPoint(context, startX, origin.y); //开始画线,x，y 为开始点的坐标
        CGContextAddLineToPoint(context, startX, self.maxHeight + origin.y - self.rowHeight);//画直线,x，y 为线条结束点的坐标
        CGContextStrokePath(context);
        [self drawText:[day valueForKey:@"dayDate"] withPoint:CGPointMake(startX, self.maxHeight + origin.y + 30 - self.rowHeight)];
    }
    //画横线
    for (int i = 0; i < self.verticalArray.count; i++) {
        CGContextSetStrokeColorWithColor(context,[[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor);//线条颜色
        CGFloat startY = origin.y + i * self.rowHeight;
        CGContextMoveToPoint(context, origin.x, startY); //开始画线,x，y 为开始点的坐标
        CGContextAddLineToPoint(context, origin.x + self.maxWidth  - self.rowWidth, startY);//画直线,x，y 为线条结束点的坐标
        CGContextStrokePath(context);
        [self drawText:self.verticalArray[i] withPoint:CGPointMake(origin.x - 30, startY)];
    }
    
    for (int i = 0; i < self.dataArray.count; i++) {
        
        NSDictionary *data = self.dataArray[i];
        // 线的路径
        CGFloat percent1 = (1.f - [[data valueForKey:@"correctQuestions"] floatValue] / self.maxCounnt);
        CGFloat percent2 = (1.f - [[data valueForKey:@"completeQuestions"] floatValue] / self.maxCounnt);
        

        NSDictionary *data1 = i == self.dataArray.count - 1 ? self.dataArray[i] : self.dataArray[i+1];
        // 线的路径
        CGFloat percent_1_1 = (1.f - [[data1 valueForKey:@"correctQuestions"] floatValue] / self.maxCounnt);
        CGFloat percent_1_2 = (1.f - [[data1 valueForKey:@"completeQuestions"] floatValue] / self.maxCounnt);
        
        CGFloat x = origin.x + i * _rowWidth;
        CGFloat x1 = i == self.dataArray.count - 1 ?  origin.x + i * _rowWidth : origin.x + (i + 1) * _rowWidth;
        
        UIBezierPath *linePath1 = [UIBezierPath bezierPath];
        UIBezierPath *linePath2 = [UIBezierPath bezierPath];
    
        [linePath1 moveToPoint:CGPointMake(x, origin.y + self.rowHeight * 6 * percent1)];
        [linePath2 moveToPoint:CGPointMake(x, origin.y + self.rowHeight * 6 * percent2)];
        
        [linePath1 addLineToPoint:CGPointMake(x1, origin.y + self.rowHeight * 6 * percent_1_1)];
        [linePath2 addLineToPoint:CGPointMake(x1, origin.y + self.rowHeight * 6 * percent_1_2)];
        
        [self drawText:[data valueForKey:@"correctQuestions"] withPoint:CGPointMake(origin.x + i * _rowWidth, origin.y + self.rowHeight * 6 * percent1 - 10) withFont:10.f withColor:[UIColor colorWithRed:253.f/255 green:89.f/255 blue:9.f/255 alpha:1]];
        [self drawText:[data valueForKey:@"completeQuestions"] withPoint:CGPointMake(origin.x + i * _rowWidth, origin.y + self.rowHeight * 6 * percent2 + 10) withFont:10.f withColor:[UIColor colorWithRed:32.f/255 green:151.f/255 blue:206.f/255 alpha:1]];
        
        //画线
        CAShapeLayer *lineLayer1 = [CAShapeLayer layer];
        lineLayer1.lineWidth = 1;
        lineLayer1.strokeColor = [UIColor colorWithRed:253.f/255 green:89.f/255 blue:9.f/255 alpha:1].CGColor;
        lineLayer1.path = linePath1.CGPath;
        lineLayer1.fillColor = nil; // 默认为blackColor
        CAShapeLayer *lineLayer2 = [CAShapeLayer layer];
        lineLayer2.lineWidth = 1;
        lineLayer2.strokeColor = [UIColor colorWithRed:32.f/255 green:151.f/255 blue:206.f/255 alpha:1].CGColor;
        lineLayer2.path = linePath2.CGPath;
        lineLayer2.fillColor = nil; // 默认为blackColor
        [self.layer addSublayer:lineLayer1];
        [self.layer addSublayer:lineLayer2];
        
        //画圆点
        UIBezierPath *pointPath1 = [UIBezierPath bezierPath];
        UIBezierPath *pointPath2 = [UIBezierPath bezierPath];
        [pointPath1 addArcWithCenter:CGPointMake(x, origin.y + self.rowHeight * 6 * percent1) radius:5 startAngle:0 endAngle:360 clockwise:YES];
        [pointPath2 addArcWithCenter:CGPointMake(x, origin.y + self.rowHeight * 6 * percent2) radius:5 startAngle:0 endAngle:360 clockwise:YES];
        //画圆点
        CAShapeLayer *pointLayer1 = [CAShapeLayer layer];
        pointLayer1.lineWidth = 2;
        pointLayer1.strokeColor = [UIColor colorWithRed:253.f/255 green:89.f/255 blue:9.f/255 alpha:1].CGColor;
        pointLayer1.path = pointPath1.CGPath;
        pointLayer1.fillColor = [UIColor whiteColor].CGColor; // 默认为blackColor
        CAShapeLayer *pointLayer2 = [CAShapeLayer layer];
        pointLayer2.lineWidth = 2;
        pointLayer2.strokeColor = [UIColor colorWithRed:32.f/255 green:151.f/255 blue:206.f/255 alpha:1].CGColor;
        pointLayer2.path = pointPath2.CGPath;
        pointLayer2.fillColor = [UIColor whiteColor].CGColor; // 默认为blackColor
        [self.layer addSublayer:pointLayer1];
        [self.layer addSublayer:pointLayer2];
    }
}

- (void)drawText:(NSString *)text withPoint:(CGPoint)point withFont:(CGFloat)fontSize withColor:(UIColor *)color{
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];//设置
    NSDictionary *dict = @{NSFontAttributeName: font,NSForegroundColorAttributeName:color};
    CGSize textSize = [text sizeWithAttributes:dict];
    [text drawAtPoint:CGPointMake(point.x - textSize.width/2.f, point.y - textSize.height/2.f) withAttributes:dict];
}
- (void)drawText:(NSString *)text withPoint:(CGPoint)point withFont:(CGFloat)fontSize{
    [self drawText:text withPoint:point withFont:fontSize withColor:[UIColor blackColor]];
                                                                                                }
- (void)drawText:(NSString *)text withPoint:(CGPoint)point{
    [self drawText:text withPoint:point withFont:15.f];
}

@end
