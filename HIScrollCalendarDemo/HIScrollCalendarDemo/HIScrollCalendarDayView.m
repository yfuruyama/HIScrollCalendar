//
//  HIScrollCalendarDayView.m
//
//  Created by Furuyama Yuuki on 10/28/13.
//  Copyright (c) 2013 Furuyama Yuuki. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "HIScrollCalendarDayView.h"
#import "HIScrollCalendarUtil.h"

@implementation HIScrollCalendarDayView

- (id)initWithDateComponents:(NSDateComponents*)dateComp offsetX:(CGFloat)offsetX
{
    self = [super init];
    if (self) {
        CGRect screenBounds = [HIScrollCalendarUtil getScreenBounds];
        
        self.dateComp = dateComp;
        self.isSelected = FALSE;
        self.shadowLayers = [[NSMutableArray alloc] init];
        
        self.frame = CGRectMake(offsetX, 0,  screenBounds.size.width/7, DAY_VIEW_HEIGHT);
        self.backgroundColor = DAY_VIEW_NORMAL_BG_COLOR;
        self.userInteractionEnabled = TRUE;
        
        NSDateComponents *todayDateComponent = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
        if ([todayDateComponent day] == [dateComp day] &&
            [todayDateComponent month] == [dateComp month] &&
            [todayDateComponent year] == [dateComp year]) {
            self.isTodayView = TRUE;
            [self setTodayColor];
        } else {
            self.isTodayView = FALSE;
            CALayer *subLayer = [CALayer layer];
            subLayer.frame = CGRectMake(0, 0, 1, DAY_VIEW_HEIGHT);
            subLayer.backgroundColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0] CGColor];
            [self.layer addSublayer:subLayer];
        }
        
        int dayOfTheWeek = [dateComp weekday];
        NSString *dayOfTheWeekStr = [HIScrollCalendarUtil weekdayNumToStr:dayOfTheWeek];
        UILabel *dayOfTheWeekLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, DAY_VIEW_HEIGHT-38, screenBounds.size.width/7, 15)];
        [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
        [dayOfTheWeekLabel setTextAlignment:NSTextAlignmentCenter];
        [dayOfTheWeekLabel setText:dayOfTheWeekStr];
        [dayOfTheWeekLabel setTextColor:DAY_SCROLL_VIEW_TEXT_COLOR];
        [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"ArialMT" size:10]];
        
        int day = [self.dateComp day];
        self.isDayOne = (day == 1) ? TRUE : FALSE;
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, DAY_VIEW_HEIGHT-30, screenBounds.size.width/7, 30)];
        [dayLabel setBackgroundColor:[UIColor clearColor]];
        [dayLabel setTextAlignment:NSTextAlignmentCenter];
        dayLabel.font = [UIFont fontWithName:@"Georgia" size:16];
        [dayLabel setText:[NSString stringWithFormat:@"%d", day]];
        [dayLabel setTextColor:DAY_SCROLL_VIEW_TEXT_COLOR];
        
        [self addSubview:dayOfTheWeekLabel];
        [self addSubview:dayLabel];
    }
    
    return self;
}

- (void)setTodayColor
{
    self.backgroundColor = [UIColor colorWithRed:0.9 green:0.18 blue:0.15 alpha:1.0];
    [self setShadowInside];
}

- (void)select
{
    self.isSelected = TRUE;
    
    if (!self.isTodayView) {
        self.backgroundColor = DAY_VIEW_SELECTED_BG_COLOR;
        [self setShadowInside];
    }
}

- (void)unselect
{
    self.isSelected = FALSE;
    
    if (self.isTodayView) {
        [self setTodayColor];
    } else {
        self.backgroundColor = DAY_VIEW_NORMAL_BG_COLOR;
        [self unsetShadow];
    }
}

- (void)setShadowInside
{
    // top inside
    CALayer *subLayer = [CALayer layer];
    subLayer.frame = self.bounds;
    [self.layer addSublayer:subLayer];
    subLayer.masksToBounds = YES;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, subLayer.bounds.size.width+10, 2)];
    subLayer.shadowOffset = CGSizeMake(0, -2);
    subLayer.shadowColor = [[UIColor blackColor] CGColor];
    subLayer.shadowOpacity = 1.0;
    subLayer.shadowPath = [path CGPath];
    
    // right inside
    CALayer *subLayer2 = [CALayer layer];
    subLayer2.frame = self.bounds;
    [self.layer addSublayer:subLayer2];
    subLayer2.masksToBounds = YES;
    path = [UIBezierPath bezierPathWithRect:CGRectMake(subLayer.bounds.size.width-1, 0, 2, subLayer.bounds.size.height+10)];
    subLayer2.shadowOffset = CGSizeMake(0, 0);
    subLayer2.shadowColor = [[UIColor blackColor] CGColor];
    subLayer2.shadowOpacity = 0.8;
    subLayer2.shadowPath = [path CGPath];
    
    // left inside
    CALayer *subLayer3 = [CALayer layer];
    subLayer3.frame = self.bounds;
    [self.layer addSublayer:subLayer3];
    subLayer3.masksToBounds = YES;
    path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 2, subLayer.bounds.size.height+10)];
    subLayer3.shadowOffset = CGSizeMake(0, 0);
    subLayer3.shadowColor = [[UIColor blackColor] CGColor];
    subLayer3.shadowOpacity = 0.8;
    subLayer3.shadowPath = [path CGPath];
    
    // bottom inside
    CALayer *subLayer4 = [CALayer layer];
    subLayer4.frame = self.bounds;
    [self.layer addSublayer:subLayer4];
    subLayer4.masksToBounds = YES;
    path = [UIBezierPath bezierPathWithRect:CGRectMake(0, subLayer.bounds.size.height, subLayer.bounds.size.width+10, 2)];
    subLayer4.shadowOffset = CGSizeMake(0, 0);
    subLayer4.shadowColor = [[UIColor blackColor] CGColor];
    subLayer4.shadowOpacity = 0.8;
    subLayer4.shadowPath = [path CGPath];
    
    [self unsetShadow];
    [self.shadowLayers addObject:subLayer];
    [self.shadowLayers addObject:subLayer2];
    [self.shadowLayers addObject:subLayer3];
    [self.shadowLayers addObject:subLayer4];
}

- (void)setShadowOnRightEdge
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(self.bounds.size.width, 0, 2, self.bounds.size.height)];
    [self setShadowOnPath:path];
}

- (void)setShadowOnLeftEdge
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, -2, self.bounds.size.height)];
    [self setShadowOnPath:path];
}

- (void)setShadowOnPath:(UIBezierPath *)path
{
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowPath = [path CGPath];
    self.layer.shadowRadius = 2.0;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.8;
}

- (void)unsetShadow
{
    while ([self.shadowLayers count] != 0) {
        CALayer *willRemovedLayer = [self.shadowLayers lastObject];
        [willRemovedLayer removeFromSuperlayer];
        [self.shadowLayers removeLastObject];
    }
}

@end
