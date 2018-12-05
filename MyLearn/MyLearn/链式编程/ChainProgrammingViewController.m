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
@property (nonatomic, strong) NSString *openCode;
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
        self.openCode = [self.arr firstObject][@"opencode"];
        
    } failBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"2");
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self show];
}
- (void)show{
    NSArray *red = [[[_openCode componentsSeparatedByString:@"+"] firstObject] componentsSeparatedByString:@","];
    NSArray *blue = [[[_openCode componentsSeparatedByString:@"+"] lastObject] componentsSeparatedByString:@","];
    NSSet *redArr = [self getNumberMax:35 andGetCount:5 andData:[NSSet setWithArray:red] AndIgnore:NO] ;
    NSSet *blueArr = [self getNumberMax:12 andGetCount:2 andData:[NSSet setWithArray:blue] AndIgnore:YES];
    
    NSArray *result = [redArr.allObjects sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return  [@([obj1 intValue]) compare:@([obj2 intValue])];
    }];
    NSArray *result1 = [blueArr.allObjects sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [@([obj1 intValue]) compare:@([obj2 intValue])];
    }];
    NSString *str = [NSString stringWithFormat:@"%@ + %@",[result componentsJoinedByString:@","],[result1 componentsJoinedByString:@","]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"结果%@",_openCode] message:str preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (NSSet *)getNumberMax:(NSInteger)max andGetCount:(NSInteger)count andData:(NSSet *)dataSet AndIgnore:(BOOL)ignore{
    NSMutableSet *codeSet = [NSMutableSet set];
    do {
        NSString *code = [NSNumber numberWithLong:arc4random()%(long)[[NSDate date] timeIntervalSince1970]%max + 1].stringValue;
        
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
