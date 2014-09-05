//
//  KLEMainView.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/1/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEMainView.h"

@implementation KLEMainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    CGPoint points = CGPointMake([UIScreen mainScreen].bounds.size.width / 2 - 100, [UIScreen mainScreen].bounds.size.height / 2 - 100);
    NSLog(@"%f, %f", points.x, points.y);

    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(points.x, points.y, 200, 200);
    }
    return self;
}

@end
