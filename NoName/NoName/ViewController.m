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
        
        
    };
    return _actionSheet;
}
- (void)type:(NSArray<UIImage *> *)images assets:(NSArray<PHAsset *>*)assets{
    PHAsset *ass = (PHAsset *)[assets firstObject];
    ZLAlbumListModel *listmodel 
    ZLPhotoModel *model = [ZLPhotoModel modelWithAsset:ass type:<#(ZLAssetMediaType)#> duration:<#(NSString *)#>]
    if ([ass mediaType] == 1) {
        [weakSelf loadGIF:[ToolsVideo exportGifImages:images delays:nil loopCount:nil]];
    }
}
- (void)loadGIF:(NSString *)path{
    
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    NSString *filepath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"abc.gif" ofType:nil];
   
    self.gifImageView.image= [UIImage sd_animatedGIFWithData:gifData];

}

@end
