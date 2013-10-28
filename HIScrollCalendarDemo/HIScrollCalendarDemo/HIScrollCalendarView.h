//
//  HIScrollCalendarView.h
//
//  Created by Furuyama Yuuki on 10/28/13.
//  Copyright (c) 2013 Furuyama Yuuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HIScrollCalendarWeekView.h"

#define CALENDAR_VIEW_HEIGHT 115
#define MONTH_VIEW_HEIGHT 25

@class HIScrollCalendarView;

@protocol HIScrollCalendarViewDelegate <NSObject>
@optional
- (void)scrollCalendarView:(HIScrollCalendarView*)scrollCalendarView dateDidChange:(NSDateComponents*)dateComponent;
@end

@interface HIScrollCalendarView : UIView <HIScrollCalendarWeekViewDelegate> {
}

@property (strong, nonatomic) id<HIScrollCalendarViewDelegate> delegate;
@property (strong, nonatomic) HIScrollCalendarWeekView *weekView;
@property (strong, nonatomic) UILabel *monthLabel;
@property (strong, nonatomic) HIScrollCalendarDayView *scrollCalendarFixedTodayView;

@end
