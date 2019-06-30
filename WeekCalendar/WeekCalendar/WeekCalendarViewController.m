//
//  WeekCalendarViewController.m
//  WeekCalendar
//
//  Created by Anna Ershova on 6/29/19.
//  Copyright © 2019 Anna Ershova. All rights reserved.
//
#import <EventKit/EventKit.h>
#import "WeekCalendarViewController.h"
#import "WeekViewCell.h"
#import "UIColor+CustomColor.h" 

@interface WeekCalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation WeekCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *weekNib = [UINib nibWithNibName:@"WeekViewCell" bundle:nil];
    [self.weekView registerNib:weekNib forCellWithReuseIdentifier:@"WeekViewCellReuseId"];
    self.weekView.delegate = self;
    self.weekView.dataSource = self;
    [self setHeader];
    [self setWeekView];
    
    
    _rusDayNames = @[@"ПН", @"ВТ", @"СР", @"ЧТ", @"ПТ", @"СБ", @"ВС"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSDate*)dateByAddingDays:(NSInteger)days toDate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setFirstWeekday:2];
    NSDateComponents *components = [NSDateComponents new];
    components.day = days;
    return [calendar dateByAddingComponents: components toDate: date options: 0];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WeekViewCell *weekcell = (WeekViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"WeekViewCellReuseId" forIndexPath:indexPath];

    NSDate *date = [NSDate new];
    date = [self dateByAddingDays:indexPath.row toDate: weekcell.currentDay];
    
    NSDateFormatter *objDateFormatter = [NSDateFormatter new];
    [objDateFormatter setDateFormat:@"dd"];
    weekcell.date.text = [objDateFormatter stringFromDate:date];
    
    NSDateFormatter *objDateNameFormatter = [NSDateFormatter new];
    [objDateNameFormatter setDateFormat:@"EE"];
    weekcell.day.text = [objDateNameFormatter stringFromDate:date];
   

    return weekcell;
}



- (void)setHeader{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0X037594"];
    NSDateFormatter *objDateFormatter = [NSDateFormatter new];
    [objDateFormatter setDateFormat:@"dd MMMM yyyy"];
    self.title = [objDateFormatter stringFromDate:[NSDate date]];
 
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
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 7.0;
    CGSize size = CGSizeMake(cellWidth, _weekView.frame.size.height);
    return size;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(CGRectGetWidth(self.weekView.frame) / 6, CGRectGetHeight(self.weekView.frame));
//}

@end
