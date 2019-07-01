//
//  WeekCalendarViewController.m
//  WeekCalendar
//
//  Created by Anna Ershova on 6/29/19.
//  Copyright © 2019 Anna Ershova. All rights reserved.
//
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "WeekCalendarViewController.h"
#import "WeekViewCell.h"
#import "TimeViewCell.h"
#import "UIColor+CustomColor.h"

@interface WeekCalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation WeekCalendarViewController

- (EKEventStore *)eventStore {
    if (!_eventStore) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
}

- (void)updateAuthorizationStatusToAccessEventStore {
    // 2
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (authorizationStatus) {
            // 3
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted: {
            self.isAccessToEventStoreGranted = NO;
            [self.timeView reloadData];
            break;
        }
            
            // 4
        case EKAuthorizationStatusAuthorized:
            self.isAccessToEventStoreGranted = YES;
            [self fenthEvents];
            [self.timeView reloadData];
            break;
            
            // 5
        case EKAuthorizationStatusNotDetermined: {
            __weak WeekCalendarViewController *weakSelf = self;
            [self.eventStore requestAccessToEntityType:EKEntityTypeEvent
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    weakSelf.isAccessToEventStoreGranted = granted;
                                                    [self fenthEvents];
                                                    [weakSelf.timeView reloadData];
                                                });
                                            }];
            break;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _eventsToTimeView = [NSArray array];
    UINib *weekNib = [UINib nibWithNibName:@"WeekViewCell" bundle:nil];
    [self.weekView registerNib:weekNib forCellWithReuseIdentifier:@"WeekViewCellReuseId"];
    UINib *timeNib = [UINib nibWithNibName:@"TimeViewCell" bundle:nil]; 
    [self.timeView registerNib:timeNib forCellWithReuseIdentifier:@"TimeViewCellReuseId"];
    
    self.weekView.delegate = self;
    self.weekView.dataSource = self;
    [self setHeader];
    [self setWeekView];
    
    _weekView.delegate = self;
    _timeView.delegate = self;
    _weekView.dataSource = self;
    _timeView.dataSource = self;
    

    NSDateFormatter *objTitleFormatter = [NSDateFormatter new];
    [objTitleFormatter setDateFormat:@"d MMMM yyyy"];
    [objTitleFormatter setLocale: [NSLocale localeWithLocaleIdentifier: @"ru_RU"]];
    self.title = [objTitleFormatter stringFromDate:[NSDate date]];



    [self updateAuthorizationStatusToAccessEventStore];
}

-(void)fenthEvents{
    
    NSDate *this_start = nil, *this_end = nil;
    NSDate *date = [NSDate new];
    [self startDate:&this_start andEndDate:&this_end ofWeekOn:date];
    [self setEvents:this_start toDate:this_end];
}


-(void)setEvents:(NSDate *)startDate toDate:(NSDate *)endDate {
   
    NSPredicate *fetchCalendarEvents = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
    NSArray *allEvents = [self.eventStore eventsMatchingPredicate:fetchCalendarEvents];
    NSLog(@" store is %@....", allEvents);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == _weekView) {
        return 7;
    }
    else {
        return 7;
    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (collectionView == _weekView){
        return 1;
    }else {
        return 1;
    }
}


-(NSDate *)dateByAddingDays:(NSInteger)days toDate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setFirstWeekday:2];
    NSDateComponents *components = [NSDateComponents new];
    components.day = days;
    return [calendar dateByAddingComponents: components toDate: date options: 0];
}

- (void)startDate:(NSDate **)start andEndDate:(NSDate **)end ofWeekOn:(NSDate *)date{
    NSDate *startDate = nil;
    NSTimeInterval duration = 0;
    NSCalendar *calendar =  [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setLocale: [NSLocale localeWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    BOOL b = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&startDate interval:&duration forDate:date];
    if(! b){
        *start = nil;
        *end = nil;
        return;
    }
    NSDate *endDate = [startDate dateByAddingTimeInterval:duration-1];
    *start = startDate;
    *end = endDate;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {

    if (collectionView == _weekView) {
        WeekViewCell *weekcell = (WeekViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"WeekViewCellReuseId" forIndexPath:indexPath];
        NSDate *date = [NSDate new];
        
        NSDate *this_start = nil, *this_end = nil;
        [self startDate:&this_start andEndDate:&this_end ofWeekOn:date];
        date = [self dateByAddingDays: indexPath.row toDate: this_start];
        
        NSDateFormatter *objDateFormatter = [NSDateFormatter new];
        [objDateFormatter setDateFormat:@"dd"];
        weekcell.date.text = [objDateFormatter stringFromDate:date];
        
        NSDateFormatter *objDateNameFormatter = [NSDateFormatter new];
        [objDateNameFormatter setLocale: [NSLocale localeWithLocaleIdentifier: @"ru_RU"]];
        [objDateNameFormatter setDateFormat:@"E"];
        weekcell.day.text = [[objDateNameFormatter stringFromDate:date] uppercaseString];
        
        weekcell.currentDay = date;
        
        weekcell.date.tag = indexPath.item;
 
        return weekcell;
    }
    
    else  {
        
        TimeViewCell *timecell = (TimeViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TimeViewCellReuseId" forIndexPath:indexPath];
       // timecell.timeView = [_eventsToTimeView objectAtIndex:indexPath.item];
        timecell.timeViewText.text = @"test";
        return timecell;
    }
    
}



- (void)setHeader{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0X037594"];
    self.navigationController.navigationBar.layer.borderWidth = 0;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xFFFFFF"],
       NSFontAttributeName:[UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold]}];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
}

- (void)setWeekView{
    self.weekView.backgroundColor = [UIColor colorWithHexString:@"0X037594"];
    self.weekView.layer.borderWidth = 0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _weekView) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        float cellWidth = screenWidth / 7.0;
        CGSize size = CGSizeMake(cellWidth, _weekView.frame.size.height);
        return size;
        
    } else {
        CGSize size = CGSizeMake(_timeView.frame.size.width, _timeView.frame.size.height / 24);
        return size;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _weekView){
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.item inSection:0];
        WeekViewCell *cell = (WeekViewCell *)[_weekView cellForItemAtIndexPath:path];
        
        NSDateFormatter *objTitleFormatter = [NSDateFormatter new];
        [objTitleFormatter setDateFormat:@"d MMMM yyyy"];
        [objTitleFormatter setLocale: [NSLocale localeWithLocaleIdentifier: @"ru_RU"]];
        self.title = [objTitleFormatter stringFromDate:cell.currentDay];
        
        
    }
    
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(CGRectGetWidth(self.weekView.frame) / 6, CGRectGetHeight(self.weekView.frame));
//}

@end
