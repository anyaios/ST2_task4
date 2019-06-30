//
//  WeekViewCell.m
//  WeekCalendar
//
//  Created by Anna Ershova on 6/29/19.
//  Copyright © 2019 Anna Ershova. All rights reserved.
//
#import <EventKit/EventKit.h>
#import "WeekViewCell.h"
#import "WeekCalendarViewController.h"
#import "UIColor+CustomColor.h"

@implementation WeekViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    _currentDay = [NSDate date];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];

    if (selected) {
        _redDayView.hidden = NO;
        _redDayView.backgroundColor = [UIColor colorWithHexString: @"0XFC6769"];
        _redDayView.layer.cornerRadius = _redDayView.frame.size.height / 2.0f;
        
    } else {
        _redDayView.backgroundColor = [UIColor clearColor];
    }
}


@end
