//
//  NewsCell.h
//  RCSqliteDemo
//
//  Created by RongCheng on 2019/1/9.
//  Copyright © 2019年 RongCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsModel;

NS_ASSUME_NONNULL_BEGIN

@interface NewsCell : UITableViewCell
@property (nonatomic,strong)NewsModel *news;
@end

NS_ASSUME_NONNULL_END
