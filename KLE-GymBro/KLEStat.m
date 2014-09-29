//
//  KLEStat.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/3/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEStat.h"
#import "KLEExercises.h"

@implementation KLEStat

//@dynamic exercise;
//@dynamic date;
//@dynamic sets;
//@dynamic reps;
//@dynamic weight;

- (instancetype)initWithExercise:(NSString *)exerciseName
                    numberOfSets:(int)setsNumber
                    numberOfReps:(int)repsNumber
                      withWeight:(float)weightNumber
{
    self = [super init];
    
    if (self) {
        _exercise = exerciseName;
        _sets = setsNumber;
        _reps = repsNumber;
        _weight = weightNumber;
    }
    return self;
}

- (instancetype)init
{
    self.exerciseObject = [[KLEExercises alloc] init];
    
    return [self initWithExercise:self.exerciseObject.exerciseList[0][0][0] numberOfSets:3 numberOfReps:10 withWeight:10.0];
}

@end
