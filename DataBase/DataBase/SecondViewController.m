//
//  SecondViewController.m
//  DataBase
//
//  Created by 焦星星 on 16/3/29.
//  Copyright © 2016年 jxx. All rights reserved.
//

#import "SecondViewController.h"
#import "DBManager.h"
#import "FMDB.h"
#import "DataModel.h"
static NSString *cellId = @"cell";
@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic ,strong) DBManager *manage;
@property (nonatomic ,strong) NSMutableArray *dataSource;
@end

@implementation SecondViewController

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        FMResultSet *allData = [self.manage.dataBase executeQuery:@"select * from myTest"];
        while ([allData next]) {
            NSInteger dataId = [allData intForColumn:@"id"];
            NSString *str = [allData stringForColumn:@"x"];
            DataModel *model = [[DataModel alloc]init];
            model.dataId = dataId;
            model.string = str;
            [self.dataSource addObject:model];
        }
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeText:) name:UITextFieldTextDidChangeNotification object:nil];
    DBManager *manager = [DBManager dbManager];
    self.manage = manager;
    NSLog(@"%@",manager);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataModel *model = self.dataSource[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = model.string;
    return cell;
    
}

- (void)changeText:(NSNotification *)notification
{
    [self.dataSource removeAllObjects];
    NSLog(@"%@",self.searchTextField.text);
    NSString *selectString = [NSString stringWithFormat:@"select * from myTest where x like '%%%@%%'",self.searchTextField.text];
    FMResultSet *result = [self.manage.dataBase executeQuery:selectString];
    while ([result next]) {
        
        NSInteger dataId = [result intForColumn:@"id"];
        NSString *str = [result stringForColumn:@"x"];
        DataModel *model = [[DataModel alloc]init];
        model.dataId = dataId;
        model.string = str;
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
}

@end
