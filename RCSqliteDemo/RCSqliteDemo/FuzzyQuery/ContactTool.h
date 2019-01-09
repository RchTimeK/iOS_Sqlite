//
//  ContactTool.h
//  数据库的使用
//
//  Created by RongCheng on 2019/1/7.
//  Copyright © 2019年 RongCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ContactModel;

NS_ASSUME_NONNULL_BEGIN
@interface ContactTool : NSObject
//  存储联系人
+ (BOOL)saveWithContact:(ContactModel *)contact;

/*
  __nullable（？可以为空）与__nonnull（！不能为空），为了让OC也能有swift的？和！的功能
 或者用宏NS_ASSUME_NONNULL_BEGIN和NS_ASSUME_NONNULL_END 包住多个属性全部具备nonnull，然后仅对需要nullable的改下就行，有点类似于f-no-objc-arc那种先整体给个路线在单独改个别文件的思想。 此警告就是某属性说好的不能为空，你又在某地方写了XX = nil 所以冲突了。
 */

// 获取联系人数据 sql传nil默认查询全部
+ (NSArray *)contactWithSql:(NSString * _Nullable)sql;

@end

NS_ASSUME_NONNULL_END
