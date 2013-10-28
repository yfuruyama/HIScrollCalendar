HIScrollCalender
=================
A simple and beautiful calendar with infinite scrollability.

![screenshot](https://raw.github.com/addsict/HIScrollCalendar/master/Images/screenshot.png)

Features
--------
+ very simple calendar UI
+ A calendar can be scrolled infinitely
+ fix view for Today in the screen automaticaly
+ Your application can get user interaction to calendar through delegate method

Install by CocoaPods
---------------------
In your Podfile:
```
pod 'HIScrollCalendar', :git => 'https://github.com/addsict/HIScrollCalendar.git'
```

How to use
------------
```objective-c
#import "HIScrollCalendarView.h"

@interface ViewController : UIViewController <HIScrollCalendarViewDelegate> {
}
@end

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];

    HIScrollCalendarView *calendarView = [[HIScrollCalendarView alloc] init];
    calendarView.delegate = self;
    [self.view addSubview:calendarView];
}

- (void)scrollCalendarView:(HIScrollCalendarView *)scrollCalendarView dateDidChange:(NSDateComponents *)dateComponent
{
    NSString *date = [NSString stringWithFormat:@"%d/%d/%d", dateComponent.year, dateComponent.month, dateComponent.day];
    NSLog(@"%@", date); // 2013/10/28
}
@end
```

License
--------
This library is distributed as MIT license.

What does "HI" prefix mean?
----------------------------
HIScrollCalendar means "Horizontal Infinite Scroll Calendar".
