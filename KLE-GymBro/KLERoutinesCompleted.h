//
//  KLERoutinesCompleted.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/11/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KLERoutineCompleted;

@interface KLERoutinesCompleted : NSManagedObject

@property (nonatomic, retain) NSNumber * completedcount;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *routinecompleted;
@end

@interface KLERoutinesCompleted (CoreDataGeneratedAccessors)

- (void)addRoutinecompletedObject:(KLERoutineCompleted *)value;
- (void)removeRoutinecompletedObject:(KLERoutineCompleted *)value;
- (void)addRoutinecompleted:(NSSet *)values;
- (void)removeRoutinecompleted:(NSSet *)values;

@end
