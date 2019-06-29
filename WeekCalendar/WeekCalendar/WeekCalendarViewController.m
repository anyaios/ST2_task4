//
//  WeekCalendarViewController.m
//  WeekCalendar
//
//  Created by Anna Ershova on 6/29/19.
//  Copyright © 2019 Anna Ershova. All rights reserved.
//

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
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WeekViewCell *weekcell = (WeekViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"WeekViewCellReuseId" forIndexPath:indexPath];
    return weekcell;
}

- (void)setHeader{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0X037594"];
    self.title = @"15 June 2019";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xFFFFFF"],
       NSFontAttributeName:[UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold]}];
}

@end
