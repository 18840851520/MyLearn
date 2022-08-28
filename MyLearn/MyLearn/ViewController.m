//
//  ViewController.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/4/9.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "ViewController.h"
#import "AnimationViewController.h"
#import "FacadeViewController.h"
#import "ZMVVMViewController.h"
#import "BlueToothInstance.h"
#import "ChainProgrammingViewController.h"
#import "RuntimeViewController.h"
#import "RunLoopViewController.h"
#import "GCDViewController.h"
#import "MasonryViewController.h"
#import "ErrorViewController.h"
#import "VideoViewController.h"
#import "Lottery1ViewController.h"
#import "AwardsViewController.h"

#import "MyLearn-Swift.h"



@interface Father: NSObject
-(void)easeapi;
@end
@implementation Father
-(void)easeapi {
    //your code
    NSLog(@"test 1");
}
@end

//Son1继承自Father
@interface Son1: Father
@end
@implementation Son1

- (instancetype)init{
    if (self = [super init]) {
        NSLog(@"%@",NSStringFromClass([self class]));
        NSLog(@"%@",NSStringFromClass([super class]));
    }
    return self;
}
@end

//Son2继承自Father，并HOOK了easeapi方法。
@interface Son2: Father
@end
@implementation Son2
+ (void)load {
    
    Class class1 = [self class];

    SEL fromSelector = @selector(easeapi);
    SEL toSelector = @selector(new_easeapi);

    Method fromMethod = class_getInstanceMethod(class1, fromSelector);
    Method toMethod = class_getInstanceMethod(class1, toSelector);

    method_exchangeImplementations(fromMethod, toMethod);
    
    
    static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class class1 = [self class];

            SEL fromSelector = @selector(easeapi);
            SEL toSelector = @selector(new_easeapi);

            Method fromMethod = class_getInstanceMethod(class1, fromSelector);
            Method toMethod = class_getInstanceMethod(class1, toSelector);

            if(class_addMethod(class1, fromSelector, method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
                class_replaceMethod(class1, toSelector, method_getImplementation(fromMethod), method_getTypeEncoding(fromMethod));
            } else {
                method_exchangeImplementations(fromMethod, toMethod);
            }
        });
    
}
-(void)new_easeapi {
    [self new_easeapi];
    //your code
    NSLog(@"test123");
}
-(void)easeapi {
    //your code
    NSLog(@"test 1");
}
@end




@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) NSArray *typeArray;

@end

@implementation ViewController

- (void)printfLog{
    NSLog(@"ViewController：2");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    Son2 *son = [[Son2 alloc] init];
    [son easeapi];
    Son1 *son1 = [[Son1 alloc] init];
    [son1 easeapi];
    
    MyLearnSwift *swiftClass = [[MyLearnSwift alloc] init];
        
    dispatch_sync(dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT), ^{
        NSLog(@"ViewController：1");
        
        [self performSelector:@selector(printfLog) withObject:nil afterDelay:0];
        NSLog(@"ViewController：3");
    });
    
    self.typeArray = @[@"动画",@"单例",@"Facade(门面模式)",@"MVVM",@"BlueTooth",@"链式编程",@"runtime",@"RunLoop",@"GCD",@"Masonry",@"验证",@"视频",@"彩票",@"彩票1"];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _typeArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.clipsToBounds = YES;
    cell.textLabel.text = self.typeArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = nil;
    switch (indexPath.row) {
        case 0:
            vc = [[AnimationViewController alloc] init];
            break;
        case 2:
            vc = [[FacadeViewController alloc] init];
            break;
        case 5:
            vc = [[ChainProgrammingViewController alloc] init];
            break;
        case 6:
            vc = [[RuntimeViewController alloc] init];
            break;
        case 7:
            vc = [[RunLoopViewController alloc] init];
            break;
        case 8:
            vc = [[GCDViewController alloc] init];
            break;
        case 9:
            vc = [[MasonryViewController alloc] init];
            break;
        case 10:
            vc = [[ErrorViewController alloc] init];
            break;
        case 11:
            vc = [[VideoViewController alloc] init];
            break;
        case 12:
            vc = [[Lottery1ViewController alloc] init];
//            vc = [[AwardsViewController alloc] init];
            break;
        case 13:
            vc = [[AwardsViewController alloc] init];
            break;
        case 14:
            
            break;
        default:
            break;
    }
    if (vc) {
        vc.title = self.typeArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
#ifdef DEBUG
    return 44;
#else
    if (indexPath.row != 12) {
        return 0;
    }
    return 44;
#endif
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)faceID{
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"验证信息" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"验证成功");
            }else{
                
            }
        }];
    }else{
        
    }
}

@end
