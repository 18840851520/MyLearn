//
//  VideoViewController.m
//  MyLearn
//
//  Created by 划落永恒 on 2018/12/5.
//  Copyright © 2018 jianhua zhang. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"视频剪辑";
}
- (IBAction)chooseAction:(id)sender {
    [self chooseVideo];
}

- (void)chooseVideo{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.mediaTypes =@[@"public.movie"];
    pickerController.allowsEditing = NO;
    pickerController.delegate = self;
    [self.navigationController presentViewController:pickerController animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.movie"]){
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];//获得视频的URL
        NSLog(@"url %@",url);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
