//
//  5000  Broken line  BrokenLineView.h
//  GChoiceShop
//
//  Created by jianhua zhang on 2019/11/25.
//  Copyright © 2019 ganqishi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BrokenLineView : UIView

@property (nonatomic, strong) NSArray *horizontalArray;
@property (nonatomic, strong) NSArray *verticalArray;

- (void)drawXYLine;
- (instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)dataArr;

@end

NS_ASSUME_NONNULL_END
