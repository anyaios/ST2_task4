//
//  WeekViewCell.m
//  WeekCalendar
//
//  Created by Anna Ershova on 6/29/19.
//  Copyright © 2019 Anna Ershova. All rights reserved.
//

#import "WeekViewCell.h"
#import "WeekCalendarViewController.h"

@implementation WeekViewCell


- (void)awakeFromNib {
    [super awakeFromNib];


}
- (void)configurateDate: (NSDate*)date withDay: (NSDateComponents*)day {
    
}
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];

    if (selected) {
        _redDayView.hidden = NO;
        _redDayView.backgroundColor = [UIColor redColor];
        _redDayView.layer.cornerRadius = _redDayView.bounds.size.height / 2.0f;
        
    } else {
        _redDayView.backgroundColor = [UIColor clearColor];
  
    }
}


@end
