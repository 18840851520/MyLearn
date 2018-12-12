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
    [self.actionSheet showPhotoLibrary];
}
- (void)selectVideo{
    
}
- (ZLPhotoActionSheet *)actionSheet{
    if (!_actionSheet) {
        _actionSheet = [[ZLPhotoActionSheet alloc] init];
    }
    _actionSheet.sender = self;
    return _actionSheet;
}

@end
