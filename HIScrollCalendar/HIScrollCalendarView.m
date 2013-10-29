//
//  HIScrollCalendarView.m
//
//  Created by Furuyama Yuuki on 10/28/13.
//  Copyright (c) 2013 Furuyama Yuuki. All rights reserved.
//

#import "HIScrollCalendarView.h"
#import "HIScrollCalendarUtil.h"

@interface HIScrollCalendarView () {
}

@end

@implementation HIScrollCalendarView

- (id)init
{
    self = [super init];
    if (self) {
        CGRect screenBounds = [HIScrollCalendarUtil getScreenBounds];
        self.frame = CGRectMake(0, 0, screenBounds.size.width, CALENDAR_VIEW_HEIGHT);
        
        // month
        UIView *monthView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, MONTH_VIEW_HEIGHT)];
        [monthView setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]];
        [self addSubview:monthView];
        UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width/2, MONTH_VIEW_HEIGHT)];
        monthLabel.backgroundColor = [UIColor clearColor];
        monthLabel.font = [UIFont fontWithName:@"ArialMT" size:15];
        monthLabel.textAlignment = NSTextAlignmentCenter;
        monthLabel.textColor = [UIColor whiteColor];
        monthLabel.center = CGPointMake(screenBounds.size.width/2, MONTH_VIEW_HEIGHT/2);
        self.monthLabel = monthLabel;
        [monthView addSubview:monthLabel];
        [self setMonth:[HIScrollCalendarUtil getMonthFromDate:[NSDate date]]];
        
        // weekview
        self.weekView = [[HIScrollCalendarWeekView alloc] initWithFrame:CGRectMake(0, MONTH_VIEW_HEIGHT, screenBounds.size.width, DAY_VIEW_HEIGHT)];
        [self addSubview:self.weekView];
        self.weekView.weekViewDelegate = self;
    }
    
    return self;
}

- (void)setMonth:(NSUInteger)month
{
    [self.monthLabel setText:[HIScrollCalendarUtil monthNumToStr:month]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    if ([touch.view isKindOfClass:[HIScrollCalendarDayView class]]) {
        [self fixedTodayViewDidTouch:(HIScrollCalendarDayView *)touch.view];
    }
}

- (void)fixedTodayViewDidTouch:(HIScrollCalendarDayView *)fixedTodayView
{
    if ([self.delegate respondsToSelector:@selector(scrollCalendarView:dateDidChange:)]) {
        [self.delegate scrollCalendarView:self dateDidChange:fixedTodayView.dateComp];
    }
    
    HIScrollCalendarWeekView *weekView = self.weekView;
    CGRect screenBounds = [HIScrollCalendarUtil getScreenBounds];
    CGFloat screenWidth = screenBounds.size.width;
    
    // todayView is in week buffers
    if (weekView.todayView != nil) {
        [self.weekView unselectAllDays];
        [self.weekView scrollViewToCenter:self.weekView.todayView];
        
    // todayView is out of week buffers
    } else {
        // all delete
        for (int i = 0, l = weekView.dayViews.count; i < l; i++) {
            [weekView removeDayView:[weekView.dayViews objectAtIndex:0] atIndex:0];
        }
        // all insert
        NSDate *today = [NSDate date];
        for (int i = 0; i < 35; i++) {
            NSDateComponents *dateComp = [HIScrollCalendarUtil dateComponentsWithDays:(i - 17) fromDate:today];
            HIScrollCalendarDayView *dayView = [[HIScrollCalendarDayView alloc] initWithDateComponents:dateComp offsetX:(screenWidth / 7) * i];
            [weekView insertDayView:dayView atIndex:-1];
            
            if (dayView.isTodayView) {
                weekView.todayView = dayView;
            }
        }
        CGFloat fixedTodayViewOffsetXInScreen = ([fixedTodayView convertPoint:CGPointZero toView:self.window]).x;

        // set offset to edge of screen so that weekView is seeemd to scroll smoothly
        if (fixedTodayViewOffsetXInScreen == 0) {
            CGFloat newOffsetX = weekView.contentSize.width - screenWidth;
            weekView.contentOffset = CGPointMake(newOffsetX, weekView.contentOffset.y);
        } else {
            weekView.contentOffset = CGPointMake(0, weekView.contentOffset.y);
        }

        weekView.isContentMutable = FALSE;
        [weekView scrollViewToCenter:weekView.todayView];
        [self setMonth:weekView.todayView.dateComp.month];
    }
}

#pragma mark -
#pragma mark HIScrollCalendarWeekViewDelegate
- (void)scrollCalendarWeekView:(HIScrollCalendarWeekView *)scrollCalendarWeekView didSelectDate:(NSDateComponents *)dateComponents
{
    if ([self.delegate respondsToSelector:@selector(scrollCalendarView:dateDidChange:)]) {
        [self.delegate scrollCalendarView:self dateDidChange:dateComponents];
    }
}

- (void)scrollCalendarWeekView:(HIScrollCalendarWeekView *)scrollCalendarWeekView didChangeYear:(NSUInteger)year month:(NSUInteger)month
{
    [self setMonth:month];
}

- (void)scrollCalendarWeekView:(HIScrollCalendarWeekView *)scrollCalendarWeekView todayViewDidOutDisplay:(NSDateComponents *)today fromRight:(BOOL)isFromRight
{
    CGFloat screenWidth = ([HIScrollCalendarUtil getScreenBounds]).size.width;
    self.scrollCalendarFixedTodayView = [[HIScrollCalendarDayView alloc] initWithDateComponents:today offsetX:0];
    if (isFromRight) {
        self.scrollCalendarFixedTodayView.frame = CGRectMake(screenWidth - (screenWidth/7), MONTH_VIEW_HEIGHT, screenWidth/7, DAY_VIEW_HEIGHT);
        [self.scrollCalendarFixedTodayView setShadowOnLeftEdge];
    } else {
        self.scrollCalendarFixedTodayView.frame = CGRectMake(0, MONTH_VIEW_HEIGHT, screenWidth/7, DAY_VIEW_HEIGHT);
        [self.scrollCalendarFixedTodayView setShadowOnRightEdge];
    }
    [self addSubview:self.scrollCalendarFixedTodayView];
}

- (void)scrollCalendarWeekView:(HIScrollCalendarWeekView *)scrollCalendarWeekView todayViewDidInDisplay:(NSDateComponents *)today
{
    [self.scrollCalendarFixedTodayView removeFromSuperview];
    self.scrollCalendarFixedTodayView = nil;
}

@end
