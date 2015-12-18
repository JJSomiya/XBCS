//
//  ReportingDetailViewController.m
//  FinancialStatisticBU
//
//  Created by Somiya on 15/11/12.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "ReportingDetailViewController.h"

@interface ReportingDetailViewController () <JSGridViewDataSource, JSGridViewDelegate>
@property (nonatomic, strong) JSGridView *gridView;
@end

@implementation ReportingDetailViewController

#pragma mark ----------------System----------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.gridView removeAllObserver];
}

#pragma mark ----------------init----------------
- (void)initBaseData {
    [super initBaseData];
}

- (void)initBaseView {
    [super initBaseView];
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.gridView];
}

- (JSGridView *)gridView {
    if (!_gridView) {
        _gridView = [[JSGridView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64)];
        _gridView.dataSource = self;
        _gridView.delegate = self;
        [_gridView floatingLeftHeader:NO];
    }
    return _gridView;
}

#pragma mark ----------------JSGridViewDataSource----------------
- (NSInteger)numberOfColumnForGridView:(JSGridView *)gridView {
    return 5;
}

- (NSInteger)numberOfRowsForGridView:(JSGridView *)gridView {
    return 20;
}

- (CGFloat)gridView:(JSGridView *)gridView heightForRow:(NSInteger)row {
    if (row == 2) {
        return 50;
    }
    return 30;
}

- (CGFloat)gridView:(JSGridView *)gridView widthForColumn:(NSInteger)column {
    if (column == 3) {
        return 100;
    }
    return 200;
}

- (JSGridViewCell *)gridView:(JSGridView *)gridView cellForGridViewIndexPath:(JSGridIndexPath)indexPath {
    NSString * const identifier = @"CELL";
    JSGridViewCell *cell = [gridView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[JSGridViewCell alloc] initWithReuseIdentifier:identifier];
    }
    cell.titleLabel.text = @"哈哈哈哈放辣椒放辣椒";
    return cell;
}

#pragma mark ----------------JSGridViewDelegate----------------
- (void)gridView:(JSGridView *)gridView didSelectCellAtIndexPath:(JSGridIndexPath)indexPath {
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
