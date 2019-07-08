//
//  DashedLine.h
//  WeekCalendar
//
//  Created by Anna Ershova on 7/8/19.
//  Copyright © 2019 Anna Ershova. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface DashedLine : UILabel

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable int dashPaintedSize;
@property (nonatomic) IBInspectable int dashUnpaintedSize;
@property (strong, nonatomic) CAShapeLayer *border;

@end
