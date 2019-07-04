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

    [self addBottomBorderWithColor:UIColor.darkGrayColor andWidth:1 toView:_timeViewText];
    [self addBottomBorderWithColor:UIColor.darkGrayColor andWidth:1 toView:_min15];
    [self addBottomBorderWithColor:UIColor.darkGrayColor andWidth:1 toView:_min30];
    [self addBottomBorderWithColor:UIColor.darkGrayColor andWidth:1 toView:_min45];
    
}

//}
- (void)setEvent:(EKEvent *)event {
    _event = event;
}
- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth toView:(UIView *)view {
    UIView *border = [UIView new];
    border.backgroundColor = color;
    [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border.frame = CGRectMake(0, view.frame.size.height - borderWidth, view.frame.size.width, borderWidth);
    [view addSubview:border];
}

@end
