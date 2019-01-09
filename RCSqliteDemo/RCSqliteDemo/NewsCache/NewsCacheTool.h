//
//  NewsCacheTool.h
//  FMDB存取模型
//
//  Created by RongCheng on 2019/1/8.
//  Copyright © 2019年 RongCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface NewsCacheTool : NSObject
/**缓存新闻数据到本地数据库*/
+ (void)saveNewsToDatabase:(NSArray *)newsArray;
/**读取新闻（userID对应用户的id，同个应用可能存在多个账号登录情况）*/
+ (NSArray *)selectNewsToDatabase:(NSString *)userID;
/**清除缓存*/
+ (void)clearNewsCache:(void(^)(BOOL success))flag;
@end

NS_ASSUME_NONNULL_END
