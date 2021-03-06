//
//  KLEExerciseCompleted.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/25/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEExerciseCompleted.h"
#import "KLEExercise.h"

@implementation KLEExerciseCompleted

@dynamic exercise;
@dynamic routinename;
@dynamic weightunit;
@dynamic timecompleted;
@dynamic resttime;
@dynamic datecompleted;
@dynamic setscompleted;
@dynamic maxweight;
@dynamic calories;
@dynamic heartrate;
@dynamic repsweightarray;

@end

@implementation KLEExerciseCompleted (AdditionalMethods)

- (NSString *)shortDateCompleted
{
    NSDate *dateCompleted = self.datecompleted;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear) fromDate:dateCompleted];
    
    NSDate *dateCompletedWithComponents = [calendar dateFromComponents:components];
    NSDateFormatter *formatter = [NSDateFormatter new];
//    [formatter setDateFormat:@"MM-dd-yy"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSLog(@" ** DATE COMPLETED SECTION %@", [formatter stringFromDate:dateCompletedWithComponents]);
    
    return [formatter stringFromDate:dateCompletedWithComponents];
    
}

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