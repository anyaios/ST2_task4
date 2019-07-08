//
//  TimeViewCell.m
//  WeekCalendar
//
//  Created by Anna Ershova on 6/30/19.
//  Copyright © 2019 Anna Ershova. All rights reserved.
//

#import "TimeViewCell.h"
#import "WeekCalendarViewController.h"

@implementation TimeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


- (void)setEvent:(EKEvent *)event {
    _event = event;
    
}


@end
