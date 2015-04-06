//
//  InterfaceController.m
//  Barbell Bro WatchKit Extension
//
//  Created by Kelvin Lee on 4/5/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//
#import "DailyRoutineRow.h"
#import "InterfaceController.h"
#import "CoreDataHelperKit.h"
#import "KLERoutine.h"

@interface InterfaceController()

@property (nonatomic, copy) NSArray *routinesArray;

@property (weak, nonatomic) IBOutlet WKInterfaceTable *dailyTable;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    _routinesArray = [self requestObjects];
    
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
    
    [_dailyTable setNumberOfRows:[_routinesArray count] withRowType:@"DailyRoutineRow"];
    
    [_routinesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        KLERoutine *routine = (KLERoutine *)obj;
        NSLog(@"Routine %@", routine);
        if ([[_dailyTable rowControllerAtIndex:idx] isKindOfClass:[DailyRoutineRow class]]) {
            DailyRoutineRow *row = [_dailyTable rowControllerAtIndex:idx];
            NSLog(@"DAILY ROW %@", row);
            [row.routineButton setTitle:routine.routinename];
            [row.dayLabel setText:routine.dayname];
        }
    }];
    
}

- (NSArray *)requestObjects
{
    CoreDataAccess *cdh = [CoreDataAccess sharedCoreDataAccess];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KLERoutine"];
    // fetch the routines with daynumbers that match the section and bool value is set to yes
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"inworkout == %@", @(YES)];
    [request setPredicate:predicate];
    //    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"routinename" ascending:YES], nil];
    NSArray *requestObjects = [cdh.context executeFetchRequest:request error:nil];
    NSLog(@"WATCH REQ OBJS %@", requestObjects);
    KLERoutine *routine = [requestObjects firstObject];
    NSLog(@"Routine %@", routine);
    
    return requestObjects;
}


@end



