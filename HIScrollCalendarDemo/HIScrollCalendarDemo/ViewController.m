//
//  ViewController.m
//  HIScrollCalendarDemo
//
//  Created by Furuyama Yuuki on 10/28/13.
//  Copyright (c) 2013 Furuyama Yuuki. All rights reserved.
//

#import "ViewController.h"
#import "HIScrollCalendarView.h"

@interface ViewController () <HIScrollCalendarViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    HIScrollCalendarView *calendarView = [[HIScrollCalendarView alloc] init];
    calendarView.frame = CGRectMake(0, 20, calendarView.frame.size.width, calendarView.frame.size.height);
    calendarView.delegate = self;
    [self.view addSubview:calendarView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark HIScrollCalendarViewDelegate
- (void)scrollCalendarView:(HIScrollCalendarView *)scrollCalendarView dateDidChange:(NSDateComponents *)dateComponent
{
    NSString *dateString = [NSString stringWithFormat:@"%d/%d/%d", dateComponent.year, dateComponent.month, dateComponent.day];
    NSLog(@"%@", dateString);
}

@end
