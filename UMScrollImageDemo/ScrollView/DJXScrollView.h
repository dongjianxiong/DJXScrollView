//
//  DJXScrollView.h
//  DJXScrollView
//
//  Created by umeng on 16/9/26.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DJX_curView = 0,
    DJX_leftView,
    DJX_rightView,
    
} DJXScrollSubViewLocation;//读取视图的位置

@class DJXScrollView;

typedef UIView *(^DJXContentViewWithIndex)(DJXScrollView *scrollView, NSInteger index, DJXScrollSubViewLocation location);

typedef void (^DJXContentViewTapAction)(DJXScrollView *scrollView, NSInteger index, UIView *actionView);


@interface DJXScrollView : UIScrollView

/**
 * 总的视图个数
 */
@property (nonatomic, assign) NSInteger totalCount;

/**
 * 点击某个视图时的回调
 */
@property (nonatomic, copy) DJXContentViewTapAction tapActionBlock;

/**
 * 读取视图的回调
 */
@property (nonatomic, copy) DJXContentViewWithIndex contenViewBlock;


- (instancetype)initWithFrame:(CGRect)frame contentViewBlock:(DJXContentViewWithIndex)contenViewBlock;

@end
