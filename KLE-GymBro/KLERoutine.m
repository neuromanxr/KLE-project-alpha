//
//  KLERoutine.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/16/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLERoutine.h"
#import "KLEExerciseGoal.h"
#import "KLERoutines.h"


@implementation KLERoutine

@dynamic routinename;
@dynamic exercisecount;
@dynamic day;
@dynamic exercisegoal;
@dynamic routines;

- (void)addExerciseGoal:(KLEExerciseGoal *)exerciseGoal
{
    if ([self.exercisegoal containsObject:exerciseGoal]) {
        return;
    }
    [[self mutableOrderedSetValueForKey:@"exercisegoal"] addObject:exerciseGoal];
}

@end
