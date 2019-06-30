//
//  WeekViewCell.h
//  WeekCalendar
//
//  Created by Anna Ershova on 6/29/19.
//  Copyright © 2019 Anna Ershova. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface WeekViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UIView *selectedDay;
@property (weak, nonatomic) IBOutlet UIView *redDayView;
@property (strong, nonatomic) NSDate *currentDay;

@end


