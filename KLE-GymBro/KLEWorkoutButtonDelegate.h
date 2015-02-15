//
//  KLEWorkoutButtonDelegate.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/14/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KLEWorkoutButtonDelegate <NSObject>
@required

- (void)resetAngle:(float)angle;

@end
