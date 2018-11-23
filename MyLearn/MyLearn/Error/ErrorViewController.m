//
//  ErrorViewController.m
//  MyLearn
//
//  Created by 划落永恒 on 2018/11/23.
//  Copyright © 2018 jianhua zhang. All rights reserved.
//

#import "ErrorViewController.h"

@interface ErrorViewController ()

@property (nonatomic, copy)NSMutableArray *mArr;
@property (nonatomic, strong)NSMutableArray *mArr1;
@end

@implementation ErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"验证集合";
    [self copyAndMutableCopyDiffrient];
    [self copyObjectDiffrient];
}
#pragma mark - copy和MuttableCopy
- (void)copyAndMutableCopyDiffrient{
    NSString *string = @"string";
    NSString *string1 = @"string";
    NSMutableString *mStr = [NSMutableString stringWithString:string];
    
    NSString *cStr = [string copy];
    NSString *mcStr = [string mutableCopy];
    
    NSString *cMStr =[mStr copy];
    NSString *mcmStr = [mStr mutableCopy];
    NSLog(@"%p - %p - %p - %p - %p - %p - %p",string,string1,mStr,cStr,mcStr,cMStr,mcmStr);
    NSLog(@"copy = %d - %d - %d - %d - %d",string == string1,cStr == string,mcStr == string,cMStr == mStr,mcmStr == mStr);
}
- (void)copyObjectDiffrient{
    NSArray *arr = @[@"123", @"456", @"asd"];
    self.mArr = arr;
    NSLog(@"\n arrP = %p \n self.mArrP = %p, self.mArr class = %@", arr, self.mArr, [self.mArr class]);
    
    self.mArr1 = [arr copy];
    NSLog(@"\n arrP = %p \n self.mArrP = %p, self.mArr class = %@", arr, self.mArr1, [self.mArr1 class]);
}


@end
