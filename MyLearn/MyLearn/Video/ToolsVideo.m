//
//  ToolsVideo.m
//  MyLearn
//
//  Created by 划落永恒 on 2018/12/6.
//  Copyright © 2018 jianhua zhang. All rights reserved.
//

#import "ToolsVideo.h"
#import <AVFoundation/AVFoundation.h>

@implementation ToolsVideo

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
    NSInteger timesCount = [times count];
    //异步获取帧图片
    [imgGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        if (progressBlock) {
            CGFloat progress = requestedTime.value * 1.0 / timesCount;
            progressBlock(progress);
        }
        BOOL isSuccess = NO;
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                NSLog(@"Cancelled");
                break;
            case AVAssetImageGeneratorFailed:
                NSLog(@"Failed");
                break;
            case AVAssetImageGeneratorSucceeded: {
                UIImage *frameImg = [UIImage imageWithCGImage:image];
                [imagesArr addObject:frameImg];
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
        }
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
    NSURL *videoUrl = [NSURL URLWithString:movieLocalPath];
    
    NSError *error = nil;
    //图像和音频写成一个完整的视频文件
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:videoUrl fileType:AVFileTypeQuickTimeMovie error:&error];
    
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
            UIImage *currentImg = imagesArr[count];
            buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:currentImg.CGImage size:imageSize];
            if (progress) {
                CGFloat progressValue = count * 1.0 / imagesArr.count;
                progress(progressValue);
            }
            if (buffer) {
                if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(count, fps)]) {
                    NSLog(@"FAIL");
                    if (complete) {
                        complete(NO,@"Failed");
                    }
                } else {
                    CFRelease(buffer);
                    buffer = NULL;
                }
            }
        }
    }];
}
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
@end
