//
//  KLEExerciseCompleted.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/25/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEExerciseCompleted.h"


@implementation KLEExerciseCompleted

@dynamic routinename;
@dynamic exercisename;
@dynamic timecompleted;
@dynamic datecompleted;
@dynamic setscompleted;
@dynamic repsweightarray;

@end

@implementation RepsWeightArray

+ (Class)transformedValueClass
{
    return [NSArray class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end
