//
//  NewsModel.m
//  FMDB存取模型
//
//  Created by RongCheng on 2019/1/8.
//  Copyright © 2019年 RongCheng. All rights reserved.
//

#import "NewsModel.h"
#import <objc/runtime.h>
@implementation NewsModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (NSMutableDictionary *)getDictionayFromModel{
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    // 拷贝属性列表
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char *char_p = property_getName(property);
        // 属性名
        NSString *propertyName = [NSString stringWithUTF8String:char_p];
        // 属性值
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        // 设置KeyValues
        if (propertyValue) [dicM setObject:propertyValue forKey:propertyName];
    }
    //释放
    free(properties);
    return dicM;
}
@end
