//
//  VideoViewController.m
//  MyLearn
//
//  Created by 划落永恒 on 2018/12/5.
//  Copyright © 2018 jianhua zhang. All rights reserved.
//

#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ToolsVideo.h"
#import "VideoCollectionViewCell.h"

@interface VideoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
//播放对象
@property (nonatomic, strong) AVPlayer *player;
//
@property (nonatomic, strong) AVPlayerItem *currentPlayItem;
//播放路径
@property (nonatomic, copy) NSURL *videoUrl;

@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, copy) NSMutableArray *imageArr;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"GIF剪辑";
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"VideoCollectionViewCell"];
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
- (void)setImageArr:(NSMutableArray *)imageArr{
    _imageArr = imageArr;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
- (void)loadVideo{
    self.progressView.hidden = NO;
    __weak typeof(self) weakSelf = self;
    [ToolsVideo decompositionWithVideoPath:self.videoUrl andFps:60 progressBlock:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progressView.progress = progress;
        });
    } decompositionCompleteBlock:^(BOOL isSuccess, id  _Nonnull decompositionImgs) {
        if (isSuccess) {
            self.imageArr = [NSMutableArray arrayWithArray:[(NSArray <UIImage *>*)decompositionImgs mutableCopy]];
        }else{
            if ([decompositionImgs isKindOfClass:[NSError class]]) {
                NSError *error = (NSError *)decompositionImgs;
                NSLog(@"%@",error.domain);
            }else{
                NSLog(@"%@",(NSString *)decompositionImgs);
            }
        }
    }];
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

#pragma mark collectionView Delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCollectionViewCell" forIndexPath:indexPath];
    cell.imageView.image = self.imageArr[indexPath.row];
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArr.count;
}
@end
