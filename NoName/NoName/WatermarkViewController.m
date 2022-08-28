//
//  WatermarkViewController.m
//  NoName
//
//  Created by jianhua zhang on 2020/11/20.
//  Copyright © 2020 com.hualuoyongheng. All rights reserved.
//

#import "WatermarkViewController.h"

@interface WatermarkViewController ()

@property (weak, nonatomic) IBOutlet WaterMarkImage *waterMarkImage;

@end

@implementation WatermarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)addImage:(id)sender {
    [self showImage:YES];
}
- (void)type:(NSArray<UIImage *> *)images assets:(NSArray<PHAsset *>*)assets{
    PHAsset *ass = (PHAsset *)[assets firstObject];
    if (ass.mediaType == PHAssetMediaTypeImage) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.networkAccessAllowed = true;
        [[PHImageManager defaultManager] requestImageForAsset:ass targetSize:CGSizeMake(120, 80) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.waterMarkImage.hidden = NO;
            self.waterMarkImage.image = result;
            [self.waterMarkImage sizeToFit];
        }];
    }else{
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        options.networkAccessAllowed = true; // iCloud的相册需要网络许可
        [[PHImageManager defaultManager] requestAVAssetForVideo:ass options:options resultHandler:^(AVAsset * avasset, AVAudioMix * audioMix, NSDictionary * info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.urlAsset = (AVURLAsset *)avasset;
                        self.player = [[AVPlayer alloc] initWithURL:self.urlAsset.URL];
                        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
                        
                        playerLayer.position = CGPointMake(0, 0);
                            // 锚点，值只能是0,1之间
                        playerLayer.anchorPoint = CGPointMake(0, 0);
                        playerLayer.bounds = self.view.bounds;
                        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                        [self.view.layer insertSublayer:playerLayer atIndex:0];
                        [self.player play];
                    });
                }];
    }
}
- (IBAction)addVideo:(UIButton *)sender {
    if (!sender.selected) {
        [self showImage:NO];
    }else{
        [ToolsVideo addWaterPicWithVideoAsset:self.urlAsset withWaterMarkImage:self.waterMarkImage.image];
    }
    sender.selected = !sender.selected;
}
- (void)showImage:(BOOL)image{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.configuration.navBarColor = [UIColor colorForMainColor];
    actionSheet.sender = self;
    actionSheet.configuration.allowSelectVideo = !image;
    actionSheet.configuration.allowSelectImage = image;
    actionSheet.configuration.allowEditVideo = !image;
    actionSheet.configuration.allowEditImage = image;
    actionSheet.configuration.maxSelectCount = 1;
    actionSheet.selectImageBlock = ^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        [self type:images assets:assets];
    };
    [actionSheet showPhotoLibrary];
}

@end
