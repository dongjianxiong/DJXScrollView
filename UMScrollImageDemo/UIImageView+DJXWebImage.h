//
//  UIImageView+DJXWebImage.h
//  DJXScrollView
//
//  Created by umeng on 16/9/26.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (DJXWebImage)

- (void)djx_setImageWithUrlStr:(NSString *)urlString placeholder:(UIImage *)placeholder;

@end
