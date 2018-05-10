//
//  ZMVVMViewController.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/5/10.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "ZMVVMViewController.h"
#import "ZModel.h"
#import "ZTableViewDataSource.h"
#import "ZTableViewDelegate.h"
#import "ZViewModel.h"

@interface ZMVVMViewController ()

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) ZTableViewDelegate *zdelegate;

@property (nonatomic, strong) ZTableViewDataSource *zdatasource;

@property (nonatomic, strong) ZViewModel *zviewmodel;

@end

@implementation ZMVVMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.zdelegate = [[ZTableViewDelegate alloc] init];
    self.zdatasource = [[ZTableViewDataSource alloc] init];
    self.zviewmodel = [[ZViewModel alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self.zdatasource;
    self.tableView.delegate = self.zdelegate;
    
    self.zdatasource.array = @[@"1",@"2",@"3"];
    self.zdelegate.array = @[@"1",@"2",@"3"];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
