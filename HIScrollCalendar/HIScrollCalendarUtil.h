//
//  HIScrollCalendarUtil.h
//
//  Created by Furuyama Yuuki on 10/28/13.
//  Copyright (c) 2013 Furuyama Yuuki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HIScrollCalendarUtil : NSObject

+ (CGRect)getScreenBounds;
+ (NSDate *)getDateFromComponents:(NSDateComponents *)dc;
+ (NSUInteger)getMonthFromDate:(NSDate *)date;
+ (NSString *)monthNumToStr:(NSUInteger)monthNum;
+ (NSString *)weekdayNumToStr:(NSUInteger)weekdayNum;
+ (NSDateComponents *)dateComponentsWithDays:(NSInteger)days fromDate:(NSDate *)date;

@end
