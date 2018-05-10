//
//  ZTableViewDataSource.m
//  MyLearn
//
//  Created by jianhua zhang on 2018/5/10.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "ZTableViewDataSource.h"
#import "ZTableViewCell.h"

@implementation ZTableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTableViewCell"];
    if(!cell){
        cell = [[ZTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZTableViewCell"];
    }
    cell.textLabel.text = _array[indexPath.row];
    return cell;
}

@end
