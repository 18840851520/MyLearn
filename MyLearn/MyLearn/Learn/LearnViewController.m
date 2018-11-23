//
//  LearnViewController.m
//  MyLearn
//
//  Created by 划落永恒 on 2018/11/23.
//  Copyright © 2018 jianhua zhang. All rights reserved.
//

#import "LearnViewController.h"

@interface LearnViewController ()

@end

@implementation LearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的学习";
}
- (void)keyChainAdd{
    NSDictionary *data = @{
                           (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleWhenUnlocked,
                           
                           };
    OSStatus success = SecItemAdd((__bridge CFDictionaryRef) data, nil);
    if (success) {
        
    }
    
    NSDictionary *query = @{(__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleWhenUnlocked,
                            (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecValueData : [@"1234562" dataUsingEncoding:NSUTF8StringEncoding],
                            (__bridge id)kSecAttrAccount : @"account name",
                            (__bridge id)kSecAttrService : @"loginPassword",
                            };
    CFErrorRef error = NULL;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, nil);
}


@end
