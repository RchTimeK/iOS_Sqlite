//
//  NewsCell.m
//  RCSqliteDemo
//
//  Created by RongCheng on 2019/1/9.
//  Copyright © 2019年 RongCheng. All rights reserved.
//

#import "NewsCell.h"
#import "NewsModel.h"
#import "UIImageView+WebCache.h"
@interface NewsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@end
@implementation NewsCell

- (void)setNews:(NewsModel *)news{
    _news = news;
    [self.img sd_setImageWithURL:[NSURL URLWithString:news.imgsrc] placeholderImage:[UIImage imageNamed:@"plImg"]];
    self.titleLabel.text = news.title;
    self.detailLabel.text = [NSString stringWithFormat:@"%@  %@",news.source,news.ptime];
}

@end
