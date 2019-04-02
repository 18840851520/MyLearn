//
//  LotteryViewController.m
//  MyLearn
//
//  Created by jianhua zhang on 2019/4/2.
//  Copyright © 2019 jianhua zhang. All rights reserved.
//

#import "LotteryViewController.h"
#import "ZNetServer.h"
#import "LotteryRandom.h"

@interface LotteryViewController ()

@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) NSString *openCode;
@property (weak, nonatomic) IBOutlet UITextField *frontTF;
@property (weak, nonatomic) IBOutlet UITextField *backTF;

@property (nonatomic, strong) NSArray *doubleArr;
@property (nonatomic, strong) NSString *doubleOpenCode;

@end

@implementation LotteryViewController

- (IBAction)endEdit:(UITextField *)sender {
    NSString *str = sender.text;
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"，" withString:@","];
    sender.text = str;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUserDefalut];
    
    [self initDoubleDefalut];
    
    [ZNetServer postValueWithMethod:@"http://f.apiplus.net/dlt-20.json" andBody:nil successBlock:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response) {
        self.arr = [response valueForKey:@"data"];
        self.openCode = [self.arr firstObject][@"opencode"];
        [self updateData:self.arr];
    } failBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"2");
    }];
    
//
    [ZNetServer postValueWithMethod:@"http://f.apiplus.net/ssq-20.json" andBody:nil successBlock:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response) {
        self.doubleArr = [response valueForKey:@"data"];
        self.doubleOpenCode = [self.doubleArr firstObject][@"opencode"];
        [self updateDoubleData:self.doubleArr];
    } failBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"2");
    }];
}

//更新近几期的统计数据
- (void)updateDoubleData:(NSArray *)arr{
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *frontZone = [NSMutableDictionary dictionaryWithDictionary:[data valueForKey:@"doubleFrontZone"]];
    NSMutableDictionary *backZone = [NSMutableDictionary dictionaryWithDictionary:[data valueForKey:@"doubleBackZone"]];
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *dict = arr[i];
        if ([[dict valueForKey:@"expect"] integerValue] <= [[data valueForKey:@"doubleexpect"] integerValue]) {
            break;
        }
        if (i == 0) {
            [data setObject:[dict valueForKey:@"expect"] forKey:@"doubleexpect"];
            NSLog(@"expect %@",[dict valueForKey:@"expect"]);
        }
        NSString *openCode = [dict valueForKey:@"opencode"];
        NSArray *blueArr = [[[openCode componentsSeparatedByString:@"+"] firstObject] componentsSeparatedByString:@","];
        NSArray *redArr = [[[openCode componentsSeparatedByString:@"+"] lastObject] componentsSeparatedByString:@","];
        for (NSString *str in blueArr) {
            [frontZone setValue:[NSNumber numberWithInteger:(int)[frontZone[str] integerValue] + 1].stringValue forKey:str];
        }
        for (NSString *str in redArr) {
            [backZone setValue:[NSNumber numberWithInteger:(int)[backZone[str] integerValue] + 1].stringValue forKey:str];
        }
    }
    
    [data setObject:frontZone forKey:@"doubleFrontZone"];
    [data setObject:backZone forKey:@"doubleBackZone"];
    
    NSLog(@"doubleFrontZone %@",frontZone);
    NSLog(@"doubleBackZone %@",backZone);
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//初始化数据
- (void)initDoubleDefalut{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"doubleexpect"]) {
        return;
    }
    NSDictionary *frontZone = @{
                                @"01":@"22",
                                @"02":@"19",
                                @"03":@"17",
                                @"04":@"17",
                                @"05":@"21",
                                @"06":@"20",
                                @"07":@"17",
                                @"08":@"19",
                                @"09":@"14",
                                @"10":@"24",
                                @"11":@"26",
                                @"12":@"10",
                                @"13":@"19",
                                @"14":@"17",
                                @"15":@"23",
                                @"16":@"15",
                                @"17":@"13",
                                @"18":@"22",
                                @"19":@"23",
                                @"20":@"18",
                                @"21":@"18",
                                @"22":@"19",
                                @"23":@"21",
                                @"24":@"16",
                                @"25":@"22",
                                @"26":@"16",
                                @"27":@"15",
                                @"28":@"17",
                                @"29":@"13",
                                @"30":@"11",
                                @"31":@"15",
                                @"32":@"21",
                                @"33":@"20",
                                };
    NSDictionary *backZone = @{
                               @"01":@"10",
                               @"02":@"7",
                               @"03":@"4",
                               @"04":@"7",
                               @"05":@"6",
                               @"06":@"4",
                               @"07":@"6",
                               @"08":@"2",
                               @"09":@"7",
                               @"10":@"4",
                               @"11":@"7",
                               @"12":@"8",
                               @"13":@"6",
                               @"14":@"6",
                               @"15":@"8",
                               @"16":@"8"
                               };
    [[NSUserDefaults standardUserDefaults] setObject:frontZone forKey:@"doubleFrontZone"];
    [[NSUserDefaults standardUserDefaults] setObject:backZone forKey:@"doubleBackZone"];
    [[NSUserDefaults standardUserDefaults] setObject:@"2019036" forKey:@"doubleexpect"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



//更新近几期的统计数据
- (void)updateData:(NSArray *)arr{
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *frontZone = [NSMutableDictionary dictionaryWithDictionary:[data valueForKey:@"frontZone"]];
    NSMutableDictionary *backZone = [NSMutableDictionary dictionaryWithDictionary:[data valueForKey:@"backZone"]];
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *dict = arr[i];
        if ([[dict valueForKey:@"expect"] integerValue] <= [[data valueForKey:@"expect"] integerValue]) {
            break;
        }
        if (i == 0) {
            [data setObject:[dict valueForKey:@"expect"] forKey:@"expect"];
            NSLog(@"expect %@",[dict valueForKey:@"expect"]);
        }
        NSString *openCode = [dict valueForKey:@"opencode"];
        NSArray *blueArr = [[[openCode componentsSeparatedByString:@"+"] firstObject] componentsSeparatedByString:@","];
        NSArray *redArr = [[[openCode componentsSeparatedByString:@"+"] lastObject] componentsSeparatedByString:@","];
        for (NSString *str in blueArr) {
            [frontZone setValue:[NSNumber numberWithInteger:(int)[frontZone[str] integerValue] + 1].stringValue forKey:str];
        }
        for (NSString *str in redArr) {
            [backZone setValue:[NSNumber numberWithInteger:(int)[backZone[str] integerValue] + 1].stringValue forKey:str];
        }
    }
    
    [data setObject:frontZone forKey:@"frontZone"];
    [data setObject:backZone forKey:@"backZone"];
    
    NSLog(@"frontZone %@",frontZone);
    NSLog(@"backZone %@",backZone);
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//初始化数据
- (void)initUserDefalut{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"expect"]) {
        return;
    }
    NSDictionary *frontZone = @{
                                @"01":@"15",
                                @"02":@"7",
                                @"03":@"19",
                                @"04":@"16",
                                @"05":@"10",
                                @"06":@"16",
                                @"07":@"20",
                                @"08":@"16",
                                @"09":@"11",
                                @"10":@"10",
                                @"11":@"14",
                                @"12":@"17",
                                @"13":@"15",
                                @"14":@"21",
                                @"15":@"11",
                                @"16":@"20",
                                @"17":@"12",
                                @"18":@"19",
                                @"19":@"16",
                                @"20":@"12",
                                @"21":@"17",
                                @"22":@"13",
                                @"23":@"10",
                                @"24":@"15",
                                @"25":@"11",
                                @"26":@"16",
                                @"27":@"14",
                                @"28":@"17",
                                @"29":@"17",
                                @"30":@"12",
                                @"31":@"13",
                                @"32":@"9",
                                @"33":@"18",
                                @"34":@"14",
                                @"35":@"7"
                                };
    NSDictionary *backZone = @{
                               @"01":@"19",
                               @"02":@"21",
                               @"03":@"18",
                               @"04":@"20",
                               @"05":@"16",
                               @"06":@"19",
                               @"07":@"16",
                               @"08":@"13",
                               @"09":@"12",
                               @"10":@"16",
                               @"11":@"16",
                               @"12":@"14"
                               };
    [[NSUserDefaults standardUserDefaults] setObject:frontZone forKey:@"frontZone"];
    [[NSUserDefaults standardUserDefaults] setObject:backZone forKey:@"backZone"];
    [[NSUserDefaults standardUserDefaults] setObject:@"2019034" forKey:@"expect"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self newShow];
}
- (void)newShow{
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *frontZone = [NSMutableDictionary dictionaryWithDictionary:[data valueForKey:@"frontZone"]];
    NSMutableDictionary *backZone = [NSMutableDictionary dictionaryWithDictionary:[data valueForKey:@"backZone"]];
    
    NSMutableDictionary *dfrontZone = [NSMutableDictionary dictionaryWithDictionary:[data valueForKey:@"doubleFrontZone"]];
    NSMutableDictionary *dbackZone = [NSMutableDictionary dictionaryWithDictionary:[data valueForKey:@"doubleBackZone"]];
    
    NSArray *redKillArr;
    NSArray *blueKillArr;
    if (self.frontTF.text) {
        redKillArr = [self.frontTF.text componentsSeparatedByString:@","];
    }
    if (self.backTF.text) {
        blueKillArr = [self.backTF.text componentsSeparatedByString:@","];
    }
    
    NSString *str;
    if (redKillArr.count > 28 || blueKillArr.count > 10) {
        
        str = @"杀号超出限制";
        
    }else{
        NSArray *redArr = [LotteryRandom getResultNumber:frontZone andCount:5 andKillNo:redKillArr];
        NSArray *blueArr = [LotteryRandom getResultNumber:backZone andCount:2 andKillNo:blueKillArr];
        
        NSArray *result = [redArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return  [@([obj1 intValue]) compare:@([obj2 intValue])];
        }];
        NSArray *result1 = [blueArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [@([obj1 intValue]) compare:@([obj2 intValue])];
        }];
        
        NSArray *dredArr = [LotteryRandom getResultNumber:dfrontZone andCount:6 andKillNo:redKillArr];
        NSArray *dblueArr = [LotteryRandom getResultNumber:dbackZone andCount:1 andKillNo:blueKillArr];
        
        NSArray *dresult = [dredArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return  [@([obj1 intValue]) compare:@([obj2 intValue])];
        }];
        NSArray *dresult1 = [dblueArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [@([obj1 intValue]) compare:@([obj2 intValue])];
        }];
        str = [NSString stringWithFormat:@"随机\n大乐透:%@ + %@\n 双色球:%@ + %@",[result componentsJoinedByString:@","],[result1 componentsJoinedByString:@","],[dresult componentsJoinedByString:@","],[dresult1 componentsJoinedByString:@","]];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:[NSString stringWithFormat:@"上期结果\n大乐透:%@\n双色球:%@",_openCode,_doubleOpenCode] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
