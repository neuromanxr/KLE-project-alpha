//
//  KLEWorkoutButtonDelegate.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/14/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>

// daily view controller
@protocol KLEWorkoutButtonDelegate <NSObject>
@optional

- (void)resetAngle:(float)angle;

- (BOOL)isWorkoutInProgress;

- (void)currentSet:(float)set;

@end
