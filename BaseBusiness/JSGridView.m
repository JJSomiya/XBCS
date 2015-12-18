//
//  JSGridView.m
//  BaseBusiness
//
//  Created by Somiya on 15/11/11.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "JSGridView.h"
#import "UIScrollView+FloatingHeader.h"
#import "UIGestureRecognizer+FloatingHeaderUtil.h"

static const CGFloat kGridViewDefaultRowHeight    = 30.0f;
static const CGFloat kGridViewDefaultColumnWidth  = 100.0f;

@interface JSGridView () {
    NSUInteger          _numberOfRows;
    NSUInteger          _numberOfColumn;
    NSMutableSet        *_cellCache;
    NSMutableDictionary *_cellPaths;
}

@property (nonatomic, strong) UIScrollView *verticalScrollView;
@property (nonatomic, strong) UIView *horizontalView;
@property (nonatomic, strong) UIView *verticalView;
@property (nonatomic, strong) UIView *cornerView;


- (void)clearCachedCells;

@end

@implementation JSGridView
@synthesize dataSource              = _dataSource;
@synthesize delegate                = _delegate;
@synthesize verticalScrollView      = _verticalScrollView;
@synthesize horizontalView          = _horizontalView;
@synthesize verticalView            = _verticalView;
@synthesize cornerView              = _cornerView;

#pragma mark ----------------System----------------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfColumn = 0;
        _numberOfRows   = 0;
        
        _horizontalView = [[UIView alloc] initWithFrame:CGRectZero];
        _horizontalView.backgroundColor = RGB_HEX(0xefefef);
        _verticalView = [[UIView alloc] initWithFrame:CGRectZero];
        _verticalView.backgroundColor = RGB_HEX(0xefefef);
        _cornerView = [[UIView alloc] initWithFrame:CGRectZero];
        _cornerView.backgroundColor = RGB_HEX(0xefefef);

        _verticalScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _verticalScrollView.directionalLockEnabled = YES;
        _verticalScrollView.bounces = NO;
        _verticalScrollView.backgroundColor = RGB_HEX(0xefefef);
        [_verticalScrollView setIsFloatingLeft:@(YES)];
        [self addSubview:_verticalScrollView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCachedCells) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[JSGridViewCell class]]) {
            [view removeFromSuperview];
        }
    }
    _numberOfColumn = [self.dataSource numberOfColumnForGridView:self];
    _numberOfRows = [self.dataSource numberOfRowsForGridView:self];
    
    int currentY = 0;
    int contentHeight = 0;
    
    CGFloat rowHeight = kGridViewDefaultRowHeight;
    CGFloat columnWidth = kGridViewDefaultColumnWidth;
    int colCount = 0;
    CGFloat firstRowH = 0.0;
    for (int row = 0; row < _numberOfRows; row++) {
        int currentX = 0;
        int contentWidth = 0;
        CGFloat firstColumnW = 0.0;
        if ([self.dataSource respondsToSelector:@selector(gridView:heightForRow:)]) {
            rowHeight = [self.dataSource gridView:self heightForRow:row];
        }
        for (int column = 0; column < _numberOfColumn; column++) {
            JSGridIndexPath indexPath;
            indexPath.row = row;
            indexPath.column = column;
            indexPath.index = colCount++;
            
            if ([self.dataSource respondsToSelector:@selector(gridView:widthForColumn:)]) {
                columnWidth = [self.dataSource gridView:self widthForColumn:column];
            }
            JSGridViewCell *cell = [self.dataSource gridView:self cellForGridViewIndexPath:indexPath];

            if (row == 0 && column == 0) {
                CGRect frame = CGRectMake(0, 0, columnWidth, rowHeight);
                cell.frame = frame;
                [_cornerView addSubview:cell];
            } else if (row != 0 && column == 0) {
                CGRect frame = CGRectMake(0, contentHeight, columnWidth, rowHeight);
                cell.frame = frame;
                [_verticalView addSubview:cell];
            } else if (row == 0 && column != 0) {
                CGRect frame = CGRectMake(contentWidth, 0, columnWidth, rowHeight);
                cell.frame = frame;
                [_horizontalView addSubview:cell];
            } else {
                CGRect currentCellFrame = CGRectMake(contentWidth, contentHeight, columnWidth, rowHeight);
                cell.frame = currentCellFrame;
                [_verticalScrollView addSubview:cell];
                currentX += columnWidth;
            }
            if (cell.reuseIdentifier) {
                [_cellCache addObject:cell];
            }
            [_cellPaths setObject:[NSValue value:&indexPath withObjCType:@encode(JSGridIndexPath)] forKey:[NSNumber numberWithInt:(int)cell]];
            
            if ([self.delegate respondsToSelector:@selector(gridView:didSelectCellAtIndexPath:)]) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithCallback:^(id sender) {
                    [self.delegate gridView:self didSelectCellAtIndexPath:indexPath];
                }];
                cell.gestureRecognizers = @[tap];
            }
            contentWidth += columnWidth;
            
            if (column == 0) {
                firstColumnW = columnWidth;
            }
        }
        if (row != 0) {
            currentY += rowHeight;
        }
        contentHeight += rowHeight;
        
        if (row == 0) {
            CGRect hFrame = _horizontalView.frame;
            hFrame.size.height = rowHeight;
            _horizontalView.frame = hFrame;
            firstRowH = rowHeight;
        }
        
        CGSize contentSize_V = _verticalScrollView.contentSize;
        contentSize_V.width = contentWidth;
        contentSize_V.height = contentHeight;
        _verticalScrollView.contentSize = contentSize_V;

        CGRect vFrame = _verticalView.frame;
        vFrame.size.height = contentHeight;
        vFrame.size.width = firstColumnW;
        _verticalView.frame = vFrame;
        [_verticalScrollView setFloatingLeftHeaderView:_verticalView];
        
        CGRect hFrame = _horizontalView.frame;
        hFrame.size.width = contentWidth;
        _horizontalView.frame = hFrame;
        [_verticalScrollView setFloatingTopHeaderView:_horizontalView];
        
        CGRect cFrame = _cornerView.frame;
        cFrame.size.width = firstColumnW;
        cFrame.size.height = firstRowH;
        _cornerView.frame = cFrame;
        [_verticalScrollView setFloatingTopLeftCornerView:_cornerView];
    }
}
#pragma mark ----------------功能函数----------------
- (void)clearCachedCells {
    [_cellCache removeAllObjects];
}

#pragma mark ----------------APIs----------------
- (void)reloadData {
    [self layoutSubviews];
}

- (JSGridViewCell *)dequeueReusableCellWithIdentifier:(NSString *)reuseIdentifier {
    NSSet *filteredCells = [_cellCache filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"reuseIdentifier == %@", reuseIdentifier]];
    
    JSGridViewCell *cell = [filteredCells anyObject];
    if (cell != nil) {
        [_cellCache removeObject:cell];
    }
    return cell;
}

- (JSGridIndexPath)indexPathForCell:(JSGridViewCell *)cell {
    NSValue *indexPathValue = [_cellPaths objectForKey:[NSNumber numberWithInt:(int)cell]];
    JSGridIndexPath indexPath;
    [indexPathValue getValue:&indexPath];
    return indexPath;
}

- (void)floatingLeftHeader:(BOOL)isFloating {
    [_verticalScrollView setIsFloatingLeft:@(isFloating)];
}
- (void)removeAllObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_verticalScrollView removeContentOffsetObserver];
}
@end

