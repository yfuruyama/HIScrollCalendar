//
//  HIScrollCalendarWeekView.m
//
//  Created by Furuyama Yuuki on 10/28/13.
//  Copyright (c) 2013 Furuyama Yuuki. All rights reserved.
//

#import "HIScrollCalendarWeekView.h"
#import "HIScrollCalendarUtil.h"

@interface HIScrollCalendarWeekView () {
}

@end

@implementation HIScrollCalendarWeekView

/*
 * HIScrollCalendarWeekView has week buffers.
 * Week buffers consist of 5 week buffer.
 * 
 * [week buffer]
 * --------------------------------------
 * |           |            |           |
 * |  2 weeks  |   1 week   |  2 weeks  |
 * |           |(in display)|           |
 * --------------------------------------
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect screenBounds = [HIScrollCalendarUtil getScreenBounds];
        self.backgroundColor = DAY_SCROLL_VIEW_BG_COLOR;
        self.contentSize = CGSizeMake(screenBounds.size.width * 5, DAY_VIEW_HEIGHT);
        self.delegate = self;
        self.isContentMutable = TRUE;
        
        self.dayOneViews = [[NSMutableArray alloc] init];
        self.dayViews = [NSMutableArray arrayWithCapacity:35];
        
        // init dayViwes
        NSDate *today = [NSDate date];
        for (int i = 0; i < 35; i++) {
            NSDateComponents *dateComp = [HIScrollCalendarUtil dateComponentsWithDays:(i - 17) fromDate:today];
            HIScrollCalendarDayView *dayView = [[HIScrollCalendarDayView alloc] initWithDateComponents:dateComp offsetX:(screenBounds.size.width / 7) * i];
            [self insertDayView:dayView atIndex:-1];
            if (dayView.isTodayView) {
                self.todayView = dayView;
            }
        }
        
        // show center of scrollview.
        CGFloat centerOffsetX = (self.contentSize.width / 2.0) - (screenBounds.size.width / 2);
        self.contentOffset = CGPointMake(centerOffsetX, [self contentOffset].y);
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)insertDayView:(HIScrollCalendarDayView *)dayView atIndex:(int)index
{
    if (index == -1) {
        [self.dayViews addObject:dayView];
    } else {
        [self.dayViews insertObject:dayView atIndex:index];
    }
    [self addSubview:dayView];
    
    if (dayView.isTodayView) {
        self.todayView = dayView;
    }
    
    if (dayView.isDayOne) {
        [self.dayOneViews addObject:dayView];
    }
}

- (void)removeDayView:(HIScrollCalendarDayView*)dayView atIndex:(int)index
{
    [dayView removeFromSuperview];
    
    if (dayView.isTodayView) {
        self.todayView = nil;
    }
    
    if (dayView.isDayOne) {
        for (int i = 0, l = self.dayOneViews.count; i < l; i++) {
            if ([self.dayOneViews objectAtIndex:i] == dayView) {
                [self.dayOneViews removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    [self.dayViews removeObjectAtIndex:index];
}

- (void)scrollViewToCenter:(HIScrollCalendarDayView*)dayView
{
    CGRect screenBounds = [HIScrollCalendarUtil getScreenBounds];
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat contentOffsetX = ([self contentOffset]).x;
    CGFloat centerOffsetX = contentOffsetX + (screenWidth / 2);
    CGFloat diffX = centerOffsetX - dayView.frame.origin.x;
    CGFloat newOffsetX = contentOffsetX - diffX + ((screenWidth / 7) / 2);

    [self scrollRectToVisible:CGRectMake(newOffsetX, 0, screenWidth, self.frame.size.height) animated:YES];
}

/*
 This is called whenever scrollview is scrolled and need to layout subviews in scrollview.
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self checkMonthDidChange];
    [self recenterIfNecessary];
    [self checkTodayViewPosition];
}

- (void)checkMonthDidChange
{
    // if dayOneViews.count equals to 2, it's meaningless to check month is changed
    // because in such case, dayOneViews are too far from screen.
    if (self.dayOneViews.count == 1) {
        CGRect screenBounds = [HIScrollCalendarUtil getScreenBounds];
        CGFloat screenWidth = screenBounds.size.width;
    
        HIScrollCalendarDayView *dayOneView = [self.dayOneViews objectAtIndex:0];
        CGFloat contentOffsetX = self.contentOffset.x;
        CGFloat dayOneViewCenterX = dayOneView.center.x;
        
        BOOL isDayOneViewLocatedLeftSideInScreen = (contentOffsetX <= dayOneViewCenterX && dayOneViewCenterX <= (contentOffsetX + (screenWidth/2)));
        BOOL isDayOneViewLocatedRightSideInScreen = (dayOneViewCenterX <= (contentOffsetX+screenWidth) && dayOneViewCenterX > (contentOffsetX+(screenWidth/2)));

        BOOL isPrevDayOneViewLocatedLeftSideInScreen = [self isPrevDayOneViewLocatedLeftSideInScreen];
        BOOL isPrevDayOneViewLocatedRightSideInScreen = [self isPrevDayOneViewLocatedRightSideInScreen];
        
        // Left to Right(month--)
        if (isPrevDayOneViewLocatedLeftSideInScreen && isDayOneViewLocatedRightSideInScreen) {
            NSUInteger month = dayOneView.dateComp.month - 1;
            if (month == 0) month = 12;
            [self.weekViewDelegate scrollCalendarWeekView:self didChangeYear:dayOneView.dateComp.year month:month];
            
        // Right to Left(month++)
        } else if (isPrevDayOneViewLocatedRightSideInScreen && isDayOneViewLocatedLeftSideInScreen) {
            [self.weekViewDelegate scrollCalendarWeekView:self didChangeYear:dayOneView.dateComp.year month:dayOneView.dateComp.month];
        }
        
        [self setIsPrevDayOneViewLocatedLeftSideInScreen:isDayOneViewLocatedLeftSideInScreen];
        [self setIsPrevDayOneViewLocatedRightSideInScreen:isDayOneViewLocatedRightSideInScreen];
    }
    
}

/*
 In order to locate current displayed week at center of scrollview,
 replace week buffer to new one and rearrange each view's position.
 */
- (void)recenterIfNecessary
{
    CGRect screenBounds = [HIScrollCalendarUtil getScreenBounds];
    CGFloat currentOffsetX = [self contentOffset].x;
    CGFloat contentWidth = self.contentSize.width;
    
    BOOL isOutOfRightBuffer = (((contentWidth / 5.0) * 3.0) <= currentOffsetX);
    BOOL isOutOfLeftBuffer = (currentOffsetX <= ((contentWidth / 5.0) * 1.0));
    
    if ((isOutOfRightBuffer || isOutOfLeftBuffer) && self.isContentMutable) {
        CGFloat centerOffsetX = (contentWidth / 2.0) - (screenBounds.size.width / 2);
        self.contentOffset = CGPointMake(centerOffsetX, [self contentOffset].y);
        
        if (isOutOfRightBuffer) {
            //NSLog(@"Out of R-Buffer");

            NSDateComponents *lastDateComp = ((HIScrollCalendarDayView *)[self.dayViews lastObject]).dateComp;
            NSDate *lastDate = [HIScrollCalendarUtil getDateFromComponents:lastDateComp];
            
            // delete 1 week from front
            for (int i = 0; i < 7; i++) {
                HIScrollCalendarDayView *willRemovedView = [self.dayViews objectAtIndex:0];
                [self removeDayView:willRemovedView atIndex:0];
            }
            // insert 1 week to backward
            for (int i = 0; i < 7; i++) {
                NSDateComponents *newDateComp = [HIScrollCalendarUtil dateComponentsWithDays:(i+1) fromDate:lastDate];
                HIScrollCalendarDayView *dayView = [[HIScrollCalendarDayView alloc] initWithDateComponents:newDateComp offsetX:0];
                [self insertDayView:dayView atIndex:-1];
            }
        } else if (isOutOfLeftBuffer) {
            //NSLog(@"Out of L-Buffer");

            NSDateComponents *firstDateComp = ((HIScrollCalendarDayView *)[self.dayViews objectAtIndex:0]).dateComp;
            NSDate *firstDate = [HIScrollCalendarUtil getDateFromComponents:firstDateComp];
            
            // delete 1 week from backward
            for (int i = 0; i < 7; i++) {
                HIScrollCalendarDayView *willRemovedView = [self.dayViews lastObject];
                [self removeDayView:willRemovedView atIndex:(self.dayViews.count-1)];
            }
            // insert 1 week to front
            for (int i = 0; i < 7; i++) {
                NSDateComponents *newDateComp = [HIScrollCalendarUtil dateComponentsWithDays:(-(i+1)) fromDate:firstDate];
                HIScrollCalendarDayView *dayView = [[HIScrollCalendarDayView alloc] initWithDateComponents:newDateComp offsetX:0];
                [self insertDayView:dayView atIndex:0];
            }
        }
        
        // replace each dayView
        for (int i = 0; i < 35; i++) {
            HIScrollCalendarDayView *dayView = [self.dayViews objectAtIndex:i];
            CGRect newFrame = dayView.frame;
            newFrame.origin.x = (screenBounds.size.width / 7) * i;
            newFrame.origin.y = 0;
            dayView.frame = newFrame;
        }
    }
}

- (void)checkTodayViewPosition
{
    if (self.todayView != nil) {
        CGFloat screenWidth = ([HIScrollCalendarUtil getScreenBounds]).size.width;
        CGFloat prevTodayViewOffsetXInScreen = [self prevTodayViewOffsetXInScreen];
        CGFloat todayViewOffsetXInScreen = ([self.todayView convertPoint:CGPointZero toView:self.window]).x;
        BOOL isTodayViewShowedInScreen = (0 <= todayViewOffsetXInScreen && todayViewOffsetXInScreen <= (screenWidth - (screenWidth/7)));
        BOOL isPrevTodayViewShowedInScreen = (0 <= prevTodayViewOffsetXInScreen && prevTodayViewOffsetXInScreen <= (screenWidth - (screenWidth/7)));
        
        // todayView to inside
        if (isTodayViewShowedInScreen && !isPrevTodayViewShowedInScreen) {
            NSDateComponents *dateComp = [HIScrollCalendarUtil dateComponentsWithDays:0 fromDate:[NSDate date]];
            [self.weekViewDelegate scrollCalendarWeekView:self todayViewDidInDisplay:dateComp];

        // todayView to outside
        } else if (!isTodayViewShowedInScreen && isPrevTodayViewShowedInScreen) {
            if (todayViewOffsetXInScreen < 0) {
                NSDateComponents *dateComp = [HIScrollCalendarUtil dateComponentsWithDays:0 fromDate:[NSDate date]];
                [self.weekViewDelegate scrollCalendarWeekView:self todayViewDidOutDisplay:dateComp fromRight:FALSE];
            } else if (todayViewOffsetXInScreen > (screenWidth - (screenWidth/7))) {
                NSDateComponents *dateComp = [HIScrollCalendarUtil dateComponentsWithDays:0 fromDate:[NSDate date]];
                [self.weekViewDelegate scrollCalendarWeekView:self todayViewDidOutDisplay:dateComp fromRight:TRUE];
            }
        }
        
        [self setPrevTodayViewOffsetXInScreen:todayViewOffsetXInScreen];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    if ([touch.view isKindOfClass:[HIScrollCalendarDayView class]]) {
        HIScrollCalendarDayView *targetView = (HIScrollCalendarDayView*)touch.view;
        [self unselectAllDays];
        [targetView select];
        [self scrollViewToCenter:targetView];
        
        // notify
        [self.weekViewDelegate scrollCalendarWeekView:self didSelectDate:targetView.dateComp];
        
    }
}

- (void)unselectAllDays
{
    for (int i = 0, l = [self.dayViews count]; i < l; i++) {
        HIScrollCalendarDayView *dayView = [self.dayViews objectAtIndex:i];
        [dayView unselect];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.isContentMutable = TRUE;
}

@end
