//
//  AwardsViewController.m
//  MyLearn
//
//  Created by jianhua zhang on 2019/12/11.
//  Copyright © 2019 jianhua zhang. All rights reserved.
//

#import "AwardsViewController.h"

@interface AwardsViewController ()

@property (nonatomic, strong) NSMutableArray *allRed;
@property (nonatomic, strong) NSMutableArray *allBlue;


@property (nonatomic, strong) NSMutableArray *viewRed;
@property (nonatomic, strong) NSMutableArray *viewBlue;

@property (weak, nonatomic) IBOutlet UITextField *viewRedTF;
@property (weak, nonatomic) IBOutlet UITextField *viewBlueTF;

@property (weak, nonatomic) IBOutlet UILabel *lb;

@property (nonatomic, strong) NSMutableArray *selecRed;
@property (nonatomic, strong) NSMutableArray *selecBlue;
@end

@implementation AwardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allRed = [NSMutableArray array];
    self.allBlue = [NSMutableArray array];
    self.viewRed = [NSMutableArray array];
    self.viewBlue = [NSMutableArray array];
    self.selecRed = [NSMutableArray array];
    self.selecBlue = [NSMutableArray array];
    
    self.viewRedTF.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"redball"];
    self.viewBlueTF.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"blueball"];
}

- (void)random{
    
    [[NSUserDefaults standardUserDefaults] setValue:self.viewRedTF.text forKey:@"redball"];
    [[NSUserDefaults standardUserDefaults] setValue:self.viewBlueTF.text forKey:@"blueball"];
    
    [self.allRed removeAllObjects];
    [self.allBlue removeAllObjects];
    [self.viewRed removeAllObjects];
    [self.viewBlue removeAllObjects];
    [self.selecRed removeAllObjects];
    [self.selecBlue removeAllObjects];
    
    
    for (int i = 1; i <= 35; i++) {
        NSNumber *number = [NSNumber numberWithInt:i];
        if (i <= 12) {
            [self.allBlue addObject:number.stringValue];
        }
        [self.allRed addObject:number.stringValue];
    }
    
    [self.viewRed addObjectsFromArray:[self.viewRedTF.text componentsSeparatedByString:@","]];
    [self.viewBlue addObjectsFromArray:[self.viewBlueTF.text componentsSeparatedByString:@","]];

    if (self.viewBlue) {
        
        NSInteger index = arc4random() % self.viewBlue.count;
        id obj = [self.viewBlue objectAtIndex:index];
        [self.selecBlue addObject:obj];
        [self.allBlue removeObject:obj];
        
        NSInteger index0 = arc4random() % self.allBlue.count;
        id obj0 = [self.allBlue objectAtIndex:index0];
        [self.selecBlue addObject:obj0];
        
    }
    
    if (self.viewRed) {
        
        NSInteger index1 = arc4random() % self.viewRed.count;
        id obj1 = [self.viewRed objectAtIndex:index1];
        [self.selecRed addObject:obj1];
        [self.viewRed removeObject:obj1];
        
        NSInteger index2 = arc4random() % self.viewRed.count;
        id obj2 = [self.viewRed objectAtIndex:index2];
        [self.selecRed addObject:obj2];
        [self.viewRed removeObject:obj2];
        
        [self.allRed removeObject:obj1];
        [self.allRed removeObject:obj2];
    }
    

    
    
    NSInteger index3 = arc4random() % self.allRed.count;
    id obj3 = [self.allRed objectAtIndex:index3];
    [self.selecRed addObject:obj3];
    [self.allRed removeObject:obj3];
    
    NSInteger index4 = arc4random() % self.allRed.count;
    id obj4 = [self.allRed objectAtIndex:index4];
    [self.selecRed addObject:obj4];
    [self.allRed removeObject:obj4];
    
    NSInteger index5 = arc4random() % self.allRed.count;
    id obj5 = [self.allRed objectAtIndex:index5];
    [self.selecRed addObject:obj5];

    self.lb.text = [NSString stringWithFormat:@"%@+%@",[self.selecRed componentsJoinedByString:@","],[self.selecBlue componentsJoinedByString:@","]];
}
- (IBAction)red:(UITextField *)sender {
    NSString *str = sender.text;
    [str stringByReplacingOccurrencesOfString:@"，" withString:@","];
}
- (IBAction)blue:(UITextField *)sender {
    NSString *str = sender.text;
    [str stringByReplacingOccurrencesOfString:@"，" withString:@","];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self random];
}
@end
