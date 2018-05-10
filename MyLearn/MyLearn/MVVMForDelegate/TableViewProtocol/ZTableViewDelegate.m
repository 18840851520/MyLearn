//
//  ZTableViewDelegate.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/5/10.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "ZTableViewDelegate.h"

@implementation ZTableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_array.count){
        NSLog(@"didSelect%ld",indexPath.row);
    }
}

@end
