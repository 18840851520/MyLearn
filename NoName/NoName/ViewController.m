//
//  ViewController.m
//  NoName
//
//  Created by 划落永恒 on 2018/12/11.
//  Copyright © 2018 com.hualuoyongheng. All rights reserved.
//

#import "ViewController.h"
#import "ZLPhotoActionSheet.h"
#import "ZLPhotoModel.h"

#import "ToolsVideo.h"
#import <UIImage+GIF.h>
#import "GIFGenerator.h"

@interface ViewController ()

@property (nonatomic, strong) ZLPhotoActionSheet *actionSheet;

@property (nonatomic, strong, readonly) ZLPhotoConfiguration *configuration;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)selectImage:(id)sender {
    self.actionSheet.configuration.allowSelectVideo = NO;
    self.actionSheet.configuration.allowSelectImage = YES;
    [self.actionSheet showPhotoLibrary];
}
- (IBAction)selectVideo:(id)sender {
    self.actionSheet.configuration.allowSelectVideo = YES;
    self.actionSheet.configuration.allowSelectImage = NO;
    [self.actionSheet showPhotoLibrary];
}

- (ZLPhotoActionSheet *)actionSheet{
    if (!_actionSheet) {
        _actionSheet = [[ZLPhotoActionSheet alloc] init];
        _actionSheet.configuration.navBarColor = [UIColor colorForMainColor];
    }
    _actionSheet.sender = self;
    __weak typeof(self)weakSelf = self;
    _actionSheet.selectImageBlock = ^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        [weakSelf type:images assets:assets];
    };
    return _actionSheet;
}
- (void)type:(NSArray<UIImage *> *)images assets:(NSArray<PHAsset *>*)assets{
    PHAsset *ass = (PHAsset *)[assets firstObject];
    if (ass.mediaType == PHAssetMediaTypeImage) {
        [self loadGIF:[ToolsVideo exportGifImages:images delays:nil loopCount:nil]];
    }else if(ass.mediaType == PHAssetMediaTypeVideo){
        __weak typeof(self)weakSelf = self;
        [[PHImageManager defaultManager] requestAVAssetForVideo:ass options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            NSString *url = [[[info objectForKey:@"PHImageFileSandboxExtensionTokenKey"]componentsSeparatedByString:@";"] lastObject];
            NSString *movieLocalPath = [NSString stringWithFormat:@"%@.gif",@"preview1"];
            NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:movieLocalPath];
            [[GIFGenerator shareGIFGenerator] createGIFfromURL:[NSURL URLWithString:url] loopCount:0 startSecond:0 delayTime:0.1 gifTime:ass.duration gifImagePath:filePath];
            [GIFGenerator shareGIFGenerator].endBlock = ^(BOOL status, NSError * _Nonnull error) {
                if (status) {
                    [weakSelf loadGIF:filePath];
                }
            };
        }];
    }else{
        NSLog(@"错误");
    }
}
- (void)loadGIF:(NSString *)path{
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    self.gifImageView.image= [UIImage sd_animatedGIFWithData:gifData];
}

@end
