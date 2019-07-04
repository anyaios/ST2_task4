//
//  TimeViewCell.h
//  WeekCalendar
//
//  Created by Anna Ershova on 6/30/19.
//  Copyright © 2019 Anna Ershova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>



@interface TimeViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *timeViewText;
@property (nonatomic, strong) EKEvent *event;
@property (nonatomic, strong) NSString *hour;
@property (weak, nonatomic) IBOutlet UILabel *min15;
@property (weak, nonatomic) IBOutlet UILabel *min30;
@property (weak, nonatomic) IBOutlet UILabel *min45;

@end


