//
//  ViewController.m
//  NoName
//
//  Created by 划落永恒 on 2018/12/11.
//  Copyright © 2018 com.hualuoyongheng. All rights reserved.
//

#import "ViewController.h"
#import "ZLPhotoActionSheet.h"

@interface ViewController ()

@property (nonatomic, strong) ZLPhotoActionSheet *actionSheet;

@property (nonatomic, strong, readonly) ZLPhotoConfiguration *configuration;

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
    _actionSheet.selectImageBlock = ^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        
    };
    return _actionSheet;
}

@end
