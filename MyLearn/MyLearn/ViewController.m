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

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) NSArray *typeArray;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.typeArray = @[@"动画",@"单例",@"Facade",@"MVVM"];
    
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
    if(indexPath.row == 0){
        vc = [[AnimationViewController alloc] init];
    }else if (indexPath.row == 1){
        
    }else if (indexPath.row == 2){
        vc = [[FacadeViewController alloc] init];
    }else{
        vc = [[ZMVVMViewController alloc] init];
    }
    vc.title = self.typeArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
