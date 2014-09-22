//
//  KLEExercises.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/12/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEExercises.h"

@implementation KLEExercises

- (NSMutableArray *)exerciseList
{
    KLEExercises *yourExercise = [[KLEExercises alloc] initWithName:@"Your Exercise" ofType:@"Custom"];
    KLEExercises *benchPress = [[KLEExercises alloc] initWithName:@"Bench Press" ofType:@"Chest"];
    KLEExercises *squats = [[KLEExercises alloc] initWithName:@"Squats" ofType:@"Legs"];
    KLEExercises *armCurls = [[KLEExercises alloc] initWithName:@"Arm Curls" ofType:@"Arms"];
    
    _exerciseList = [NSMutableArray arrayWithObjects:@[
                                                       @[yourExercise.exerciseName, yourExercise.exerciseType],
                                                       @[benchPress.exerciseName, benchPress.exerciseType],
                                                       @[squats.exerciseName, squats.exerciseType],
                                                       @[armCurls.exerciseName, armCurls.exerciseType]
                                                       ], nil];
    NSLog(@"%@", _exerciseList);
    
    return _exerciseList;
}

- (instancetype)init
{
    return [self initWithName:@"Name"];
}

- (instancetype)initWithName:(NSString *)name
{
    return [self initWithName:name ofType:@"Type"];
}

- (instancetype)initWithName:(NSString *)name ofType:(NSString *)type
{
    self = [super init];
    
    if (self) {
        _exerciseName = name;
        _exerciseType = type;
    }
    return self;
}

@end
