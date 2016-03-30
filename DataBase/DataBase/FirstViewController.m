//
//  FirstViewController.m
//  DataBase
//
//  Created by 焦星星 on 16/3/29.
//  Copyright © 2016年 jxx. All rights reserved.
//

#import "FirstViewController.h"
#import "DBManager.h"
#import "FMDB.h"
#import "DataModel.h"
static NSString *cellId = @"cell";
@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *addText;
@property (nonatomic ,strong) DBManager *manage;
@property (nonatomic ,strong) NSMutableArray *dataSource;
- (IBAction)addAction:(id)sender;
- (IBAction)exit:(id)sender;

@end

@implementation FirstViewController

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

- (IBAction)addAction:(id)sender {
    NSString *addString =[NSString stringWithFormat:@"insert into myTest (x) values ('%@');",self.addText.text];
    [self.manage.dataBase executeStatements:addString];
    DataModel *lastModel = [self.dataSource lastObject];
    FMResultSet *rs = [self.manage.dataBase executeQuery:@"select * from myTest where id >?",[NSString stringWithFormat:@"%lu",lastModel.dataId]];
    while ([rs next]) {
        NSInteger dataId = [rs intForColumn:@"id"];
        NSString *str = [rs stringForColumn:@"x"];
        DataModel *model = [[DataModel alloc]init];
        model.dataId = dataId;
        model.string = str;
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
    
}

- (IBAction)exit:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    DBManager *manager = [DBManager dbManager];
    self.manage = manager;
    NSLog(@"%@",manager);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 代理方法
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



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataModel *model = self.dataSource[indexPath.row];
    NSString *addString =[NSString stringWithFormat:@"delete from myTest where id==%ld;",model.dataId];
    bool result = [self.manage.dataBase executeStatements:addString];
    if (result) {
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }else{
        NSLog(@"删除失败");
    }
}

@end
