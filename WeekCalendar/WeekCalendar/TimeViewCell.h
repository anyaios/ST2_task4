//
//  TimeViewCell.h
//  WeekCalendar
//
//  Created by Anna Ershova on 6/30/19.
//  Copyright © 2019 Anna Ershova. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface TimeViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *timeViewText;

@end


