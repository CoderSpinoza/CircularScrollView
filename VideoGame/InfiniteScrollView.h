//
//  InfiniteScrollView.h
//  VideoGame
//
//  Created by Hara Kang on 2013. 11. 24..
//  Copyright (c) 2013년 CoderSpinoza. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfiniteScrollViewDelegate;
@protocol InfiniteScrollViewDataSource;

@interface InfiniteScrollView : UIScrollView <UIScrollViewDelegate>

@property (weak, nonatomic) id<InfiniteScrollViewDelegate> infiniteDelegate;
@property (weak, nonatomic) id<InfiniteScrollViewDataSource> dataSource;
@property (nonatomic, assign) NSInteger numRows;
@property (nonatomic, assign) NSInteger numColumns;
@property (nonatomic, assign) BOOL circular;

- (id)initWithIndexPath:(NSIndexPath *)indexPath;
- (void)reloadData;
- (UIView *)viewForIndexPath:(NSIndexPath *)indexPath;

@end

@protocol InfiniteScrollViewDelegate
- (void)infiniteScrollView:(InfiniteScrollView *) infiniteScrollView scrolledToIndexPath:(NSIndexPath *)indexPath;
- (void)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView scrolledFromIndexPath:(NSIndexPath *)indexPath;

@end

@protocol InfiniteScrollViewDataSource
- (UIView *)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView viewForItemAtIndexPath:(NSIndexPath *)indexPath;

@end