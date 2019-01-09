//
//  FMDBQueueController.m
//  RCSqliteDemo
//
//  Created by RongCheng on 2019/1/8.
//  Copyright © 2019年 RongCheng. All rights reserved.
//

#import "FMDBQueueController.h"
#import "FMDB.h"
@interface FMDBQueueController ()
@property (nonatomic, strong) FMDatabaseQueue *queue;
@end

@implementation FMDBQueueController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"多线程与事务";
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"User.sqlite"];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    _queue = queue;
    [queue inDatabase:^(FMDatabase *db) {
        BOOL success =  [db executeUpdate:@"create table if not exists t_user (id integer primary key autoincrement,name text,money integer)"];
        if (success) {
            NSLog(@"创建表成功");
        }else{
            NSLog(@"创建表失败");
        }
    }];
}

// 增
- (IBAction)insert:(id)sender {
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL success = [db executeUpdate:@"insert into t_user (name,money) values (?,?)",@"a",@10];
        if(success){
            NSLog(@"a插入成功");
        }else{
            NSLog(@"a插入失败");
        }
        
        BOOL successB = [db executeUpdate:@"insert into t_user (name,money) values (?,?)",@"b",@5];
        if(successB){
            NSLog(@"b插入成功");
        }else{
            NSLog(@"b插入失败");
        }
    }];
}

// 删
- (IBAction)delete:(id)sender {
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL success = [db executeUpdate:@"delete from t_user;"];
        if (success) {
            NSLog(@"删除成功");
        }else{
            NSLog(@"删除失败");
        }
    }];
}

// 改
- (IBAction)update:(id)sender{
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        
        // 开启事务
        [db beginTransaction];
        
        BOOL success = [db executeUpdate:@"update t_user set money = ? where name = ?;",@5,@"a"];
        if (success) {
            NSLog(@"更新成功");
        }else{
            NSLog(@"更新失败");
            // 回滚
            [db rollback];
        }
        
        BOOL success1 = [db executeUpdate:@"update t_user set money = ? where name = ?;",@10,@"b"];
        if (success1) {
            NSLog(@"更新成功");
        }else{
            NSLog(@"更新失败");
            [db rollback];
        }
        // 全部操作完成时候再去提交
        [db commit]; 
    }];
}

// 查
- (IBAction)select:(id)sender{
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *result =   [db executeQuery:@"select * from t_user"];
        while ([result next]) {
            NSString *name = [result stringForColumn:@"name"];
            int money = [result intForColumn:@"money"];
            NSLog(@"%@--%d",name,money);
        }
    }];
}


@end
