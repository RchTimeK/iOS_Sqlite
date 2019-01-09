//
//  NewsCacheTool.m
//  FMDB存取模型
//
//  Created by RongCheng on 2019/1/8.
//  Copyright © 2019年 RongCheng. All rights reserved.
//

#import "NewsCacheTool.h"
#import "FMDB.h"
#import "NewsModel.h"
@implementation NewsCacheTool

static FMDatabase *_db;

+ (void)initialize{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"News.sqlite"];
    _db = [FMDatabase databaseWithPath:filePath];
    if ([_db open]) {
        NSLog(@"打开数据库成功");
        // 自增主键、userID、二进制数据流
        NSString *sql = @"create table if not exists t_news (id integer primary key autoincrement,userID text,dict blob);";
        BOOL success = [_db executeUpdate:sql];
        if (success) {
            NSLog(@"创建表成功");
        }else{
            NSLog(@"创建表失败");
        }
    }else{
        NSLog(@"打开数据库失败");
    }
}

+ (void)saveNewsToDatabase:(NSArray *)newsArray{
    // 遍历模型数组
    for (NewsModel *nesw in newsArray){
        // 用户的id应该从自己的服务器取得
        NSString *userID = @"001";
        // 这是模型转字典的，自己用runtime简单实现了，有很多优秀的第三方库可以使用，自选
        NSDictionary * newsDic = [nesw getDictionayFromModel];
        NSError *error;
        NSData *data;
        if (@available(iOS 11.0, *)){
            data = [NSKeyedArchiver archivedDataWithRootObject:newsDic requiringSecureCoding:YES error:&error];
        }else{
            data = [NSKeyedArchiver archivedDataWithRootObject:newsDic];
        }
        if (data == nil || error) {
            NSLog(@"缓存失败:%@", error);
            return;
        }
        BOOL success = [_db executeUpdate:@"insert into t_news (userID,dict) values(?,?)",userID,data];
        if (success) {
            NSLog(@"插入成功");
        }else{
            NSLog(@"插入失败");
        }
    }
    
}
+ (NSArray *)selectNewsToDatabase:(NSString *)userID{
    NSString *sql = [NSString stringWithFormat:@"select * from t_news where userID = '%@';",userID];
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *array = [NSMutableArray array];
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSError *error;
        NSDictionary *dic;
        if (@available(iOS 11.0, *)) {
            dic = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:&error];
        } else {
            dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        if(dic){
            NewsModel *news = [[NewsModel alloc]initWithDictionary:dic];
            [array addObject:news];
        }
    }
    return array;
}

+ (void)clearNewsCache:(void (^)(BOOL success))flag{
    BOOL success = [_db executeUpdate:@"delete from t_news;"];
    if(flag){
        flag(success);
    }
}

@end
