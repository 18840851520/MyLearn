//
//  WatermarkViewController.h
//  NoName
//
//  Created by jianhua zhang on 2020/11/20.
//  Copyright © 2020 com.hualuoyongheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLPhotoActionSheet.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "ToolsVideo.h"
#import "WaterMarkImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface WatermarkViewController : UISplitViewController

@property (nonatomic, strong, nullable) AVURLAsset *urlAsset;

@property (nonatomic, strong) AVPlayer *player;

@end

NS_ASSUME_NONNULL_END
