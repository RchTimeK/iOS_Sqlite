//
//  NewsCacheViewController.m
//  RCSqliteDemo
//
//  Created by RongCheng on 2019/1/8.
//  Copyright © 2019年 RongCheng. All rights reserved.
//

#import "NewsCacheViewController.h"
#import "AFNetworking.h"
#import "NewsModel.h"
#import "NewsCell.h"
#import "NewsCacheTool.h"
@interface NewsCacheViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *newsArray;

@end

@implementation NewsCacheViewController
static NSString * const NewsCellID = @"NewsCellID";

- (NSMutableArray *)newsArray{
    if(_newsArray == nil){
        // 先从数据库中取，没有则初始化
        _newsArray = (NSMutableArray *)[NewsCacheTool selectNewsToDatabase:@"001"];
        if(_newsArray == nil){
            _newsArray = [NSMutableArray array];
        }
    }
    return _newsArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"头条新闻缓存";
    self.tableView.rowHeight = 100;
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:NewsCellID];
    
    /*
     以头条新闻为例：
     实现思路：1.先在本地数据库查找是否存在缓存，存在则显示缓存的新闻，
     2.不存在则去头条服务器请求数据显示，同时缓存
     头条新闻接口：http://c.m.163.com/nc/article/headline/T1348647853363/0-20.html
     */
    
    if(self.newsArray.count){
        return;
    }
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer =[AFHTTPRequestSerializer serializer];
    [session GET:@"http://c.m.163.com/nc/article/headline/T1348647853363/0-20.html" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for(NSDictionary *dic in jsonDic[@"T1348647853363"]){
            NewsModel *news = [[NewsModel alloc]initWithDictionary:dic];
            [self.newsArray addObject:news];
        }
        [self.tableView reloadData];
        
        // 缓存到数据库
        [NewsCacheTool saveNewsToDatabase:self.newsArray];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull  error) {
        NSLog(@"请求失败！！！");
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsCellID forIndexPath:indexPath];
    NewsModel *news = self.newsArray[indexPath.row];
    cell.news = news;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


@end
