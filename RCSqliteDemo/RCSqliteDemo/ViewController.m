//
//  ViewController.m
//  RCSqliteDemo
//
//  Created by RongCheng on 2019/1/8.
//  Copyright © 2019年 RongCheng. All rights reserved.
//

#import "ViewController.h"
#import "SqliteTestController.h"
#import "FuzzyQueryController.h"
#import "FMDBViewController.h"
#import "FMDBQueueController.h"
#import "NewsCacheViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Sqlite详解";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellID];
    }
    cell.textLabel.text = @[@"Sqlite原生学习",@"模糊查询",@"FMDB简单使用",@"FMDB多线程与事务",@"数据缓存（以头条为例）"][indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc;
    switch (indexPath.row) {
        case 0:
            vc = [[SqliteTestController alloc]init];
            break;
        case 1:
            vc = [[FuzzyQueryController alloc]init];
            break;
        case 2:
            vc = [[FMDBViewController alloc]init];
            break;
        case 3:
            vc = [[FMDBQueueController alloc]init];
            break;
        case 4:
            vc = [[NewsCacheViewController alloc]init];
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
@end
