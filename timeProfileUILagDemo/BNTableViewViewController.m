//
//  BNTableViewViewController.m
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import "BNTableViewViewController.h"
#import "BNDemoTableViewCell.h"

static NSString *const kBNDemoTableViewCell = @"kBNDemoTableViewCell";

@interface BNTableViewViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BNTableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [tableView registerClass:[BNDemoTableViewCell class] forCellReuseIdentifier:kBNDemoTableViewCell];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    tableView.tableFooterView = [[UIView alloc] init];
    self.tableView = tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BNDemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBNDemoTableViewCell forIndexPath:indexPath];
    [cell updateContentTitle:[NSString stringWithFormat:@"测试测试%ld",(long)indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 154;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;;
}

@end
