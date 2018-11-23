//
//  GCDViewController.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/5/8.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"1");
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSLog(@"2");
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"4");
            self.view.backgroundColor = [UIColor greenColor];
        });
    });
    NSLog(@"3");
}

- (IBAction)dowork:(id)sender {
    NSDate *startdate = [NSDate date];
    NSString *fe = [self fetchSomethingFromServer];
    NSString *pro = [self processData:fe];
    NSString *fir = [self calculateFirstResult:pro];
    NSString *se = [self calculateSecondResult:pro];
    NSString *result = [NSString stringWithFormat:@"first=%@\nsecond=\n",fir,se];
    self.resultTextView.text = result;
    NSDate *enddate = [NSDate date];
    NSLog(@"complete in %f seconds",[enddate timeIntervalSinceDate:startdate]);
}
- (NSString *)fetchSomethingFromServer{
    [NSThread sleepForTimeInterval:1];
    return @"Hi here";
}
- (NSString *)processData:(NSString *)data{
    [NSThread sleepForTimeInterval:2];
    return [data uppercaseString];
}
- (NSString *)calculateFirstResult:(NSString *)data{
    [NSThread sleepForTimeInterval:3];
    return [NSString stringWithFormat:@"Number of chars:%ld",[data length]];
}
- (NSString *)calculateSecondResult:(NSString *)data{
    [NSThread sleepForTimeInterval:4];
    return [data stringByReplacingOccurrencesOfString:@"E" withString:@"e"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
