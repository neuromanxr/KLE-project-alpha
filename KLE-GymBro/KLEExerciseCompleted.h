//
//  KLEExerciseCompleted.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/25/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface KLEExerciseCompleted : NSManagedObject

@property (nonatomic, retain) NSString * routinename;
@property (nonatomic, retain) NSString * exercisename;
@property (nonatomic, retain) NSNumber * timecompleted;
@property (nonatomic, retain) NSDate * datecompleted;
@property (nonatomic, retain) NSNumber * setscompleted;
@property (nonatomic, retain) id repsweightarray;

@end

@interface RepsWeightArray : NSValueTransformer

@end
