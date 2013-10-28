//
//  HIScrollCalendarDayView.h
//
//  Created by Furuyama Yuuki on 10/28/13.
//  Copyright (c) 2013 Furuyama Yuuki. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DAY_SCROLL_VIEW_BG_COLOR [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]
#define DAY_SCROLL_VIEW_TEXT_COLOR [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0]
#define DAY_VIEW_NORMAL_BG_COLOR [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]
#define DAY_VIEW_SELECTED_BG_COLOR [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0]
#define DAY_VIEW_HEIGHT 90

@class HIScrollCalendarDayView;

@protocol HIScrollCalendarDayViewDelegate <NSObject>
@required
- (void)scrollCalendarDayViewDidTouch:(HIScrollCalendarDayView*)scrollCalendarDayView;
@end

@interface HIScrollCalendarDayView : UIView {
}

- (id)initWithDateComponents:(NSDateComponents*)dateComp offsetX:(CGFloat)offsetX;
- (void)select;
- (void)unselect;
- (void)setShadowOnRightEdge;
- (void)setShadowOnLeftEdge;

@property (strong, nonatomic) id<HIScrollCalendarDayViewDelegate> delegate;
@property (strong, nonatomic) NSDateComponents *dateComp;
@property (strong, nonatomic) NSMutableArray *shadowLayers;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) BOOL isTodayView;
@property (nonatomic) BOOL isDayOne;

@end
