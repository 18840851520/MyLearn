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
    
    dispatch_sync(dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT), ^{
        NSLog(@"ViewController：1");
        
        [self performSelector:@selector(printfLog) withObject:nil afterDelay:0];
        NSLog(@"ViewController：3");
    });
    
    self.typeArray = @[@"动画",@"单例",@"Facade(门面模式)",@"MVVM",@"BlueTooth",@"链式编程",@"runtime",@"RunLoop",@"GCD",@"Masonry",@"验证"];
    
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
    cell.textLabel.text = self.typeArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc;
    switch (indexPath.row) {
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
        default:
            break;
    }
    if(indexPath.row == 0){
        vc = [[AnimationViewController alloc] init];
    }else if (indexPath.row == 1){
        
    }else if (indexPath.row == 2){
        vc = [[FacadeViewController alloc] init];
    }else if(indexPath.row == 5){
        vc = [[ChainProgrammingViewController alloc] init];
    }else{
        
    }
    vc.title = self.typeArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
