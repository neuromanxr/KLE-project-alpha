//
//  KLEHistoryViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 1/27/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEUtility.h"
#import "DateTools.h"
#import "KLEExercise.h"
#import "KLERoutine.h"
#import "KLEExerciseCompleted.h"
#import "KLEHistoryTableViewCell.h"
#import "CoreDataHelper.h"
#import "KLEAppDelegate.h"
#import "KLEHistoryViewController.h"
#import "KLEGraphViewController.h"

#define kDateCompleted [NSString stringWithString:@"datecompleted"];
#define kRoutineName [NSString stringWithString:@"routinename"];
#define kExerciseName [NSString stringWithString:@"exercisename"];

@interface KLEHistoryViewController ()

@property (nonatomic, assign) KLEDateRangeMode currentDateRangeMode;

@end

@implementation KLEHistoryViewController

- (void)configureFetch:(KLEDateRangeMode)dateRange
{
    
    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:firstRecordDate];
//    components.month -= 3;
//    NSDate *threeMonthsBeforeToday = [calendar dateFromComponents:components];
//    
//    NSDate *twoWeeksAfterFirst = [calendar dateByAddingUnit:NSCalendarUnitWeekOfMonth value:2 toDate:firstRecordDate options:kNilOptions];
//    NSDate *twoWeeksAfterFirstUsingTools = [firstRecordDate dateByAddingWeeks:2];
//    
//    NSLog(@"TWO WEEKS DATE: %@ DATE TOOLS: %@", twoWeeksAfterFirst, twoWeeksAfterFirstUsingTools);
//    NSLog(@"THREE MONTHS AGO DATE TOOLS: %@", threeMonthsBeforeToday);
    
    NSLog(@"DATE RANGE MODE %lu", dateRange);
    
    NSDate *dateToCompare = [self setDateToCompare:dateRange];
    
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KLEExerciseCompleted"];
    NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"datecompleted" ascending:NO];
    request.sortDescriptors = @[sortByDate];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"datecompleted >= %@", dateToCompare];
    [request setPredicate:predicate];
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:@"shortDateCompleted" cacheName:nil];
    self.frc.delegate = self;
    
}

- (NSDate *)fetchFirstRecordDate
{
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KLEExerciseCompleted"];
    NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"datecompleted" ascending:YES];
    request.sortDescriptors = @[sortByDate];
    request.fetchLimit = 1;
    
    NSError *error = nil;
    NSArray *requestArray = [cdh.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Unable to perform fetch %@, %@", error, error.localizedDescription);
    }
    KLEExerciseCompleted *firstRecord = [requestArray firstObject];
    NSLog(@"FIRST RECORD REQUEST %@ : %@ : %@", firstRecord.datecompleted, firstRecord.exercisename, firstRecord.maxweight);
    
    return firstRecord.datecompleted;
}

- (NSArray *)exerciseArray
{
    NSMutableOrderedSet *exercises = [NSMutableOrderedSet new];
    
    for (KLEExerciseCompleted *exerciseCompleted in [self.frc fetchedObjects]) {
        [exercises addObject:exerciseCompleted.exercisename];
    }
    
    NSArray *exerciseHistoryArray = [[NSOrderedSet orderedSetWithOrderedSet:exercises] array];
    
    NSLog(@"HISTORY EXERCISES %@", exerciseHistoryArray);
    
    return exerciseHistoryArray;
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        // title for hvc
        navItem.title = @"History";
        
        // button to add exercises
        UIBarButtonItem *dateRangeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(changeDateRange)];
        
        UIBarButtonItem *graphViewButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showGraphView)];
        
        // set the button to be the left nav button of the nav item
        navItem.leftBarButtonItem = dateRangeButton;
        
        navItem.rightBarButtonItem = graphViewButton;
        
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)showGraphView
{
    KLEGraphViewController *graphViewController = [KLEGraphViewController new];
    graphViewController.dateRangeMode = _currentDateRangeMode;
    graphViewController.exercisesFromHistory = [self exerciseArray];
    [self.navigationController pushViewController:graphViewController animated:YES];
}

- (NSDate *)setDateToCompare:(KLEDateRangeMode)dateRange
{
    NSDate *firstRecordDate;
    NSDate *todaysDate;
    
    if (dateRange == KLEDateRangeModeAll) {
        firstRecordDate = [self fetchFirstRecordDate];
    }
    else
    {
        todaysDate = [self todaysDate];
    }
    
    NSDate *dateToCompare;
    
    switch (dateRange) {
        case KLEDateRangeModeThreeMonths:
            dateToCompare = [todaysDate dateBySubtractingMonths:3];
            NSLog(@"THREE MONTHS AGO USING DATE TOOLS: %@", dateToCompare);
            break;
        case KLEDateRangeModeSixMonths:
            dateToCompare = [todaysDate dateBySubtractingMonths:6];
            NSLog(@"SIX MONTHS AGO USING DATE TOOLS: %@", dateToCompare);
            break;
        case KLEDateRangeModeNineMonths:
            dateToCompare = [todaysDate dateBySubtractingMonths:9];
            NSLog(@"NINE MONTHS AGO USING DATE TOOLS: %@", dateToCompare);
            break;
        case KLEDateRangeModeOneYear:
            dateToCompare = [todaysDate dateBySubtractingYears:1];
            NSLog(@"ONE YEAR AGO USING DATE TOOLS: %@", dateToCompare);
            break;
        case KLEDateRangeModeAll:
            dateToCompare = firstRecordDate;
            NSLog(@"ALL DATES");
            break;
        default:
            break;
    }
    return dateToCompare;
}

- (void)changeDateRange
{
    NSLog(@"Change Date Range");
    
    UIAlertController *dateRangeActionSheet = [UIAlertController alertControllerWithTitle:@"Date Range" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *setRangeToThreeMonths = [UIAlertAction actionWithTitle:@"3 Months" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"SET TO 3 MONTHS");
        _currentDateRangeMode = KLEDateRangeModeThreeMonths;
        [self configureFetch:KLEDateRangeModeThreeMonths];
        [self performFetch];
    }];
    UIAlertAction *setRangeToSixMonths = [UIAlertAction actionWithTitle:@"6 Months" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"SET TO 6 MONTHS");
        _currentDateRangeMode = KLEDateRangeModeSixMonths;
        [self configureFetch:KLEDateRangeModeSixMonths];
        [self performFetch];
    }];
    UIAlertAction *setRangeToNineMonths = [UIAlertAction actionWithTitle:@"9 Months" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"SET TO 9 MONTHS");
        _currentDateRangeMode = KLEDateRangeModeNineMonths;
        [self configureFetch:KLEDateRangeModeNineMonths];
        [self performFetch];
    }];
    UIAlertAction *setRangeToOneYear = [UIAlertAction actionWithTitle:@"1 Year" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"SET TO 1 YEAR");
        _currentDateRangeMode = KLEDateRangeModeOneYear;
        [self configureFetch:KLEDateRangeModeOneYear];
        [self performFetch];
    }];
    UIAlertAction *setRangeToAll = [UIAlertAction actionWithTitle:@"All" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"SET TO ALL");
        _currentDateRangeMode = KLEDateRangeModeAll;
        [self configureFetch:KLEDateRangeModeAll];
        [self performFetch];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"SET TO CANCEL");
    }];
    
    [dateRangeActionSheet addAction:setRangeToThreeMonths];
    [dateRangeActionSheet addAction:setRangeToSixMonths];
    [dateRangeActionSheet addAction:setRangeToNineMonths];
    [dateRangeActionSheet addAction:setRangeToOneYear];
    [dateRangeActionSheet addAction:setRangeToAll];
    [dateRangeActionSheet addAction:cancelAction];
    
    [self presentViewController:dateRangeActionSheet animated:YES completion:nil];
}

- (NSDate *)todaysDate
{
    // date from current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSLog(@" ## TIMEZONE %@", [calendar timeZone]);
    NSDate *todaysDate = [NSDate date];
    // date components with month, day, year, hour and minute
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:todaysDate];
    
    // todays date
    NSDate *todaysDateWithComponents = [calendar dateFromComponents:components];
    
    // date format and time zone for string
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeZone = [NSTimeZone localTimeZone];
    [formatter setDateFormat:@"MM-dd-yy HH:mm"];
    
    NSLog(@"## TODAY'S DATE %@", [formatter stringFromDate:todaysDateWithComponents]);
    
    return todaysDateWithComponents;
}

- (NSString *)dateCompleted:(NSDate *)dateCompleted
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    NSString *dateCompletedText = [dateFormat stringFromDate:dateCompleted];
    NSLog(@"TODAYS DATE %@", dateCompleted);
    
    return dateCompletedText;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // create an instance of UITableViewCell, with default appearance
    KLEHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLEHistoryTableViewCell" forIndexPath:indexPath];
    
    KLEExerciseCompleted *exerciseCompleted = [self.frc objectAtIndexPath:indexPath];
    
    NSLog(@"REPS WEIGHT ARRAY in HISTORY %@", exerciseCompleted.repsweightarray);
    
    cell.repsWeightCompleted = [exerciseCompleted.repsweightarray count] - 1;
    cell.setsCompleted = [exerciseCompleted.setscompleted integerValue];
    
    NSLog(@"CELL TAG IN CELL FOR ROW %lu", cell.tag);
    
    cell.setsLabel.text = [NSString stringWithFormat:@"%lu", [exerciseCompleted.setscompleted integerValue]];
    cell.repsWeightLabel.text = [exerciseCompleted.repsweightarray firstObject];
    cell.routineName.text = exerciseCompleted.routinename;
    cell.exerciseLabel.text = exerciseCompleted.exercisename;
    cell.dateCompleted.text = [self dateCompleted:exerciseCompleted.datecompleted];
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.frc sections] objectAtIndex:section];
    
    return [sectionInfo name];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Cell selected");
    
    KLEHistoryTableViewCell * cell = (KLEHistoryTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    KLEExerciseCompleted *exerciseCompleted = [self.frc objectAtIndexPath:indexPath];
    NSArray *repsWeightArray = exerciseCompleted.repsweightarray;
    
    if (cell.repsWeightCompleted != 0) {
        
        NSLog(@"SETS REPS LABEL %@", cell.repsWeightLabel.text);
        cell.repsWeightCompleted--;
        cell.setsCompleted--;
    }
    else
    {
        NSLog(@"cell tag at ZERO");
        cell.repsWeightCompleted = [repsWeightArray count] - 1;
        cell.setsCompleted = [exerciseCompleted.setscompleted integerValue];
    }
    
    cell.repsWeightLabel.text = repsWeightArray[cell.repsWeightCompleted];
    cell.setsLabel.text = [NSString stringWithFormat:@"%lu", cell.setsCompleted];
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if the table view is asking to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        KLEExerciseCompleted *deleteTarget = [self.frc objectAtIndexPath:indexPath];
        [self.frc.managedObjectContext deleteObject:deleteTarget];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // alert the user about deletion
        UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Delete routine" message:@"This will also delete the routine in Daily" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [deleteAlert show];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureFetch:KLEDateRangeModeThreeMonths];
    [self performFetch];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:@"SomethingChanged" object:nil];
    
    // load the nib file
    UINib *nib = [UINib nibWithNibName:@"KLEHistoryTableViewCell" bundle:nil];
    
    // register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KLEHistoryTableViewCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
