//
//  VideoCollectionViewCell.h
//  MyLearn
//
//  Created by 划落永恒 on 2018/12/6.
//  Copyright © 2018 jianhua zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, copy) void (^addBlock)(UIView *);
@property (nonatomic, copy) void (^delBlock)(UIView *);

@end

NS_ASSUME_NONNULL_END
