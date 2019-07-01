//
//  WeekCalendarViewController.h
//  WeekCalendar
//
//  Created by Anna Ershova on 6/29/19.
//  Copyright © 2019 Anna Ershova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface WeekCalendarViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *weekView;
@property (weak, nonatomic) IBOutlet UICollectionView *timeView;


@property (strong, nonatomic) EKEventStore *eventStore;
@property (nonatomic) BOOL isAccessToEventStoreGranted;
@property (strong, nonatomic) NSMutableArray *todoItems;

@end


