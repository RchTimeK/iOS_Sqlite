//
//  SqliteTestController.m
//  RCSqliteDemo
//
//  Created by RongCheng on 2019/1/8.
//  Copyright © 2019年 RongCheng. All rights reserved.
//

#import "SqliteTestController.h"
#import <sqlite3.h>
@interface SqliteTestController ()
@property (nonatomic,assign)sqlite3 *db;
@end

@implementation SqliteTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取cache文件路径
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    // 拼接文件名
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"People.sqlite"];
    
    _db = nil;
    // 打开数据库
    if(sqlite3_open(filePath.UTF8String, &_db) == SQLITE_OK){
        NSLog(@"数据库打开成功");
    }else{
        NSLog(@"数据库打开失败");
    }
    
    NSString *sql = @"create table if not exists t_people (id integer primary key autoincrement,name text,age integer);";
    [self sqlite3_execWithSql:sql];
    
}
// 增
- (IBAction)insert:(id)sender {
    // 连续插三条，方便后续操作
    for (NSInteger i=0;i<3;i++){
        NSString *sql = @"insert into t_people (name,age) values('小虎牙',18);";
        [self sqlite3_execWithSql:sql];
    }
    
}

// 删
- (IBAction)delete:(id)sender {
    NSString *sql = @"delete from t_people where id = 2";
    [self sqlite3_execWithSql:sql];
}

// 改
- (IBAction)update:(id)sender {
    NSString *sql = @"update t_people set name = '幸福的小虎牙' where id = 1";
    [self sqlite3_execWithSql:sql];
}

//查
- (IBAction)select:(id)sender {
    // 准备查询
    NSString *sql = @"select * from t_people;";
    /**
     * int nByte :执行数据库语句的字节数 传-1v表示自动计算字节数
     * **ppStmt : 句柄 用来操作查询的数据
     */
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK){// 准备成功
        
        // 执行句柄
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            // 查询 id
            int ID = sqlite3_column_int(stmt, 0);
            
            // 查询name
            NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
            
            //查询age
            int age = sqlite3_column_int(stmt, 2);
            
            
            NSLog(@"%d %@ %d",ID,name,age);
            
        }
    }
}

- (void)sqlite3_execWithSql:(NSString *)sql{
    char *errmsg;
    sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errmsg);
    if(errmsg){
        NSLog(@"操作失败");
    }else{
        NSLog(@"操作成功");
    }
}

@end
