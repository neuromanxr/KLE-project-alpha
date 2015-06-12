//
//  KLEWorkoutButtonDelegate.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/14/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KLEWorkoutButtonDelegate <NSObject>
@optional

- (void)resetAngle:(CGFloat)angle;

- (BOOL)isWorkoutInProgress;

- (void)currentSet:(CGFloat)set;

- (void)logCurrentSetsRepsWeight;

@end
