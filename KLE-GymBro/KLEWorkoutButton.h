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

@interface KLEWorkoutButton : UIControl <KLEWorkoutButtonDelegate>

@property (strong, nonatomic) UIButton *setsButton;

@property (nonatomic) NSNumber *setsForAngle;

@property (nonatomic, weak) id<KLEWorkoutButtonDelegate> delegate;

@end
