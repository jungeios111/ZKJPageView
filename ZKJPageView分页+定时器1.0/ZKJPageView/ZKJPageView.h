//
//  ZKJPageView.h
//  UIScrollview+分页+定时器
//
//  Created by ZKJ on 16/6/17.
//  Copyright © 2016年 ZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKJPageView : UIView
/** 图片数组 */
@property(nonatomic,strong) NSArray *imageArray;
/** 当前圆点的颜色 */
@property(nonatomic,strong) UIColor *currentColor;
/** 其他圆点的颜色 */
@property(nonatomic,strong) UIColor *otherColor;

/** 初始化类方法 */
+ (instancetype)pageView;

@end
