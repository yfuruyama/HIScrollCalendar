//
//  HIScrollCalendarWeekView.h
//
//  Created by Furuyama Yuuki on 10/28/13.
//  Copyright (c) 2013 Furuyama Yuuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "HIScrollCalendarDayView.h"

@class HIScrollCalendarWeekView;

@protocol HIScrollCalendarWeekViewDelegate <NSObject>
@required
- (void)scrollCalendarWeekView:(HIScrollCalendarWeekView *)scrollCalendarWeekView didSelectDate:(NSDateComponents *)dateComponents;
- (void)scrollCalendarWeekView:(HIScrollCalendarWeekView *)scrollCalendarWeekView didChangeYear:(NSUInteger)year month:(NSUInteger)month;
- (void)scrollCalendarWeekView:(HIScrollCalendarWeekView *)scrollCalendarWeekView todayViewDidOutDisplay:(NSDateComponents *)today fromRight:(BOOL)isFromRight;
- (void)scrollCalendarWeekView:(HIScrollCalendarWeekView *)scrollCalendarWeekView todayViewDidInDisplay:(NSDateComponents *)today;
@end

@interface HIScrollCalendarWeekView : UIScrollView <UIScrollViewDelegate>{
}

@property (strong, nonatomic) id<HIScrollCalendarWeekViewDelegate> weekViewDelegate;
@property (nonatomic) CGFloat prevTodayViewOffsetXInScreen;
@property (nonatomic) BOOL isPrevDayOneViewLocatedLeftSideInScreen;
@property (nonatomic) BOOL isPrevDayOneViewLocatedRightSideInScreen;
@property (strong, nonatomic) NSMutableArray *dayViews;
@property (strong, nonatomic) HIScrollCalendarDayView *todayView;
@property (strong, nonatomic) NSMutableArray *dayOneViews;
@property (nonatomic) BOOL isContentMutable;

- (id)initWithFrame:(CGRect)frame;
- (void)insertDayView:(HIScrollCalendarDayView *)dayView atIndex:(int)index;
- (void)removeDayView:(HIScrollCalendarDayView*)dayView atIndex:(int)index;
- (void)scrollViewToCenter:(HIScrollCalendarDayView*)dayView;
- (void)unselectAllDays;

@end
