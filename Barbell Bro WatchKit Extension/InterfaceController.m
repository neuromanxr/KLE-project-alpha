//
//  InterfaceController.m
//  Barbell Bro WatchKit Extension
//
//  Created by Kelvin Lee on 4/5/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//
#import "DailyRoutineRow.h"
#import "InterfaceController.h"
#import "KLEWorkoutExerciseViewController.h"

@interface InterfaceController()

@property (nonatomic, copy) NSArray *routinesArray;

@property (weak, nonatomic) IBOutlet WKInterfaceTable *dailyTable;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    _routinesArray = @[@"One", @"Two", @"Three"];
    [self reloadTable];
    
    [WKInterfaceController openParentApplication:@{@"request": @"refreshData"} reply:^(NSDictionary *replyInfo, NSError *error) {
        // process reply data
        NSLog(@"Reply: %@", replyInfo);
    }];
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
    
    [_dailyTable setNumberOfRows:3 withRowType:@"DailyRoutineRow"];
    
    [_routinesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([[_dailyTable rowControllerAtIndex:idx] isKindOfClass:[DailyRoutineRow class]]) {
            DailyRoutineRow *row = [_dailyTable rowControllerAtIndex:idx];
            NSLog(@"DAILY ROW %@", row);
            [row.routineButton setTitle:@"Routine Name"];
            [row.dayLabel setText:@"Mon"];
        }
    }];
    
    
}


@end



