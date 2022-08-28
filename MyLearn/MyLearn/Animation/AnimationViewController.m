//
//  AnimationViewController.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/5/10.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "AnimationViewController.h"
#import "ShapeLayerLearn.h"
#import "LoginView.h"
#import "JHBounceView.h"
#import "NextAnimationViewController.h"
#import "BrokenLineView.h"
#import "VideoCollectionViewCell.h"
#import "PageFlowLayout.h"

@interface AnimationViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) LoginView *forgetView;

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgImage.image = [UIImage imageNamed:@"123456"];
    bgImage.contentMode = UIViewContentModeRight;
    [self.view addSubview:bgImage];
    
//    ShapeLayerLearn *shape = [[ShapeLayerLearn alloc] initWithFrame:CGRectMake(10, 80, 80, 80)];
//
//    [self.view addSubview:shape];
    
    self.loginView = [[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:nil options:nil].lastObject;
    self.loginView.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds) * 6 / 5);
    self.loginView.minT = 0.9;
    
    __weak typeof(self)weakSelf = self;
    self.loginView.selectBlock = ^{
        weakSelf.forgetView.isSelect = NO;
    };
    self.loginView.loginBlock = ^{
        JHBounceView *view = [[JHBounceView alloc] initWithSuperView:weakSelf.view];
        view.startAnimation = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __block typeof(view)blockview = view;
            [view endAnimation:^{
                [weakSelf presentNextVC];
            }];
        });
    };
    [self.view addSubview:self.loginView];
    
    self.forgetView = [[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:nil options:nil].lastObject;
    self.forgetView.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds) * 8 / 5);
    self.forgetView.minT = 0.9;
    
    self.forgetView.selectBlock = ^{
        weakSelf.loginView.isSelect = NO;
    };
    [self.view addSubview:self.forgetView];
    
    self.forgetView.isSelect = NO;
    self.loginView.isSelect = YES;
    
    BrokenLineView *view = [[BrokenLineView alloc] initWithFrame:CGRectMake(0, 80, 768, 300) withDataArray:@[
    @{
        @"dayDate":@"9-24",
        @"correctQuestions":@"10",
        @"completeQuestions":@"5",
        @"promotion":@"0"
    },
    @{
        @"dayDate":@"9-25",
        @"correctQuestions":@"20",
        @"completeQuestions":@"12",
        @"promotion":@"0"
    },
    @{
        @"dayDate":@"9-26",
        @"correctQuestions":@"30",
        @"completeQuestions":@"20",
        @"promotion":@"1"
    },
    @{
        @"dayDate":@"9-26",
        @"correctQuestions":@"40",
        @"completeQuestions":@"24",
        @"promotion":@"1"
    },
    @{
        @"dayDate":@"9-26",
        @"correctQuestions":@"30",
        @"completeQuestions":@"27",
        @"promotion":@"1"
    },
    @{
        @"dayDate":@"9-26",
        @"correctQuestions":@"10",
        @"completeQuestions":@"3",
        @"promotion":@"1"
    }]];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    PageFlowLayout *layout = ({
        PageFlowLayout *layout = [[PageFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(160, 160);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat margin = (768 - 160) *0.5;
        layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);//四周的边距
        //设置最小边距
        layout.minimumLineSpacing = 50;
        
        layout;
    });
    
    
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, 768, 300) collectionViewLayout:layout];
    collectView.backgroundColor = [UIColor whiteColor];
    collectView.delegate = self;
    collectView.dataSource = self;
    [self.view addSubview:collectView];
    [collectView registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"VideoCollectionViewCell"];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIView animateWithDuration:0.8 animations:^{
        self.loginView.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds) * 3 / 7);
        
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:1 animations:^{
        self.forgetView.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds) * 4 / 7);
    }];
}
- (void)presentNextVC{
    NextAnimationViewController *vc = [[NextAnimationViewController alloc] init];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}
@end
