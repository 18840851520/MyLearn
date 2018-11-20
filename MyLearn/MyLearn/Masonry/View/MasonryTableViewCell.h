//
//  MasonryTableViewCell.h
//  MyLearn
//
//  Created by 划落永恒 on 2018/11/12.
//  Copyright © 2018 jianhua zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface MasonryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *payStatusLB;
@property (weak, nonatomic) IBOutlet UIImageView *nextImage;
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *statusLB;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLB;
@property (weak, nonatomic) IBOutlet UILabel *appointimeLB;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLB;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeStatusLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLB;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
