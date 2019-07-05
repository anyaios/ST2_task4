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
@property (nonatomic, strong) NSDate *dateEvent;
@property float sizeOf15min;
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
    
    _hoursForEvents = [self getTimeIntervals:@"00:00:00" andEndTime:@"23:59:00"];
    
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
  //  NSLog(@" store is %@....", allEvents);
    _eventsToTimeView = allEvents;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == _weekView) {
        return 7;
    }
    else {
        return 24;
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
        timecell.timeViewText.text = [NSString stringWithFormat:@"%@:00", _hoursForEvents[indexPath.item]];
        timecell.min15.text = [NSString stringWithFormat:@"%@:15", _hoursForEvents[indexPath.item]];
        timecell.min30.text = [NSString stringWithFormat:@"%@:30", _hoursForEvents[indexPath.item]];
        timecell.min45.text = [NSString stringWithFormat:@"%@:45", _hoursForEvents[indexPath.item]];
        
        return timecell;
    }
    
}

-(NSMutableArray *)getTimeIntervals:(NSString *)startTime andEndTime:(NSString *)endTime {
    NSMutableArray *hoursArray=[[NSMutableArray alloc]init];
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"HH:mm:ss"];
    NSDate *startString = [dateFormatter1 dateFromString:startTime];
    NSDate *endString = [dateFormatter1 dateFromString:endTime];
    
    NSTimeInterval interval = [endString timeIntervalSinceDate:startString];
    NSInteger t1=(NSInteger)interval;
    NSInteger hours=t1/3600;
    
    for (int i=0;i<=hours; i++)
    {
        NSString *str;
        NSDate *plusOneHour ;
        if(i==0)
            plusOneHour=startString;
        else
            plusOneHour = [startString dateByAddingTimeInterval:60.0f * 60.0f];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:plusOneHour];
        NSInteger hour = [components hour];
        str=hour>=10?@"":@"0";
        NSString *string = [NSString stringWithFormat:@"%@%ld", str,(long)hour];
        startString=plusOneHour;
        [hoursArray addObject:string];
    }
    
    return hoursArray;
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
        
        
        CGSize size = CGSizeMake(_timeView.frame.size.width, 120);
        return size;
        
    }
}

- (double)secondsForTimeString:(NSString *)string {
    
    NSArray *components = [string componentsSeparatedByString:@":"];
    NSInteger hours   = [[components objectAtIndex:0] integerValue];
    NSInteger minutes = [[components objectAtIndex:1] integerValue];
    NSInteger seconds = [[components objectAtIndex:2] integerValue];
    return (hours * 60 * 60) + (minutes * 60) + seconds;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _weekView){
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.item inSection:0];
        WeekViewCell *cell = (WeekViewCell *)[_weekView cellForItemAtIndexPath:path];
     //   TimeViewCell *timecell = (TimeViewCell *)[_timeView cellForItemAtIndexPath:path];
        
        NSDateFormatter *objTitleFormatter = [NSDateFormatter new];
        [objTitleFormatter setDateFormat:@"d MMMM yyyy"];
        [objTitleFormatter setLocale: [NSLocale localeWithLocaleIdentifier: @"ru_RU"]];
        self.title = [objTitleFormatter stringFromDate:cell.currentDay];
        
        [self setEventswithIndexPath:path];
        NSLog(@"selecting");
    
    }
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"deselecting");

    
}

-(void)setEventswithIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.item inSection:0];
    WeekViewCell *cell = (WeekViewCell *)[_weekView cellForItemAtIndexPath:path];
    TimeViewCell *timecell = (TimeViewCell *)[_timeView cellForItemAtIndexPath:path];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd"];
    NSString *dateString = [NSString string];
    
    NSDateFormatter *hourFormatter = [NSDateFormatter new];
    [hourFormatter setDateFormat:@"hh:mm:ss"];
    NSString *hourString = [NSString string];
    
    
    for (EKEvent *i in _eventsToTimeView) {
        
        NSString *eventDateString = [NSString string];
        _sizeOf15min = timecell.timeViewText.frame.size.height;
        dateString = [formatter stringFromDate:cell.currentDay];
        eventDateString = [formatter stringFromDate:i.startDate];
        
        double size = [i.endDate timeIntervalSinceDate:i.startDate];
        hourString = [hourFormatter stringFromDate:i.startDate];
        double hoursize = [self secondsForTimeString: hourString];
//        NSLog(@"%f hoursize is... ", hoursize);
//        NSLog(@"%f", size);
//
  
        UILabel *eventLabel = [UILabel new];
        if (i.isAllDay) {
            [eventLabel setFrame:CGRectMake(60, 0, 200, 30)];
        } else {
            [eventLabel setFrame:CGRectMake(60, hoursize * _sizeOf15min / 900, _timeView.frame.size.width - 65, size * _sizeOf15min / 900)];
        }
        
        if (dateString == eventDateString) {
            eventLabel.text = i.title;
            eventLabel.layer.borderWidth = 0;
            eventLabel.layer.backgroundColor = i.calendar.CGColor;
            eventLabel.clipsToBounds = NO;
            eventLabel.layer.opacity = 0.5;
            eventLabel.layer.cornerRadius = 3;
          
            [_timeView insertSubview:eventLabel atIndex:0];
        }
        
    }
    
}

@end
