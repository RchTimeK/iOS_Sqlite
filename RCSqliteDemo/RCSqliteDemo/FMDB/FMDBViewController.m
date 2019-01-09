//
//  FMDBViewController.m
//  RCSqliteDemo
//
//  Created by RongCheng on 2019/1/8.
//  Copyright © 2019年 RongCheng. All rights reserved.
//

#import "FMDBViewController.h"
#import "FMDB.h"
@interface FMDBViewController ()
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation FMDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"FMDB";
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"Contacts.sqlite"];
    //获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    _db = db;
    if(db.open){
        NSString *sql = @"create table if not exists t_contacts (id integer primary key autoincrement,name text,phone text);";
        //创建表
        if ([db executeUpdate:sql]) {
            NSLog(@"创建表成功！");
        }else{
            NSLog(@"创建表失败！");
        }
        NSLog(@"数据库打开成功");
    }else{
        NSLog(@"数据库打开失败");
    }
}

// 增
- (IBAction)insert:(id)sender {
    BOOL success = [_db executeUpdate:@"insert into t_contacts (name,phone) values (?,?);",@"小虎牙",@"666666"];
    if(success){
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }
}

// 删
- (IBAction)delete:(id)sender {
    BOOL success = [_db executeUpdate:@"delete from t_contacts;"];
    if(success){
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}

// 改
- (IBAction)update:(id)sender{
    BOOL success = [_db executeUpdate:@"update t_contacts set name = ?;",@"幸福的小虎牙"];
    if(success){
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }
}

// 查
- (IBAction)select:(id)sender{
    FMResultSet *result = [_db executeQuery:@"select * from t_contacts;"];
    while ([result next]) {
        NSString *name = [result stringForColumn:@"name"];
        NSString *phone = [result stringForColumn:@"phone"];
        NSLog(@"%@--%@",name,phone);
    }
}

@end
