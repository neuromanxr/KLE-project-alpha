//
//  KLEWorkoutButton.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 1/25/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//
#import "KLEWorkoutButtonDelegate.h"
#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface KLEWorkoutButton : UIButton <KLEWorkoutButtonDelegate>

@property (nonatomic) NSNumber *setsForAngle;

@end
