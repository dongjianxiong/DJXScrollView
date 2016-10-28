//
//  DJXScrollView.m
//  DJXScrollView
//
//  Created by umeng on 16/9/26.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import "DJXScrollView.h"
#import "UIImageView+DJXWebImage.h"



@interface DJXScrollView ()<UIScrollViewDelegate>

/**
 * 子视图的位置
 */
@property (nonatomic, assign) DJXScrollSubViewLocation subViewLocation;

/**
 * 子视图数组
 */
@property (nonatomic, strong) NSMutableArray *contentViews;

/**
 * 当前页
 */
@property (nonatomic, assign) NSInteger currentPageIndex;

/**
 * 显示分页标记
 */
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation DJXScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.contentViews = [NSMutableArray array];
        self.delegate = self;
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + frame.size.height + 5, frame.size.width, 30)];
        self.pageControl.pageIndicatorTintColor = [UIColor greenColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        self.pageControl.currentPage = 0;
        [self addSubview:self.pageControl];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame contentViewBlock:(DJXContentViewWithIndex)contenViewBlock
{
    self = [self initWithFrame:frame];
    if (self) {
        self.contenViewBlock = contenViewBlock;
    }
    return self;
}

- (void)setTotalCount:(NSInteger)totalCount
{
    _totalCount = totalCount;
        
    if (_totalCount > 0) {
        if (_totalCount == 1) {//当只有一张图片的时候不滚动
            self.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            self.contentOffset = CGPointMake(0, 0);
            self.scrollEnabled = NO;
        }else{
            //当图片数大于一张时可以滚动
            self.contentSize = CGSizeMake(3*CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            self.contentOffset = CGPointMake(self.frame.size.width, 0);
            self.scrollEnabled = YES;
        }
        [self configContentView];
    }else{
        [self.contentViews removeAllObjects];
    }
    self.pageControl.numberOfPages = totalCount;
}

//当视图滚动的时候
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >= (2*CGRectGetWidth(scrollView.frame))) {
        
        self.currentPageIndex = [self validNextPageWithExpectedNextPage:self.currentPageIndex+1];
        [self configContentView];
    }
    if (scrollView.contentOffset.x <= 0) {
        
        self.currentPageIndex = [self validNextPageWithExpectedNextPage:self.currentPageIndex-1];
        [self configContentView];
    }
    self.pageControl.currentPage = self.currentPageIndex;
}

//
- (void)configContentView
{
    
    if (self.contenViewBlock) {

        UIImageView *contentView = nil;
        
        if (self.contentViews.count) {
            contentView = self.contentViews[0];
        }
        [self.contentViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [self.contentViews removeAllObjects];
        
        if (self.totalCount == 1) {
            //如果只有一张图片，不需要滚动
            UIView *curView = self.contenViewBlock(self, self.currentPageIndex,DJX_curView);
            [self addSubview:curView];
            [self.contentViews addObject:curView];

        }else if (self.totalCount > 1){
        
            //获取子视图
            [self getContentViewsWithLocations];
            
            //重新对子视图进行布局
            for (int index = 0; index < self.contentViews.count; index++) {
                UIImageView *contentView = self.contentViews[index];
                CGRect contentViewFrame = contentView.frame;
                contentViewFrame.origin.x = index*self.frame.size.width + (self.frame.size.width - contentViewFrame.size.width)/2;
                contentView.frame = contentViewFrame;
                
                if (contentView.gestureRecognizers.count <= 0) {
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                    [contentView addGestureRecognizer:tap];
                }
                [self addSubview:contentView];
            }
            //视图布局完之后返回到中间的位置
            [self setContentOffset:CGPointMake(self.bounds.size.width, 0.0f) animated:NO];
            
        }else{
            NSLog(@"There is no subviews to show");
        }
    }else{
        NSLog(@"There is no subviews to show");
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (self.tapActionBlock) {
        self.tapActionBlock(self, self.currentPageIndex, tap.view);
    }
}

//获取子视图
- (void)getContentViewsWithLocations
{
    NSInteger leftPage = [self validNextPageWithExpectedNextPage:self.currentPageIndex-1];
    NSInteger currentPage = self.currentPageIndex;
    NSInteger rightPage = [self validNextPageWithExpectedNextPage:self.currentPageIndex+1];
    
    
    //获取将要在左边显示的视图
    UIView *leftView = self.contenViewBlock(self, leftPage, DJX_leftView);
    [self.contentViews addObject:leftView];
    
    //获取将要在中间显示的视图
    UIView *curView = self.contenViewBlock(self, currentPage, DJX_curView);
    [self.contentViews addObject:curView];
    
    //获取将要在右边显示的视图
    UIView *rightView = self.contenViewBlock(self, rightPage, DJX_rightView);
    [self.contentViews addObject:rightView];
}

//获取有效下一页
- (NSInteger)validNextPageWithExpectedNextPage:(NSInteger)expectedNextPage
{
    if (expectedNextPage == -1) {
        return self.totalCount - 1;
    }else if (expectedNextPage == self.totalCount || expectedNextPage < -1){
        return 0;
    }else if (expectedNextPage > self.totalCount){
        return self.totalCount - 1;
    }else{
        return expectedNextPage;
    }
}

- (void)didMoveToSuperview
{
    [self.superview addSubview:self.pageControl];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
