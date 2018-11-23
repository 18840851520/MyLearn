//
//  ChainProgrammingViewController.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/6/25.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "ChainProgrammingViewController.h"
#import "Calculate.h"
#import "ZNetServer.h"

@interface ChainProgrammingViewController ()

@property (nonatomic, strong) NSArray *arr;
@end

@implementation ChainProgrammingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSInteger result = [Calculate markCalculate:^(Calculate *ma) {
        (void)ma.add(arc4random() % 10).printfResult.sub(arc4random() % 20);
    }];
    NSLog(@"%ld",result);
    
    [ZNetServer postValueWithMethod:@"http://f.apiplus.net/dlt.json" andBody:nil successBlock:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response) {
        self.arr = [response valueForKey:@"data"];
        NSString *openCode = [self.arr firstObject][@"opencode"];
        NSArray *red = [[[openCode componentsSeparatedByString:@"+"] firstObject] componentsSeparatedByString:@","];
        NSArray *blue = [[[openCode componentsSeparatedByString:@"+"] lastObject] componentsSeparatedByString:@","];
        NSSet *redArr = [self getNumberMax:35 andGetCount:5 andData:[NSSet setWithArray:red] AndIgnore:NO] ;
        NSSet *blueArr = [self getNumberMax:12 andGetCount:2 andData:[NSSet setWithArray:blue] AndIgnore:YES];
        NSString *str = [NSString stringWithFormat:@"%@ + %@",[redArr.allObjects componentsJoinedByString:@","],[blueArr.allObjects componentsJoinedByString:@","]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"结果%@",openCode] message:str preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } failBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"2");
    }];
}
- (NSSet *)getNumberMax:(NSInteger)max andGetCount:(NSInteger)count andData:(NSSet *)dataSet AndIgnore:(BOOL)ignore{
    NSMutableSet *codeSet = [NSMutableSet set];
    do {
        NSString *code = [NSNumber numberWithLong:random()%(long)[[NSDate date] timeIntervalSince1970]%max].stringValue;
        if (codeSet.count == 0 && !ignore) {
            if ([dataSet containsObject:code]) {
                 [codeSet addObject:code];
            }
        }else{
             [codeSet addObject:code];
        }
    } while (codeSet.count < count);
    return codeSet.copy;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
