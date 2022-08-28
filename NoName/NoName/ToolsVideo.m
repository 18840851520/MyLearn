//
//  ToolsVideo.m
//  MyLearn
//
//  Created by 划落永恒 on 2018/12/6.
//  Copyright © 2018 jianhua zhang. All rights reserved.
//

#import "ToolsVideo.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreServices/CoreServices.h>

@implementation ToolsVideo

+ (NSArray *)getImageArray{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [defaults valueForKey:@"imagePaths"];
    [defaults synchronize];
    return arr;
}
+ (BOOL)delImagePath:(NSString *)ide{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *images = [NSMutableArray arrayWithArray:[self getImageArray]];
    for (NSDictionary *dict in images) {
        if ([[dict valueForKey:@"id"] isEqualToString:ide]) {
            [images removeObject:dict];
            NSFileManager * manager = [NSFileManager defaultManager];
            [manager removeItemAtPath:[dict valueForKey:@"path"] error:nil];
            break;
        }
    }
    [defaults setValue:images forKey:@"imagePaths"];
    return [defaults synchronize];
}
+ (NSString *)getLastID{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *images = [NSMutableArray arrayWithArray:[self getImageArray]];
    
    NSString *ide;
    if (images.count) {
        ide = [NSNumber numberWithInt:[[[images lastObject] valueForKey:@"id"] intValue] + 1].stringValue;
    }else{
        ide = @"0";
    }
    return ide;
}
+ (BOOL)saveImageid:(NSString *)ide Path:(NSString *)path{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *images = [NSMutableArray arrayWithArray:[self getImageArray]];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setValue:ide forKey:@"id"];
    [data setValue:path forKey:@"path"];
    [images addObject:data];
    
    [defaults setValue:images forKey:@"imagePaths"];
    return [defaults synchronize];
}

+ (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path{
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    CMTime   time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    
    NSInteger   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    
    return @{@"size" : @(fileSize),
             @"duration" : @(seconds)};
}

+ (void)decompositionWithVideoPath:(NSURL *)fileUrl andFps:(int32_t)fps progressBlock:(ToolsProgressBlock)progressBlock decompositionCompleteBlock:(ToolsDecompositionCompleteBlock)completeBlock{
    NSLog(@"invalid URL");
    if (!fileUrl) {
        if (completeBlock) {
            completeBlock(NO,@"invalid URL");
        }
        return;
    }
    NSMutableArray *imagesArr = [NSMutableArray array];
    NSDictionary *optDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileUrl options:optDict];
    //视频时间
    Float64 videoSecond = CMTimeGetSeconds(asset.duration);
    
    NSMutableArray *times = [NSMutableArray array];
    //获得视频总帧数
    Float64 totalFrames = videoSecond * fps;
    CMTime timeFrame;
    for (int i = 1; i <= totalFrames; i++) {
        timeFrame = CMTimeMake(i, fps); //第i帧  帧率
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
    }
    //
    AVAssetImageGenerator *imgGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    //防止时间出现偏差
    imgGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imgGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    
    __block NSInteger timesCount = [times count];
    //异步获取帧图片
    [imgGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        BOOL isSuccess = NO;
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                NSLog(@"Cancelled");
                break;
            case AVAssetImageGeneratorFailed:
                NSLog(@"Failed");
                break;
            case AVAssetImageGeneratorSucceeded: {
                UIImage *img = [UIImage imageWithCGImage:[UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageWithCGImage:image], 0.3)].CGImage];
                [imagesArr addObject:img];
                if (requestedTime.value == timesCount) {
                    isSuccess = YES;
                    NSLog(@"completed");
                }
            }
                break;
        }
        if (requestedTime.value == timesCount) {
            if (completeBlock) {
                completeBlock(isSuccess,imagesArr);
            }
        }else if(error){
            if (completeBlock) {
                completeBlock(NO,error);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                CGFloat progress = requestedTime.value * 1.0 / timesCount;
                progressBlock(progress);
            }
        });
    }];
}

+ (void)syntheticVideoWithImage:(NSArray<UIImage *> *)imagesArr andFPS:(int32_t)fps progressBlock:(ToolsProgressBlock)progress decompositionCompleteBlock:(ToolsDecompositionCompleteBlock)complete{
    if (!imagesArr) {
        NSLog(@"NO ImageArray");
        if (complete) {
            complete(NO,@"NO ImageArray");
        }
        return;
    }
    //设置mov路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *movieLocalPath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",@"video"]];
    //    转成UTF-8编码
    unlink([movieLocalPath UTF8String]);
    NSLog(@"path->%@",movieLocalPath);
    NSURL *videoUrl = [NSURL fileURLWithPath:movieLocalPath];
    
    NSError *error = nil;
    //图像和音频写成一个完整的视频文件
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:videoUrl fileType:AVFileTypeQuickTimeMovie error:&error];
    NSParameterAssert(videoWriter);
    if (error) {
        NSLog(@"error =%@",[error localizedDescription]);
        return;
    }
    //获取首图尺寸
    UIImage *image = imagesArr.firstObject;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(image.CGImage), CGImageGetHeight(image.CGImage));
    //视频格式 大小
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecTypeH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:imageSize.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:imageSize.height], AVVideoHeightKey, nil];
    //视频输入流
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    //转换容器
    NSDictionary *bufferAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
    //添加像素缓冲区
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:bufferAttributes];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    //
    if ([videoWriter canAddInput:writerInput]) {
        [videoWriter addInput:writerInput];
    }
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    //合成多张图片
    __block int  count = 0;
    __block NSString *moviePath = movieLocalPath;
    [writerInput requestMediaDataWhenReadyOnQueue: dispatch_queue_create("mediaInputQueue", DISPATCH_QUEUE_SERIAL) usingBlock:^{
        while ([writerInput isReadyForMoreMediaData]) {
            if(++count > imagesArr.count) {
                [writerInput markAsFinished];
                [videoWriter finishWritingWithCompletionHandler:^{
                    if (complete) {
                        complete(YES,moviePath);
                    }
                }];
                break;
            }
            CVPixelBufferRef buffer = NULL;
            UIImage *currentImg = imagesArr[count-1];
            buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:currentImg.CGImage size:imageSize];
            //进度需要回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progress) {
                    CGFloat progressValue = count * 1.0 / imagesArr.count;
                    progress(progressValue);
                }
            });
            if (buffer) {
                if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(count, fps)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (complete) {
                            complete(NO,@"Failed");
                        }
                    });
                } else {
                    CFRelease(buffer);
                    buffer = NULL;
                }
            }
        }
    }];
}
+(NSString *)exportGifImages:(NSArray*)images delays:(NSArray*)delays loopCount:(NSUInteger)loopCount progressBlock:(nonnull ToolsProgressBlock)progress
{
    NSString *fileName = @"preview.gif";
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:filePath],
                                                                        kUTTypeGIF, images.count, NULL);
    if(!loopCount){
        loopCount = 0;
    }
    NSDictionary *gifProperties = @{ (__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @(loopCount), // 0 means loop forever
                                             }
                                     };
    float delay = 0.3; //默认每一帧间隔0.1秒
    for(int i= 0 ; i <images.count ;i ++){
        if (progress) {
            progress((CGFloat)i / images.count);
        }
        UIImage *itemImage = images[i];
        if(delays && i<delays.count){
            delay = [delays[i] floatValue];
        } else if(i >= delays.count && delays){
            delay = [[delays lastObject] floatValue];
        }
        //每一帧对应的延迟时间
        NSDictionary *frameProperties = @{(__bridge id)kCGImagePropertyGIFDictionary: @{
                                                  (__bridge id)kCGImagePropertyGIFDelayTime: @(delay), // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                                  }
                                          };
        CGImageDestinationAddImage(destination,itemImage.CGImage, (__bridge CFDictionaryRef)frameProperties);
        if (progress) {
            progress((CGFloat)(i+1) / images.count);
        }
    }
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gifProperties);
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);
    return filePath;
}
//裁剪图片大小
+ (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size {
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             
                             [NSNumber numberWithBool:YES],kCVPixelBufferCGImageCompatibilityKey,
                             
                             [NSNumber numberWithBool:YES],kCVPixelBufferCGBitmapContextCompatibilityKey,nil];
    
    CVPixelBufferRef pxbuffer = NULL;
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,size.width,size.height,kCVPixelFormatType_32ARGB,(__bridge CFDictionaryRef) options,&pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer,0);
    
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    NSParameterAssert(pxdata !=NULL);
    
    CGColorSpaceRef rgbColorSpace=CGColorSpaceCreateDeviceRGB();
    
    //    当你调用这个函数的时候，Quartz创建一个位图绘制环境，也就是位图上下文。当你向上下文中绘制信息时，Quartz把你要绘制的信息作为位图数据绘制到指定的内存块。一个新的位图上下文的像素格式由三个参数决定：每个组件的位数，颜色空间，alpha选项
    
    CGContextRef context = CGBitmapContextCreate(pxdata,size.width,size.height,8,4*size.width,rgbColorSpace,kCGImageAlphaPremultipliedFirst);
    
    NSParameterAssert(context);
    
    //使用CGContextDrawImage绘制图片  这里设置不正确的话 会导致视频颠倒
    
    //    当通过CGContextDrawImage绘制图片到一个context中时，如果传入的是UIImage的CGImageRef，因为UIKit和CG坐标系y轴相反，所以图片绘制将会上下颠倒
    
    CGContextDrawImage(context,CGRectMake(0,0,CGImageGetWidth(image),CGImageGetHeight(image)), image);
    
    // 释放色彩空间
    
    CGColorSpaceRelease(rgbColorSpace);
    
    // 释放context
    
    CGContextRelease(context);
    
    // 解锁pixel buffer
    
    CVPixelBufferUnlockBaseAddress(pxbuffer,0);
    
    return pxbuffer;
    
}

+ (NSString *)exportGifVideoPath:(NSURL *)fileUrl delays:(NSArray *)delays loopCount:(NSUInteger)loopCount{
    return nil;
}

+ (UIImage*)getVideoPreViewImage:(NSURL *)fileUrl
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileUrl options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return img;
}


/**
 视频添加水印并保存到相册

 @param path 视频本地路径
 */
+ (void)addWaterPicWithVideoPath:(AVURLAsset*)path withWaterMark:(UIImageView *)waterImage withSize:(CGSize)bgSize;
{
    //1 创建AVAsset实例
    AVURLAsset*videoAsset = path;
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    //3 视频通道
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject]
                         atTime:kCMTimeZero error:nil];
    
    
    //2 音频通道
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] firstObject]
                         atTime:kCMTimeZero error:nil];
    
    //3.1 AVMutableVideoCompositionInstruction 视频轨道中的一个视频，可以缩放、旋转等
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    // 3.2 AVMutableVideoCompositionLayerInstruction 一个视频轨道，包含了这个轨道上的所有视频素材
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];

    [videolayerInstruction setOpacity:0.0 atTime:videoAsset.duration];
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    //AVMutableVideoComposition：管理所有视频轨道，水印添加就在这上面
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    CGSize naturalSize = videoAssetTrack.naturalSize;
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    [self applyVideoEffectsToComposition:mainCompositionInst videoSize:naturalSize imageView:waterImage BgSize:bgSize];
    
    //    // 4 - 输出路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"FinalVideo-%d.mp4",arc4random() % 1000]];
    NSURL* videoUrl = [NSURL fileURLWithPath:myPathDocs];
    
    // 5 - 视频文件输出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = videoUrl;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if( exporter.status == AVAssetExportSessionStatusCompleted ){
               
                UISaveVideoAtPathToSavedPhotosAlbum(myPathDocs, nil, nil, nil);
  
            }else if( exporter.status == AVAssetExportSessionStatusFailed )
            {
                NSLog(@"failed");
            }
            
        });
    }];
}
/**
 设置水印及其对应视频的位置

 @param composition 视频的结构
 @param videoSize 视频的尺寸
 */
+ (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition videoSize:(CGSize)videoSize imageView:(UIImageView *)imageView BgSize:(CGSize)bgSize
{
    //图片
    CALayer*picLayer = [CALayer layer];
    picLayer.contents = (id)imageView.image.CGImage;
    
    //图片相对于视频的比例
    CGFloat fitScale = bgSize.width / videoSize.width;
//    picLayer.frame = CGRectMake(videoSize.width * fitScale, 15, fitScale * imageView.bounds.size.width, fitScale * imageView.bounds.size.height);
    
    picLayer.frame = CGRectMake(videoSize.width - imageView.bounds.size.width, videoSize.height - imageView.bounds.size.height, imageView.bounds.size.width, imageView.bounds.size.height);
    
//    picLayer.transform = imageView.layer.transform;
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:picLayer];
    overlayLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [overlayLayer setMasksToBounds:YES];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
}


#pragma mark 添加水印
+ (void)addWaterPicWithVideoAsset:(AVURLAsset*)videoAsset withWaterMarkImage:(UIImage *)waterMarkImage{
    //创建混合集合
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    AVAssetTrack *audioAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    //创建视频轨道
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    //加入视频的轨道
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,videoAsset.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
    //创建音频轨道
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //加入音频的轨道
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    //轨道视频
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    AVMutableVideoCompositionLayerInstruction *videoLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    [videoLayerInstruction setOpacity:0 atTime:videoAsset.duration];
    
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videoLayerInstruction, nil];
    
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize = videoTrack.naturalSize;
    if (naturalSize.width == 0) {
        CGFloat a = (1280.f / 720);
        naturalSize.width =  a * naturalSize.height;
    }
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    [self applyVideoEffectsToComposition:mainCompositionInst size:naturalSize];
//    NSArray *arr = [NSArray arrayWithObjects:mixComposition,mainCompositionInst, nil];

    NSLog(@"开始保存视频");
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"FinalVideo-%d.mp4",arc4random() % 1000]];//获取路径
    NSURL *filUrl = [NSURL fileURLWithPath:filePath];
    session.outputURL = filUrl;//视频输出地址
    session.outputFileType = AVFileTypeMPEG4;//AVFileTypeQuickTimeMovie;//AVFileTypeMPEG4;
    
    // 这个一般设置为yes（指示输出文件应针对网络使用进行优化，例如QuickTime电影文件应支持“快速启动”）
    session.shouldOptimizeForNetworkUse = YES;
    // 文件的最大多大的设置
//    session.fileLengthLimit = 30 * 1024 * 1024;
    
    session.videoComposition = mainCompositionInst;
    
    [session exportAsynchronouslyWithCompletionHandler:^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            //视频导入成功
            //failPath为本地视频地址
            if( session.status == AVAssetExportSessionStatusCompleted ){
               
                UISaveVideoAtPathToSavedPhotosAlbum(filePath, nil, nil, nil);
                NSLog(@"保存");
            }else if( session.status == AVAssetExportSessionStatusFailed )
            {
                NSLog(@"failed");
            }
        });
    }];
    
    
}
+ (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size
{
    // 文字
    CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
    //    [subtitle1Text setFont:@"Helvetica-Bold"];
    [subtitle1Text setFontSize:36];
    [subtitle1Text setFrame:CGRectMake(10, size.height-10-230, size.width, 100)];
    [subtitle1Text setString:@"央视体育5 水印"];
    //    [subtitle1Text setAlignmentMode:kCAAlignmentCenter];
    [subtitle1Text setForegroundColor:[[UIColor whiteColor] CGColor]];
    
    //图片
    CALayer*picLayer = [CALayer layer];
    
    //picLayer.contents = (id)[UIImage imageNamed:@"CTVITTRIMSource.bundle/QQ"].CGImage; //本地图片
    picLayer.contents = (id)[UIImage imageNamed:@"videoWater"].CGImage; //本地图片2
    //NSString *imageUrl = @"http://p1.img.cctvpic.com/photoAlbum/templet/special/PAGEQ1KSin2j2U5FERGWHp1h160415/ELMTnGlKHUJZi7lz19PEnqhM160415_1460715755.png";
    //picLayer.contents = (id)[self getImageFromURL:imageUrl].CGImage; //远程图片
    picLayer.frame = CGRectMake(0, 0, [UIImage imageNamed:@"videoWater"].size.width, [UIImage imageNamed:@"videoWater"].size.height);
    
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:picLayer];
    [overlayLayer addSublayer:subtitle1Text];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
}
@end
