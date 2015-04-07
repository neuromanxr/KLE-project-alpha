//
//  ExercisesInterfaceController.m
//  Barbell Bro
//
//  Created by Kelvin Lee on 4/6/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//
#import "ExerciseRow.h"
#import "ExercisesInterfaceController.h"
#import "CoreDataHelperKit.h"
#import "KLERoutine.h"
#import "KLEExerciseGoal.h"
#import "KLEExercise.h"

@interface ExercisesInterfaceController()

@property (nonatomic, copy) NSArray *exercisesArray;

@property (weak, nonatomic) IBOutlet WKInterfaceTable *exercisesTable;

@end


@implementation ExercisesInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    KLERoutine *routine = (KLERoutine *)context;
    if ([routine isKindOfClass:[KLERoutine class]]) {
        NSLog(@"routine in exercises interface controller %@", routine);
        _exercisesArray = [routine.exercisegoal allObjects];
    }
    
    [self reloadTable];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)reloadTable {
    
    [_exercisesTable setNumberOfRows:[_exercisesArray count] withRowType:@"ExerciseRow"];
    
    [_exercisesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        KLEExerciseGoal *exercise = (KLEExerciseGoal *)obj;
        NSLog(@"Exercise %@", exercise);
        if ([[_exercisesTable rowControllerAtIndex:idx] isKindOfClass:[ExerciseRow class]]) {
            ExerciseRow *row = [_exercisesTable rowControllerAtIndex:idx];
            NSLog(@"DAILY ROW %@", row);
            [row.exerciseButton setTitle:exercise.exercise.exercisename];
        }
    }];
    
}

@end



