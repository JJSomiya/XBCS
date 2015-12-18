//
//  ProductViewController.m
//  ProductBU
//
//  Created by Somiya on 15/10/17.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "ProductViewController.h"
#import "BaseServiceCollectionCell.h"
#import "ConfirmOrderViewController.h"
#import "PickServicesCollectionViewController.h"

static CGFloat kMaxTop = 667;
static CGFloat kMinTop = 70;
static CGFloat kMarginR = 45;
static CGFloat kPullImageViewW = 45;
static CGFloat kPullImageViewH = (200 / 140 * 70);

static NSString *const baseIdentifier = @"baseservicecell";

@interface ProductViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, CustomSegViewDelegate, PopViewDelegate>
@property (nonatomic, strong) CustomSegView *segView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *collectionViews;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) PullView *pullView;
@property (nonatomic, strong) UIImageView *pullThreadView;
@property (nonatomic, strong) UIImageView *pullImgeView;

@property (nonatomic, strong) NSMutableDictionary *productsDic;

@property (nonatomic, getter=isHideStatusBar) BOOL hideStatusBar; // Give this a default value early

@end

@implementation ProductViewController
#pragma mark ----------------system----------------
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"产品服务";
    // Do any additional setup after loading the view.
    //测试接口
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:@"test" object:nil];
//    [[RequestManager sharedRequestManager] requestTest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
        //request data
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_PRODUCTLIST object:nil];
    [[RequestManager sharedRequestManager] requestProductList];
    
        //update view layout
    self.pullImgeView.frame = CGRectMake(SCREENWIDTH - kMarginR, 0, kPullImageViewW, kPullImageViewH);

    CGRect frame = self.pullThreadView.frame;
    frame.size.height = CGRectGetMinY(self.pullImgeView.frame) + kPullImageViewH + 10;
    self.pullThreadView.frame = frame;
    self.pullThreadView.alpha = 1;
    self.pullImgeView.alpha = 1;

    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.pullThreadView];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.pullImgeView];
    [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.pullImgeView.frame = CGRectMake(SCREENWIDTH - kMarginR, kMinTop, kPullImageViewW, kPullImageViewH);
        
        CGRect frame = self.pullThreadView.frame;
        frame.size.height = CGRectGetMinY(self.pullImgeView.frame) + kPullImageViewH + 10;
        self.pullThreadView.frame = frame;
    } completion:^(BOOL finish){
//        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.pullThreadView.alpha = 0.5;
//            self.pullImgeView.alpha = 0.5;
//        } completion:nil];
        }
     ];

    [self.pullView showPullViewWithObject:nil inView:[[[UIApplication sharedApplication] delegate] window]];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.pullImgeView removeFromSuperview];
    [self.pullThreadView removeFromSuperview];
    [self.pullView hidenPullView];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
        // "Pixel" is a solid white 1x1 image.
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
        // "Pixel" is a solid white 1x1 image.
        //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Pixel"] forBarMetrics:UIBarMetricsDefault];
}

- (BOOL)prefersStatusBarHidden {
    return self.isHideStatusBar;
}

#pragma mark ----------------inits----------------
- (void)initBaseData {
    self.collectionViews = [NSMutableArray array];
    self.currentPage = 0;
    self.productsDic = [NSMutableDictionary dictionary];
}

- (void)initBaseView {
    [super initBaseView];
    
    CGRect frame = self.bgImageView.frame;
    frame.origin.y = 44;
    self.bgImageView.frame = frame;
    
    [self.view addSubview:self.segView];
    
    [self.view addSubview:self.scrollView];
    [self addCollectionViewsWithNumber:2];
    
    [self setLeftBarButn];
    
    self.pullView = [PullView sharedPullView];
    __weak ProductViewController *weakSelf = self;
    [self.pullView setHidenPullViewBlock:^{
        __strong ProductViewController *strongSelf = weakSelf;
        [strongSelf setHideStatusBar:NO];
        [strongSelf setNeedsStatusBarAppearanceUpdate];
       [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
           strongSelf.pullImgeView.frame = CGRectMake(SCREENWIDTH - kMarginR, kMinTop, kPullImageViewW, kPullImageViewH);
           CGRect frame = strongSelf.pullThreadView.frame;
           frame.size.height = CGRectGetMinY(strongSelf.pullImgeView.frame) + kPullImageViewH + 10;
           strongSelf.pullThreadView.frame = frame;
       } completion:^(BOOL finish){
//           [strongSelf setHideStatusBar:YES];
//           [strongSelf setNeedsStatusBarAppearanceUpdate];
       }];
    }];
    [self.pullView setShowPullViewBlock:^{
        __strong ProductViewController *strongSelf = weakSelf;
//        [UIView animateWithDuration:0.3 delay:0.2 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            strongSelf.imageView.frame = CGRectMake(SCREENWIDTH - 100, kMinTop, 50, 50);
//        } completion:^(BOOL finish){
//            [strongSelf setHideStatusBar:YES];
//            [strongSelf setNeedsStatusBarAppearanceUpdate];
//        }];
        [strongSelf setHideStatusBar:YES];
        [strongSelf setNeedsStatusBarAppearanceUpdate];
    }];
    
}

- (UIImageView *)pullImgeView {
    if (!_pullImgeView) {
        _pullImgeView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - kMarginR, 0, kPullImageViewW, kPullImageViewH)];
        _pullImgeView.contentMode = UIViewContentModeScaleAspectFit;
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"pullimgview" withExtension:@"gif"];
        _pullImgeView.image = [UIImage animatedImageWithAnimatedGIFURL:url];
        _pullImgeView.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePangestureRecognizer:)];
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapgestureRecognizer:)];
        [_pullImgeView addGestureRecognizer:panRecognizer];
        [_pullImgeView addGestureRecognizer:tapRecognizer];
    }
    return _pullImgeView;
}

- (UIImageView *)pullThreadView {
    if (!_pullThreadView) {
        _pullThreadView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.pullImgeView.frame) + 3, -5, 5, CGRectGetMinY(self.pullImgeView.frame) + kPullImageViewH + 10)];
//        _pullThreadView.backgroundColor = [UIColor redColor];
        _pullThreadView.image = [UIImage imageNamed:@"thread"];

    }
    return _pullThreadView;
}

- (CustomSegView *)segView {
    if (!_segView) {
        _segView = [[CustomSegView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
        self.segView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBackground"]];
        [_segView setSegViewItems:@[@"基本服务", @"增值服务"]];
        _segView.delegate = self;
    }
    return _segView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segView.frame), SCREENWIDTH, self.view.bounds.size.height - 44 - 49 - 64)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}
#pragma mark ----------------actions----------------
- (void)handleTapgestureRecognizer:(UITapGestureRecognizer *)recognizer {
    [self.pullView changeTy:kMaxTop];
    [self.pullView changeEnd:kMinTop];
}
- (void)handlePangestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
        //    NSLog(@"center:%@", NSStringFromCGPoint(translation));
    CGFloat newy = recognizer.view.center.y + translation.y;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.pullThreadView.alpha = 1;
            self.pullImgeView.alpha = 1;
        } completion:nil];
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (newy > kMinTop) {
            if (newy < kMaxTop) {
                recognizer.view.center = CGPointMake(recognizer.view.center.x,
                                                     newy);
                [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
            } else {
                recognizer.view.center = CGPointMake(recognizer.view.center.x,
                                                     kMaxTop);
                [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
            }
        } else {
            recognizer.view.center = CGPointMake(recognizer.view.center.x,
                                                 kMinTop);
            [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
        }
        CGRect frame = self.pullThreadView.frame;
        frame.size.height = CGRectGetMinY(self.pullImgeView.frame) + kPullImageViewH + 10;
        self.pullThreadView.frame = frame;
        [self.pullView changeTy:translation.y];
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self.pullView changeEnd:newy];
//        [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.pullThreadView.alpha = 0.5;
//            self.pullImgeView.alpha = 0.5;
//        } completion:nil];
    }
}

- (void)setLeftBarButn {
    UIButton *butn = [UIButton buttonWithType:UIButtonTypeCustom];
    butn.frame = CGRectMake(0, 0, 20, 20);
    [butn setBackgroundImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
    [butn addTarget:self action:@selector(filterBarButnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:butn];//[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sort"] style:UIBarButtonItemStylePlain target:self action:@selector(filterBarButnClicked:)];
    left.imageInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    self.navigationItem.leftBarButtonItem = left;
}

- (void)filterBarButnClicked:(id)sender {
    [[PopView sharedPopView] showPopViewWithDataSource:(NSMutableArray *)@[@{@"name":@"销量倒序", @"type":@"sales"}, @{@"name":@"推荐度", @"type":@"recommend"}, @{@"name":@"好评倒序", @"type":@"praise"}, @{@"name":@"性价比", @"type":@"sales"}] atPoint:CGPointMake(20, 55) inView:[[[UIApplication sharedApplication] delegate] window]];
    [[PopView sharedPopView] setDelegate:self];
}

#pragma mark ----------------functionality----------------
- (void)addCollectionViewsWithNumber:(NSInteger)num {
    self.scrollView.contentSize = CGSizeMake(SCREENWIDTH * num, 0);
    for (NSInteger i = 0; i < num; i++) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(i * self.view.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height) collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[BaseServiceCollectionCell class] forCellWithReuseIdentifier:baseIdentifier];
        [self.collectionViews addObject:collectionView];
        [self.scrollView addSubview:collectionView];
    }
}

#pragma mark ----------------UICollectionViewDataSource----------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == [self.collectionViews objectAtIndex:0]) {
        NSArray *arr = [self.productsDic valueForKey:@"2"];
        return arr.count;
    }
    NSArray *arr = [self.productsDic valueForKey:@"3"];
    return arr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if ([collectionView == [self.collectionViews objectAtIndex:self.currentPage]]) {
//        
//    }
    BaseServiceCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:baseIdentifier forIndexPath:indexPath];
    NSArray *arr = nil;
    if (self.segView.currentIndex == 0) {
        arr = [self.productsDic valueForKey:@"2"];
    } else {
        arr = [self.productsDic valueForKey:@"3"];
    }
    BaseServiceObject *obj = [arr objectAtIndex:indexPath.item];
    [cell configureWithIndexPath:indexPath object:obj];
    return cell;
}
#pragma mark ----------------UICollectionViewDelegate----------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Product" bundle:nil];
    PickServicesCollectionViewController *pickServiceVC = [storyboard instantiateViewControllerWithIdentifier:@"pickservicevc"];
    pickServiceVC.productsDic = self.productsDic;
    NSArray *arr = nil;
    if (self.segView.currentIndex == 0) {
        arr = [self.productsDic valueForKey:@"2"];
        pickServiceVC.serviceType = ServiceTypeBase;
    } else {
        arr = [self.productsDic valueForKey:@"3"];
        pickServiceVC.serviceType = ServiceTypeValueAdded;
    }
    for (NSString *key in self.productsDic.allKeys) {
        NSArray *arr = [self.productsDic valueForKey:key];
        for (BaseServiceObject *obj in arr) {
            if ([key isEqualToString:@"1"]) {
                obj.months = 1;
            } else {
                obj.months = 3;
            }
        }
    }
    
    BaseServiceObject *obj = [arr objectAtIndex:indexPath.item];
    pickServiceVC.baseServiceObj = obj;
    
    pickServiceVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pickServiceVC animated:YES];
}
#pragma mark ----------------UICollectionViewDelegateFlowLayout----------------
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(30, 0, 30, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 30;
}

#define rate 0.256
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREENWIDTH - 40, (SCREENWIDTH - 40) * rate);
}

#pragma mark ----------------UIScrollViewDelegate----------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat page = self.scrollView.contentOffset.x / SCREENWIDTH;
    
    if (page > 0.5 && page <= 1) {
        self.currentPage = (NSInteger)ceilf(page);
    } else if (page >0 && page <= 0.5) {
        self.currentPage = (NSInteger)floorf(page);
    } else {
        return;
    }
    [self.segView changeSelectedSegIndex:self.currentPage];
    [self.segView changeSelectedSegIndex:self.currentPage];
    [[self.collectionViews objectAtIndex:self.segView.currentIndex] reloadData];
//
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat page = self.scrollView.contentOffset.x / SCREENWIDTH;
    self.currentPage = (NSInteger)ceilf(page);
}

#pragma mark ----------------CustomSegViewDelegate----------------
- (void)customSegView:(CustomSegView *)segView didChangeItemsAtIndex:(NSInteger)index {
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint offset = self.scrollView.contentOffset;
        offset.x = index * SCREENWIDTH;
        self.scrollView.contentOffset = offset;
    }];
}

#pragma mark ----------------PopViewDelegate----------------
- (void)filterProductWithDic:(NSDictionary *)dic {
#warning 筛选
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark ----------------返回数据处理----------------
- (void)didRequestReceiveResponse:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[info valueForKey:kNotificationName] object:nil];
    if ([[info valueForKey:kRespResult] isEqualToString:SUCCESS]) {
        NSDictionary *respData = [info valueForKey:KRESPDATA];
        if ([[respData valueForKey:STATUS] integerValue] == ResponseCodeSuccess) {
                //登陆成功
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_PRODUCTLIST]) {
                [self.productsDic removeAllObjects];
                NSArray *allKeys = [respData valueForKey:KDATA];
                for (NSString *key in allKeys) {
                    NSArray *arr = [MTLJSONAdapter modelsOfClass:[BaseServiceObject class] fromJSONArray:[[respData valueForKey:KDATA] valueForKey:key] error:nil];
                    if (arr) {
                        [self.productsDic setObject:arr forKey:key];
                    }
                }
                [[self.collectionViews objectAtIndex:self.segView.currentIndex] reloadData];
            }
//            if ([[info valueForKey:kNotificationName] isEqualToString:@"test"]) {
//                
//            }
        } else {
            [SVProgressHUD showErrorWithStatus:[respData valueForKey:kMessage]];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:[info valueForKey:kRespContent]];
    }
}
@end
