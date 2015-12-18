//
//  FinancialStatisticViewController.m
//  FinancialStatisticBU
//
//  Created by Somiya on 15/10/17.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "FinancialStatisticViewController.h"
#import "WaterballView.h"
#import <FinancialStatisticBUF/FinancialStatisticBUF-Swift.h>
#import "ReportingDetailViewController.h"
#define Rate 0.7

#define ThresholdValueTop 50

@interface FinancialStatisticViewController () <ChartViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, strong) UIScrollView *chartScrollview;
@property (nonatomic, strong) WaterballView *waterballView;
@property (nonatomic, strong) BarChartView *chartView;
@property (nonatomic, strong) HorizontalBarChartView *chartViewH;
@property (nonatomic, strong) UIView *tagView;

@property (nonatomic, strong) NSArray *itemsArr;
@property (nonatomic, strong) NSArray *valueArr;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UIButton *butn1;  //资产负债表
@property (nonatomic, strong) UIButton *butn2;  //利润表
@property (nonatomic, strong) UIButton *butn3;  //现金流量表
@property (nonatomic, strong) UIButton *checkMoreButn;
@end

@implementation FinancialStatisticViewController
#pragma mark ----------------system----------------
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"财务统计";
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_chartView animateWithYAxisDuration:3.0];
}

#pragma mark ----------------init----------------
- (void)initBaseData {
    self.itemsArr = @[@"当月收入", @"当月成本", @"当月费用", @"当月税金", @"当月其他", @"当月净利"];
    self.valueArr = @[@258.6300, @93.1068, @67.2438, @2.5863, @36.2082, @59.4849];
    self.currentPage = 0;
}

- (void)initBaseView {
    [super initBaseView];
    [self.myScrollView addSubview:self.waterballView];
    [self.myScrollView addSubview:self.chartScrollview];
    [self.chartScrollview addSubview:self.chartView];
    [self.chartScrollview addSubview:self.chartViewH];
    self.myScrollView.bounces = NO;
//    [self.view addSubview:self.tagView];
    [self setDataCount:self.itemsArr.count];
    
    
        //break line
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.chartScrollview.frame) + 60, SCREENWIDTH, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.myScrollView addSubview:line];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(line.frame) - 25, 100, 20)];
    label.textColor = [UIColor grayColor];
    label.text = @"三大报表";
    [self.myScrollView addSubview:label];
    
    self.butn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.butn2.frame = CGRectMake(10, CGRectGetMaxY(line.frame) + 10, (SCREENWIDTH - 30) / 3, (SCREENWIDTH - 30) / 3);
    self.butn2.backgroundColor = [UIColor whiteColor];
    [self.butn2 setTitle:@"资产负债表" forState:UIControlStateNormal];
    [self.butn2 addTarget:self action:@selector(checkReportForms:) forControlEvents:UIControlEventTouchUpInside];
    [self.myScrollView addSubview:self.butn2];

    self.butn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.butn3.frame = CGRectMake(10 + (10 + (SCREENWIDTH - 30) / 3), CGRectGetMaxY(line.frame) +10, (SCREENWIDTH - 30) / 3, (SCREENWIDTH - 30) / 3);
    self.butn3.backgroundColor = [UIColor whiteColor];
    [self.butn3 setTitle:@"利润表" forState:UIControlStateNormal];
    [self.butn3 addTarget:self action:@selector(checkReportForms:) forControlEvents:UIControlEventTouchUpInside];
    [self.myScrollView addSubview:self.butn3];


    self.butn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.butn1.frame = CGRectMake(10 + 2 * (10 + (SCREENWIDTH - 30) / 3), CGRectGetMaxY(line.frame) + 10, (SCREENWIDTH - 30) / 3, (SCREENWIDTH - 30) / 3);
    self.butn1.backgroundColor = [UIColor whiteColor];
    [self.butn1 setTitle:@"现金流量表" forState:UIControlStateNormal];
    [self.butn1 addTarget:self action:@selector(checkReportForms:) forControlEvents:UIControlEventTouchUpInside];
    [self.myScrollView addSubview:self.butn1];
    
    [self.myScrollView addSubview:self.checkMoreButn];
    
    self.myScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.checkMoreButn.frame) + 20);
}

- (UIButton *)checkMoreButn {
    if (!_checkMoreButn) {
        _checkMoreButn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _checkMoreButn.frame = CGRectMake((SCREENWIDTH - 80) / 2, CGRectGetMaxY(self.butn1.frame) + 20, 80, 25);
        _checkMoreButn.backgroundColor = [UIColor whiteColor];
        _checkMoreButn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _checkMoreButn.layer.borderWidth = 1;
        [_checkMoreButn setTitle:@"更多报表" forState:UIControlStateNormal];
        [_checkMoreButn addTarget:self action:@selector(checkMoreReporting:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkMoreButn;
}

- (WaterballView *)waterballView {
    if (!_waterballView) {
        _waterballView = [[WaterballView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
    }
    
    return _waterballView;
}

- (UIScrollView *)chartScrollview {
    if (!_chartScrollview) {
        _chartScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.waterballView.frame) + 20, SCREENWIDTH, SCREENWIDTH * Rate)];
        _chartScrollview.contentSize = CGSizeMake(SCREENWIDTH * 3, 0);
        _chartScrollview.delegate = self;
        _chartScrollview.pagingEnabled = YES;
    }
    return _chartScrollview;
}

- (BarChartView *)chartView {
    if (!_chartView) {
        _chartView = [[BarChartView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH * Rate)];
        _chartView.delegate = self;
        
        _chartView.descriptionText = @"";
        _chartView.noDataTextDescription = @"You need to provide data for the chart.";
        
        _chartView.drawBarShadowEnabled = NO;
        _chartView.drawValueAboveBarEnabled = YES;
        
        _chartView.maxVisibleValueCount = 60;
        _chartView.pinchZoomEnabled = NO;
        _chartView.drawGridBackgroundEnabled = NO;
        
        ChartXAxis *xAxis = _chartView.xAxis;
        xAxis.labelPosition = XAxisLabelPositionBottom;
        xAxis.labelFont = [UIFont systemFontOfSize:10.f];
        xAxis.drawGridLinesEnabled = NO;
        xAxis.spaceBetweenLabels = 0.0;
        
        ChartYAxis *leftAxis = _chartView.leftAxis;
        leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
        leftAxis.labelCount = 8;
        leftAxis.valueFormatter = [[NSNumberFormatter alloc] init];
        leftAxis.valueFormatter.maximumFractionDigits = 1;
        leftAxis.valueFormatter.negativeSuffix = @" k";
        leftAxis.valueFormatter.positiveSuffix = @" k";
        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
        leftAxis.spaceTop = 0.15;
        
        ChartYAxis *rightAxis = _chartView.rightAxis;
        rightAxis.drawGridLinesEnabled = NO;
        rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
        rightAxis.labelCount = 8;
        rightAxis.valueFormatter = leftAxis.valueFormatter;
        rightAxis.spaceTop = 0.15;
        
        _chartView.legend.position = ChartLegendPositionBelowChartLeft;
        _chartView.legend.form = ChartLegendFormSquare;
        _chartView.legend.formSize = 9.0;
        _chartView.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
        _chartView.legend.xEntrySpace = 4.0;
    }
    return _chartView;
}

- (HorizontalBarChartView *)chartViewH {
    if (!_chartViewH) {
        _chartViewH = [[HorizontalBarChartView alloc] initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENWIDTH  * Rate)];
        _chartViewH.delegate = self;
        
        _chartViewH.descriptionText = @"";
        _chartViewH.noDataTextDescription = @"You need to provide data for the chart.";
        
        _chartViewH.drawBarShadowEnabled = NO;
        _chartViewH.drawValueAboveBarEnabled = YES;
        
        _chartViewH.maxVisibleValueCount = 60;
        _chartViewH.pinchZoomEnabled = NO;
        _chartViewH.drawGridBackgroundEnabled = NO;
        
        ChartXAxis *xAxis = _chartViewH.xAxis;
        xAxis.labelPosition = XAxisLabelPositionBottom;
        xAxis.labelFont = [UIFont systemFontOfSize:10.f];
        xAxis.drawAxisLineEnabled = YES;
        xAxis.drawGridLinesEnabled = YES;
        xAxis.gridLineWidth = .3;
        
        ChartYAxis *leftAxis = _chartViewH.leftAxis;
        leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
        leftAxis.drawAxisLineEnabled = YES;
        leftAxis.drawGridLinesEnabled = YES;
        leftAxis.gridLineWidth = .3;
        
        ChartYAxis *rightAxis = _chartViewH.rightAxis;
        rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
        rightAxis.drawAxisLineEnabled = YES;
        rightAxis.drawGridLinesEnabled = NO;
        
        _chartViewH.legend.position = ChartLegendPositionBelowChartLeft;
        _chartViewH.legend.form = ChartLegendFormSquare;
        _chartViewH.legend.formSize = 8.0;
        _chartViewH.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
        _chartViewH.legend.xEntrySpace = 4.0;
    }
    return _chartViewH;
}

- (UIView *)tagView {
    if (!_tagView) {
        _tagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
        _tagView.backgroundColor = [UIColor greenColor];
    }
    return _tagView;
}

#pragma mark ----------------Actions----------------
- (void)checkReportForms:(id)sender {
    ReportingDetailViewController *rVC = [ReportingDetailViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)checkMoreReporting:(id)sender {
    [[ToastView sharedToastView] showToastViewWithMessage:@"更多报表正在开发中，敬请期待..." inView:[[[UIApplication sharedApplication] delegate] window]];
}
#pragma mark ----------------功能性函数----------------
- (void)setDataCount:(NSUInteger)count
{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
        {
        [xVals addObject:self.itemsArr[i]];
        }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
        {
        [yVals addObject:[[BarChartDataEntry alloc] initWithValue:[self.valueArr[i] doubleValue] xIndex:i]];
        }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals label:@"DataSet"];
    set1.barSpace = 0.35;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    
    _chartView.data = data;
    _chartViewH.data = data;
}

- (void)animationWithDestinationPoint:(CGPoint)point{
    [UIView animateWithDuration:0.8 animations:^{
        self.myScrollView.contentOffset = point;
    }];
}

- (void)changeWaterBallViewOpacityWithCurrentY:(CGFloat)currenty {
    if (currenty >= 0 && currenty <= CGRectGetMaxY(self.waterballView.frame)) {
        self.waterballView.alpha = (1 - currenty / CGRectGetHeight(self.waterballView.frame));
        self.tagView.alpha = currenty / CGRectGetHeight(self.waterballView.frame);
    }
}

#pragma mark ----------------UIScrollViewDelegate----------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.chartScrollview) {
        NSInteger page = scrollView.contentOffset.x / SCREENWIDTH;
        if (self.currentPage == page) {
            return;
        }
        if (page == 0) {
            [_chartView animateWithYAxisDuration:3];
        } else if (page == 1) {
            [_chartViewH animateWithYAxisDuration:3];
        }
        self.currentPage = page;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.myScrollView) {
        CGFloat top = scrollView.contentOffset.y;
        [self changeWaterBallViewOpacityWithCurrentY:top];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    CGPoint p = *targetContentOffset;
//    if (p.y > ThresholdValueTop) {
//        [self animationWithDestinationPoint:CGPointMake(0, CGRectGetMaxY(self.waterballView.frame))];
//    } else {
//        [self animationWithDestinationPoint:CGPointMake(0, 0)];
//    }
}
#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
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
