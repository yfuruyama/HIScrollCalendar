//
//  HIScrollCalendarUtil.m
//
//  Created by Furuyama Yuuki on 10/28/13.
//  Copyright (c) 2013 Furuyama Yuuki. All rights reserved.
//

#import "HIScrollCalendarUtil.h"

@implementation HIScrollCalendarUtil

+ (CGRect)getScreenBounds
{
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGRect screenBoundsWithStatusBar = [[UIScreen mainScreen] bounds];
    CGRect screenBoundsWithoutStatusBar = CGRectMake(screenBoundsWithStatusBar.origin.x,
                                                     screenBoundsWithStatusBar.origin.y + statusBarHeight,
                                                     screenBoundsWithStatusBar.size.width,
                                                     screenBoundsWithStatusBar.size.height - statusBarHeight);
    return screenBoundsWithoutStatusBar;
}

+ (NSDateComponents *)getDateComponents:(NSCalendarUnit)unit fromDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dc = [calendar components:unit fromDate:date];
    return dc;
}

+ (NSDate *)getDateFromComponents:(NSDateComponents *)dc
{
    NSCalendar *dafaultCalendar = [NSCalendar currentCalendar];
    return [dafaultCalendar dateFromComponents:dc];
}

+ (NSUInteger)getMonthFromDate:(NSDate *)date
{
    NSCalendarUnit unit = NSMonthCalendarUnit;
    return [[self getDateComponents:unit fromDate:date] month];
}

+ (NSDateComponents *)dateComponentsWithDays:(NSInteger)days fromDate:(NSDate *)date
{
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    [comp setDay:days];
    NSDate *newDate = [calendar dateByAddingComponents:comp toDate:date options:0];
    
    return [calendar components:unit fromDate:newDate];
}

+ (NSString *)monthNumToStr:(NSUInteger)monthNum
{
    NSAssert((1 <= monthNum) && (monthNum <= 12), @"monthNum out of range");
    
    NSArray *monthMap = [NSArray arrayWithObjects:
                         @"JANUARY",
                         @"FEBRUARY",
                         @"MARCH",
                         @"APRIL",
                         @"MAY",
                         @"JUNE",
                         @"JULY",
                         @"AUGUST",
                         @"SEPTEMBER",
                         @"OCTOBER",
                         @"NOVEMBER",
                         @"DECEMBER",
                         nil];
    
    return [monthMap objectAtIndex:(monthNum -1)];
}

+ (NSString *)weekdayNumToStr:(NSUInteger)weekdayNum
{
    NSAssert((1 <= weekdayNum) && (weekdayNum <= 7), @"weekdayNum out of range");
    
    NSArray *weekdayMap = [NSArray arrayWithObjects:
                           @"SUN",
                           @"MON",
                           @"TUE",
                           @"WED",
                           @"THU",
                           @"FRI",
                           @"SAT",
                           nil];
    
    return [weekdayMap objectAtIndex:(weekdayNum -1)];
}

@end
