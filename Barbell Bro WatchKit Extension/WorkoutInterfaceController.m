//
//  WorkoutInterfaceController.m
//  Barbell Bro
//
//  Created by Kelvin Lee on 4/6/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "WorkoutInterfaceController.h"
#import "CoreDataHelperKit.h"
#import "KLERoutine.h"
#import "KLEExerciseGoal.h"
#import "KLEExercise.h"
#import "KLEExerciseCompleted.h"

@interface WorkoutInterfaceController()

@property (nonatomic, strong) NSNumber *sets;
@property (nonatomic, strong) NSNumber *reps;
@property (nonatomic, strong) NSNumber *weight;

@property (nonatomic, strong) NSNumber *stepValue;

@property (nonatomic, copy) NSMutableArray *repsWeightArray;

@property (nonatomic, strong) KLEExerciseGoal *selectedExercise;

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *setsLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *setsButton;

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *repsLabel;

@property (weak, nonatomic) IBOutlet WKInterfaceButton *addWeightButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *minusWeightButton;

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *weightLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceSlider *weightSlider;

@end


@implementation WorkoutInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    
    [self loadDataInContext:context];
    
    // set initial reps slider value to goal number
    
    
//    [WKInterfaceController openParentApplication:@{@"request": @"refreshData"} reply:^(NSDictionary *replyInfo, NSError *error) {
//        // process reply data
//        NSLog(@"Reply: %@", replyInfo);
//    }];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)loadDataInContext:(id)context {
    
    KLEExerciseGoal *exercise = (KLEExerciseGoal *)context;
    
    if ([exercise respondsToSelector:@selector(sets)]) {
        
        _selectedExercise = exercise;
        _sets = exercise.sets;
        _reps = exercise.reps;
        _weight = exercise.weight;
        
        NSLog(@"exercise goal %@", exercise);
        [_setsButton setTitle:[NSString stringWithFormat:@"Start Set %@!", _sets]];
        [_repsLabel setText:[NSString stringWithFormat:@"Reps: %@", _reps]];
        [_weightLabel setText:[NSString stringWithFormat:@"Weight: %@", _weight]];
        
        [self setTitle:exercise.exercise.exercisename];
        
        
        // setup the weight controls
        _stepValue = [NSNumber numberWithInteger:1];
        [_weightSlider setValue:[_stepValue integerValue]];
        [_addWeightButton setTitle:[NSString stringWithFormat:@"Add %@", _stepValue]];
        [_minusWeightButton setTitle:[NSString stringWithFormat:@"Sub %@", _stepValue]];
    }
}

- (void)finishSet
{
    NSString *repsString = [NSString stringWithFormat:@"%@", _reps];
    NSString *weightString = [NSString stringWithFormat:@" %@", _weight];
    NSString *repsWeightString = [repsString stringByAppendingString:weightString];
    
    if (!_repsWeightArray) {
        _repsWeightArray = [NSMutableArray new];
    }
    [_repsWeightArray addObject:repsWeightString];
    
    NSLog(@"reps weight array %@", _repsWeightArray);
}

- (NSNumber *)getMaxWeight
{
    NSMutableArray *weightsArray = [NSMutableArray new];
    
    for (NSString *repsWeightString in _repsWeightArray) {
        NSNumber *weightNumber = [NSNumber numberWithFloat:[[[repsWeightString componentsSeparatedByString:@" "] lastObject] floatValue]];
        [weightsArray addObject:weightNumber];
    }
    NSNumber *maxWeight = [weightsArray valueForKeyPath:@"@max.self"];
    
    return maxWeight;
}

- (NSDate *)todaysDate
{
    // date from current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDate *todaysDate = [NSDate date];
    // date components with month, day, year, hour and minute
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:todaysDate];
    
    // todays date
    NSDate *todaysDateWithComponents = [calendar dateFromComponents:components];
    
    return todaysDateWithComponents;
}

- (NSString *)weightUnitType
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *unitWeightType = [userDefaults stringForKey:@"unitWeightKey"];
    NSLog(@"unit weight Type %@", unitWeightType);
    
    if ([unitWeightType isEqualToString:@"lb"]) {
        return @"lb";
    }
    return @"kg";
}

- (void)logWorkout
{
    CoreDataAccess *cdh = [CoreDataAccess sharedCoreDataAccess];
    KLEExerciseCompleted *exerciseCompleted = [NSEntityDescription insertNewObjectForEntityForName:@"KLEExerciseCompleted" inManagedObjectContext:cdh.context];
    
    exerciseCompleted.exercise = _selectedExercise.exercise;
    exerciseCompleted.repsweightarray = [NSArray arrayWithArray:_repsWeightArray];
    exerciseCompleted.setscompleted = _selectedExercise.sets;
    exerciseCompleted.maxweight = [self getMaxWeight];
    exerciseCompleted.routinename = _selectedExercise.routine.routinename;
    exerciseCompleted.datecompleted = [self todaysDate];
    exerciseCompleted.weightunit = [self weightUnitType];
    NSLog(@"reps weight array %@", exerciseCompleted.repsweightarray);
    NSLog(@"Exercise completed %@", exerciseCompleted);
    
    [cdh saveContext];
}

- (IBAction)setsButtonAction {
    
    if ([_sets integerValue] == 0) {
        
        [self logWorkout];
        
        // pop view
        [self popController];
        
    } else {
        
        _sets = @([_sets integerValue] - 1);
        
        [self finishSet];
        
        if ([_sets integerValue] == 0) {
            
            [_setsButton setTitle:@"Log Workout!"];
        } else {
            
            [_setsButton setTitle:[NSString stringWithFormat:@"%@", _sets]];
        }
        
        NSLog(@"Log workout SET: %@", _sets);
    }
}

- (IBAction)minusRepsButton {
    
    if ([_reps integerValue] == 1) {
        return;
    } else {
        _reps = @([_reps integerValue] - 1);
        [_repsLabel setText:[NSString stringWithFormat:@"Reps: %@", _reps]];
    }
}

- (IBAction)plusRepsButton {
    
    if ([_reps integerValue] > 100) {
        return;
    } else {
        _reps = @([_reps integerValue] + 1);
        [_repsLabel setText:[NSString stringWithFormat:@"Reps: %@", _reps]];
    }
    
}

- (IBAction)addWeightButtonAction {
    
    if ([_weight floatValue] > 1000) {
        return;
    }
    _weight = @([_weight floatValue] + [_stepValue integerValue]);
    [_weightLabel setText:[NSString stringWithFormat:@"Weight: %@", _weight]];
}

- (IBAction)minusWeightButtonAction {
    
    if ([_weight floatValue] >= [_stepValue integerValue]) {
        
        _weight = @([_weight floatValue] - [_stepValue integerValue]);
        [_weightLabel setText:[NSString stringWithFormat:@"Weight: %@", _weight]];
    }
    
}

- (IBAction)weightSliderAction:(float)value {
    
    _stepValue = [NSNumber numberWithFloat:value];
    
    [_addWeightButton setTitle:[NSString stringWithFormat:@"Add %lu", [_stepValue integerValue]]];
    [_minusWeightButton setTitle:[NSString stringWithFormat:@"Sub %lu", [_stepValue integerValue]]];
}

@end



