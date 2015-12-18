//
//  JSGridView.h
//  BaseBusiness
//
//  Created by Somiya on 15/11/11.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSGridViewCell.h"

typedef struct {
    NSInteger row;
    NSInteger column;
    NSInteger index;
} JSGridIndexPath;

@protocol JSGridViewDataSource;
@protocol JSGridViewDelegate;

@interface JSGridView : UIView

@property (nonatomic, weak) id<JSGridViewDelegate>delegate;
@property (nonatomic, weak) id<JSGridViewDataSource>dataSource;

- (JSGridViewCell *)dequeueReusableCellWithIdentifier:(NSString *)reuseIdentifier;
- (JSGridIndexPath)indexPathForCell:(JSGridViewCell *)cell;

- (void)reloadData;

- (void)floatingLeftHeader:(BOOL)isFloating;
- (void)removeAllObserver;
@end


@protocol JSGridViewDataSource <NSObject>

- (NSInteger)numberOfRowsForGridView:(JSGridView *)gridView;
- (NSInteger)numberOfColumnForGridView:(JSGridView *)gridView;
- (JSGridViewCell *)gridView:(JSGridView *)gridView cellForGridViewIndexPath:(JSGridIndexPath)indexPath;

@optional
- (CGFloat)gridView:(JSGridView *)gridView heightForRow:(NSInteger)row;
- (CGFloat)gridView:(JSGridView *)gridView widthForColumn:(NSInteger)column;
@end

@protocol JSGridViewDelegate <NSObject>

- (void)gridView:(JSGridView *)gridView didSelectCellAtIndexPath:(JSGridIndexPath)indexPath;

@end