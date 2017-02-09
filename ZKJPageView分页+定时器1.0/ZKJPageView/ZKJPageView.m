//
//  ZKJPageView.m
//  UIScrollview+分页+定时器
//
//  Created by ZKJ on 16/6/17.
//  Copyright © 2016年 ZKJ. All rights reserved.
//

#import "ZKJPageView.h"

@interface ZKJPageView () <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
/** 定时器 */
@property(nonatomic,strong) NSTimer *timer;
@end

@implementation ZKJPageView

/**
 * 当控件通过代码创建时，就会调用这个方法
 * 当控件通过代码创建时，想做一些初始化操作。应该在这个方法中执行
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpValue];
        //添加其他控件
    }
    return self;
}

/**
 * 当控件从xib\storyboard中创建完毕时，就会调用这个方法
 * 当控件从xib\storyboard中创建完毕后的初始化操作。应该在这个方法中执行
 */
- (void)awakeFromNib
{
    [self setUpValue];
}

/**
 * 初始化代码
 */
- (void)setUpValue
{
    self.scrollView.backgroundColor = [UIColor redColor];
    [self startTimer];
}

+ (instancetype)pageView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

#pragma mark - setter方法的重写
- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:imageArray[i]];
        [self.scrollView addSubview:imageView];
    }
    self.pageControl.numberOfPages = imageArray.count;
}

- (void)setCurrentColor:(UIColor *)currentColor
{
    _currentColor = currentColor;
    self.pageControl.currentPageIndicatorTintColor = currentColor;
}

- (void)setOtherColor:(UIColor *)otherColor
{
    _otherColor = otherColor;
    self.pageControl.pageIndicatorTintColor = otherColor;
}

/**
 * 当控件的尺寸发生改变的时候，会自动调用这个方法
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    CGFloat scrollW = self.scrollView.frame.size.width;
    CGFloat scrollH = self.scrollView.frame.size.height;
    
    CGFloat pageW = 120;
    CGFloat pageH = 40;
    CGFloat pageX = scrollW - pageW;
    CGFloat pageY = scrollH - pageH;
    self.pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);
    
    self.scrollView.contentSize = CGSizeMake(scrollW * self.scrollView.subviews.count, 0);
    for (int i = 0; i < self.scrollView.subviews.count; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        imageView.frame = CGRectMake(scrollW * i, 0, scrollW, scrollH);
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

#pragma mark - 定时器控制
/** 开始计时 */
- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nestPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/** 结束倒计时 */
- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

/**
 * 下一页
 */
- (void)nestPage
{
    NSInteger page = self.pageControl.currentPage + 1;
    if (page == self.pageControl.numberOfPages) {
        page = 0;
    }
    
    CGPoint offSet = self.scrollView.contentOffset;
    offSet.x = page * self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:offSet animated:YES];
    NSLog(@"nextPage");
}

@end
