//
//  VideoViewController.m
//  MyLearn
//
//  Created by 划落永恒 on 2018/12/5.
//  Copyright © 2018 jianhua zhang. All rights reserved.
//

#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface VideoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
//播放对象
@property (nonatomic, strong) AVPlayer *player;
//
@property (nonatomic, strong) AVPlayerItem *currentPlayItem;
//播放路径
@property (nonatomic, copy) NSURL *videoUrl;

@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"视频剪辑";
}
- (IBAction)chooseAction:(id)sender {
    if(!self.videoUrl)
        [self chooseVideo];
    else
        [self loadVideo];
}
//选择视频
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
        self.videoUrl = info[UIImagePickerControllerMediaURL];//获得视频的URL
        [self loadVideo];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)loadVideo{
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:self.videoUrl];
    self.currentPlayItem = playerItem;
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    
    AVPlayerLayer *avLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    avLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    avLayer.frame = self.videoBtn.bounds;
    
    self.videoBtn.backgroundColor = [UIColor blackColor];
    [self.videoBtn.layer addSublayer:avLayer];
    
    [self.player play]; 
}

@end
