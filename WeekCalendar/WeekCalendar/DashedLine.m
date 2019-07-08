//
//  DashedLine.m
//  WeekCalendar
//
//  Created by Anna Ershova on 7/8/19.
//  Copyright © 2019 Anna Ershova. All rights reserved.
//

#import "DashedLine.h"

@implementation DashedLine 


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    _border = [CAShapeLayer layer];
    [self.layer addSublayer:_border];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.cornerRadius;
    
    _border.strokeColor = self.borderColor.CGColor;
    _border.fillColor = nil;
    _border.lineDashPattern = @[[NSNumber numberWithInt:_dashPaintedSize],
                                [NSNumber numberWithInt:_dashUnpaintedSize]];
    _border.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius].CGPath;
    _border.frame = self.bounds;
    
}

@end
