//
//  InfiniteScrollView.m
//  VideoGame
//
//  Created by Hara Kang on 2013. 11. 24..
//  Copyright (c) 2013년 CoderSpinoza. All rights reserved.
//

#import "InfiniteScrollView.h"

@interface InfiniteScrollView()
@property (strong, nonatomic) NSMutableArray *views;
@property (strong, nonatomic) NSMutableArray *hiddenTopViews;
@property (strong, nonatomic) NSMutableArray *hiddenBottomViews;
@property (strong, nonatomic) NSMutableArray *hiddenLeftViews;
@property (strong, nonatomic) NSMutableArray *hiddenRightCiews;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@implementation InfiniteScrollView
@synthesize numRows = _numRows;
@synthesize numColumns = _numColumns;
@synthesize views = _views;
@synthesize hiddenTopViews = _hiddenTopViews;
@synthesize hiddenBottomViews = _hiddenBottomViews;
@synthesize hiddenLeftViews = _hiddenLeftViews;
@synthesize hiddenRightCiews = _hiddenRightViews;
- (NSMutableArray *)hiddenTopViews {
    if (_hiddenTopViews == nil) {
        _hiddenTopViews = [[NSMutableArray alloc] init];
    }
    return _hiddenTopViews;
}
- (NSMutableArray *)hiddenBottomViews {
    if (_hiddenBottomViews == nil) {
        _hiddenBottomViews = [[NSMutableArray alloc] init];
    }
    return _hiddenBottomViews;
}
- (NSMutableArray *)hiddenLeftViews {
    if (_hiddenLeftViews == nil) {
        _hiddenLeftViews = [[NSMutableArray alloc] init];
    }
    return _hiddenLeftViews;
}

- (NSMutableArray *)hiddenRightViews {
    if (_hiddenRightViews == nil) {
        _hiddenRightViews = [[NSMutableArray alloc] init];
    }
    return _hiddenRightViews;
}
- (NSMutableArray *)views {
    if (_views == nil) {
        _views = [[NSMutableArray alloc] initWithCapacity:self.numColumns * self.numRows];
    }
    return _views;
}
- (void)setNumColumns:(NSInteger)numColumns {
    _numColumns = numColumns + 2;
    [self setNeedsDisplay];
}

- (void)setNumRows:(NSInteger)numRows {
    _numRows = numRows + 2;
    [self setNeedsDisplay];
}
//
- (NSInteger)numRows {
    return _numRows - 2;
}

- (NSInteger)numColumns {
    return _numColumns - 2;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.pagingEnabled = YES;
        self.directionalLockEnabled = YES;
        self.delegate = self;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.pagingEnabled = YES;
        self.directionalLockEnabled = YES;
        self.delegate = self;
    }
    return self;
}

- (id)initWithIndexPath:(NSIndexPath *)indexPath {
    
    
    self = [super initWithFrame:self.frame];
    
    if (self) {
        self.numRows = indexPath.section;
        self.numColumns = indexPath.row;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [self setSubviewFrames];
    if (self.indexPath) {
        self.contentOffset = CGPointMake((self.indexPath.row + 1) * [self currentSize].width, (self.indexPath.section + 1) * [self currentSize].height);
    } else {
        self.contentOffset = CGPointMake([self currentSize].width, [self currentSize].height);
    }
}

- (void)setSubviewFrames {
    CGFloat width = _numColumns * [self currentSize].width;
    CGFloat height = _numRows * [self currentSize].height;
    self.contentSize = CGSizeMake(width, height);
    [self.views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = (UIView *)obj;
        view.frame = CGRectMake((((idx) % self.numRows) + 1) * [self currentSize].width, (((idx) / self.numRows) + 1) * [self currentSize].height ,[self currentSize].width, [self currentSize].height);
    }];
    
    [self.hiddenTopViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *hiddenView = (UIView *)obj;
        hiddenView.frame = CGRectMake((idx + 1) * [self currentSize].width, 0 * [self currentSize].height ,[self currentSize].width, [self currentSize].height);
        
    }];
    [self.hiddenBottomViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *hiddenView = (UIView *)obj;
        hiddenView.frame = CGRectMake((idx + 1) * [self currentSize].width, (_numRows - 1) * [self currentSize].height ,[self currentSize].width, [self currentSize].height);
        
    }];
    [self.hiddenLeftViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *hiddenView = (UIView *)obj;
        hiddenView.frame = CGRectMake(0 * [self currentSize].width, (idx + 1) * [self currentSize].height ,[self currentSize].width, [self currentSize].height);
        
    }];
    [self.hiddenRightViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *hiddenView = (UIView *)obj;
        hiddenView.frame = CGRectMake((_numColumns - 1) * [self currentSize].width, (idx + 1) * [self currentSize].height ,[self currentSize].width, [self currentSize].height);
        
    }];
}


- (void)reloadData {
    for (int i = 1; i < _numRows - 1; i++) {
        for (int j = 1; j < _numColumns - 1; j++) {
            [self reloadDataForViewAtIndexPath:[NSIndexPath indexPathForRow:j - 1 inSection:i - 1]];
        }
    }
    
    for (int i = 1; i < _numColumns - 1; i++) {
        UIView *topRow = [self.dataSource infiniteScrollView:self viewForItemAtIndexPath:[NSIndexPath indexPathForRow:i - 1 inSection:self.numRows - 1]];
        UIView *bottomRow = [self.dataSource infiniteScrollView:self viewForItemAtIndexPath:[NSIndexPath indexPathForRow:i - 1 inSection:0]];

        bottomRow.frame = CGRectMake(i * [self currentSize].width, 0, [self currentSize].width, [self currentSize].height);
        topRow.frame = CGRectMake(i * [self currentSize].width, (_numRows - 1) * [self currentSize].height, [self currentSize].width, [self currentSize].height);
        
        [self.hiddenBottomViews addObject:topRow];
        [self.hiddenTopViews addObject:bottomRow];
        [self addSubview:topRow];
        [self addSubview:bottomRow];
        
        
    }
    
    for (int i = 1; i < _numRows - 1; i++) {
        UIView *leftColumn = [self.dataSource infiniteScrollView:self viewForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i - 1]];
        UIView *rightColumn = [self.dataSource infiniteScrollView:self viewForItemAtIndexPath:[NSIndexPath indexPathForRow:self.numColumns - 1 inSection:i - 1]];
        rightColumn.frame = CGRectMake(0, i * [self currentSize].height, [self currentSize].width, [self currentSize].height);
        leftColumn.frame = CGRectMake((_numRows - 1) * [self currentSize].width, i * [self currentSize].height, [self currentSize].width, [self currentSize].height);
        
        [self.hiddenRightViews addObject:leftColumn];
        [self.hiddenLeftViews addObject:rightColumn];
        
        [self addSubview:leftColumn];
        [self addSubview:rightColumn];
    }
}


- (UIView *)viewForIndexPath:(NSIndexPath *)indexPath {
    return [self.views objectAtIndex:self.numColumns * indexPath.section + indexPath.row];
}


/*
 InfiniteScrollViewDelegate
 */

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.infiniteDelegate infiniteScrollView:self scrolledFromIndexPath:[self indexPathFromOffset:scrollView.contentOffset]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath *nextIndexPath = [self indexPathFromOffset:scrollView.contentOffset];
    self.indexPath = nextIndexPath;
    [self.infiniteDelegate infiniteScrollView:self scrolledToIndexPath:self.indexPath];
    NSInteger column = self.contentOffset.x / [self currentSize].width;
    NSInteger row = self.contentOffset.y / [self currentSize].height;
    
    if (column == _numColumns - 1) {
        column = 1;
    } else if (column == 0) {
        column = _numColumns - 2;
    }
    
    if (row == _numRows - 1) {
        row = 1;
    } else if (row == 0) {
        row = _numRows - 2;
    }
    self.contentOffset = CGPointMake(column * self.frame.size.width, row * self.frame.size.height);
}


- (NSIndexPath *)indexPathFromOffset:(CGPoint)offset {
    NSInteger column = offset.x / [self currentSize].width;
    NSInteger row = offset.y / [self currentSize].height;
    
    if (column == _numColumns - 1) {
        column = 1;
    } else if (column == 0) {
        column = _numColumns - 2;
    }
    
    if (row == _numRows - 1) {
        row = 1;
    } else if (row == 0) {
        row = _numRows - 2;
    }
    
    return [NSIndexPath indexPathForRow:column - 1 inSection:row - 1];
}

/*
 InfiniteScrollViewDataSource
 */

- (void)reloadDataForViewAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView *view = [self.dataSource infiniteScrollView:self viewForItemAtIndexPath:indexPath];
    view.frame = CGRectMake((indexPath.row + 1) * [self currentSize].width, (indexPath.section + 1) * [self currentSize].height, [self currentSize].width, [self currentSize].height);
    [self.views addObject:view];
    [self addSubview:view];
}

- (CGSize) currentSize
{
    CGSize currentSize = [[UIScreen mainScreen] bounds].size;
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        currentSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    } else {
        currentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }
    return currentSize;
}
@end
