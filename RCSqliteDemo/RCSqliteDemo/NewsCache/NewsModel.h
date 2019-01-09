//
//  NewsModel.h
//  FMDB存取模型
//
//  Created by RongCheng on 2019/1/8.
//  Copyright © 2019年 RongCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsModel : NSObject
/**标题*/
@property (nonatomic,copy)NSString *title;
/**图片地址（可能为nil）*/
@property (nonatomic,copy)NSString *imgsrc;
/**来源*/
@property (nonatomic,copy)NSString *source;
/**时间*/
@property (nonatomic,copy)NSString *ptime;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

- (NSMutableDictionary *)getDictionayFromModel;

@end

NS_ASSUME_NONNULL_END
