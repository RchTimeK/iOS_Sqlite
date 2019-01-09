//
//  FuzzyQueryController.m
//  RCSqliteDemo
//
//  Created by RongCheng on 2019/1/8.
//  Copyright © 2019年 RongCheng. All rights reserved.
//

#import "FuzzyQueryController.h"
#import "ContactTool.h"
#import "ContactModel.h"
@interface FuzzyQueryController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *contacts;
@end

@implementation FuzzyQueryController
- (NSMutableArray *)contacts{
    if(_contacts == nil){
        // 从数据库读取数据
        _contacts = (NSMutableArray *)[ContactTool contactWithSql:nil];
        if(_contacts == nil){
            _contacts = [NSMutableArray array];
        }
    }
    return _contacts;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:(UIBarButtonItemStylePlain) target:self action:@selector(insertClick)];
    
    // 设置导航条的内容
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.delegate = (id<UISearchBarDelegate>)self;
    self.navigationItem.titleView = searchBar;
    
}
#pragma mark ----- UISearchBarDelegate -----
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *sql = [NSString stringWithFormat:@"select * from t_contacts where name like '%%%@%%' or phone like '%%%@%%';",searchText,searchText];
    self.contacts = (NSMutableArray *)[ContactTool contactWithSql:sql];
    [self.tableView reloadData];
}

// 模拟生成联系人
- (void)insertClick{
    NSArray *name1 = @[@"a",@"b",@"c",@"d",@"e"];
    NSArray *name2 = @[@"qwe",@"rty",@"uio",@"pas",@"dfg",@"hjk"];
    
    NSString *name = [NSString stringWithFormat:@"%@%@",name1[arc4random_uniform(5)],name2[arc4random_uniform(6)]];
    NSString *phone = [NSString stringWithFormat:@"%d",arc4random_uniform(88888)+10000];
    
    ContactModel *model = [[ContactModel alloc]init];
    model.name = name;
    model.phone = phone;
    [self.contacts addObject:model];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.contacts.count-1 inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // 存储到数据库里面
    [ContactTool saveWithContact:model];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contacts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"FuzzyQueryCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:ID];
    }
    ContactModel *model  = self.contacts[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.phone;
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
