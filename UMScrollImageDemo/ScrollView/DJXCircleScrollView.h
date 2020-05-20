//
//  DJXScrollView.h
//  DJXScrollView
//
//  Created by umeng on 16/9/26.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DJXCircleScrollView;

@protocol DJXCircleScrollViewDelegate <NSObject>

- (NSInteger)numberOfImage:(DJXCircleScrollView *)scrollView;
- (void)circleScrollView:(DJXCircleScrollView *)scrollView imageView:(UIImageView *)imageView atIndex:(NSInteger)index;
- (UIEdgeInsets)circleScrollViewImageInset:(DJXCircleScrollView *)scrollView;
- (void)circleScrollView:(DJXCircleScrollView *)scrollView didSelectedAtIndex:(NSInteger)index;

@end

@interface DJXCircleScrollView : UIScrollView

@property (nonatomic, weak) id<DJXCircleScrollViewDelegate> circleDelegate;

- (void)reloadImages;

- (void)timerSart:(NSTimeInterval)interval;

@end
