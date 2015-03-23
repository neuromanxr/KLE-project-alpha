//
//  KLEGraphViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/25/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEUtility.h"
#import "DateTools.h"
#import "KLEExerciseCompleted.h"
#import "KLEAppDelegate.h"
#import "KLEGraphViewController.h"

@interface KLEGraphViewController () <NSFetchedResultsControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailStreamLabel;

@property (strong, nonatomic) IBOutlet UIPickerView *exerciseCompletedPicker;
@property (nonatomic, assign) NSUInteger currentIndexInPicker;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, copy) NSMutableArray *dateCompletedArray;
@property (nonatomic, copy) NSMutableArray *maxWeightArray;
@property (nonatomic, copy) NSMutableArray *exerciseNameArray;
@property (nonatomic, copy) NSMutableArray *routineNameArray;

@end

@implementation KLEGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_exerciseCompletedPicker setDelegate:self];
    [_exerciseCompletedPicker setDataSource:self];
    
    if ([_exercisesFromHistory count] == 0)
    {
        NSLog(@"NO EXERCISES IN HISTORY");
    }
    else
    {
        [self pickerView:_exerciseCompletedPicker didSelectRow:0 inComponent:0];
        
        [self configureFetchGraphData:_dateRangeMode withExercise:[_exercisesFromHistory objectAtIndex:_currentIndexInPicker]];
    }
    
    [self configureGraphView];
    
    UINavigationItem *navItem = self.navigationItem;
    
    // custom title for navigation title
    NSAttributedString *attribString = [[NSAttributedString alloc] initWithString:@"Graph" attributes:@{ NSFontAttributeName : [KLEUtility getFontFromFontFamilyWithSize:18.0], NSUnderlineStyleAttributeName : @0, NSBackgroundColorAttributeName : [UIColor clearColor] }];
    // custom title for navigation title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.numberOfLines = 0;
    title.attributedText = attribString;
    [title sizeToFit];
    [navItem setTitleView:title];
    
    // button to add exercises
    UIBarButtonItem *dateRangeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(changeDateRange)];
    
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissGraphView)];
    
    // set the button to be the left nav button of the nav item
    navItem.leftBarButtonItem = dateRangeButton;
    
    navItem.rightBarButtonItem = dismissButton;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"** VIEW DID APPEAR");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // dismiss graph view when different tab selected
//    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissGraphView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark FETCH DATA
- (void)configureFetchGraphData:(KLEDateRangeMode)dateRange withExercise:(NSString *)exercise
{
    NSLog(@"DATE RANGE MODE %lu", dateRange);
    NSLog(@"EXERCISE PARAMETER %@", exercise);
    
    NSDate *dateToCompare = [self setDateToCompare:dateRange];
    
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"KLEExerciseCompleted"];
    NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"datecompleted" ascending:NO];
    NSSortDescriptor *sortByExercise = [NSSortDescriptor sortDescriptorWithKey:@"exercisename" ascending:NO];
    fetchRequest.sortDescriptors = @[sortByExercise, sortByDate];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:cdh.context sectionNameKeyPath:nil cacheName:nil];
    [_fetchedResultsController setDelegate:self];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"datecompleted >= %@ AND exercisename == %@", dateToCompare, exercise];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    [_fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"Unable to perform fetch %@, %@", error, error.localizedDescription);
    }
    
    NSLog(@"FETCHED RESULTS %@", [[_fetchedResultsController fetchedObjects] componentsJoinedByString:@"-"]);
    
//    for (id<NSFetchedResultsSectionInfo> sectionInfo in [self.fetchedResultsController sections]) {
//        NSLog(@" SECTION %@", [sectionInfo name]);
//    }
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

#pragma mark SET DATES

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
        case KLEDateRangeModeThreeWeeks:
            dateToCompare = [todaysDate dateBySubtractingWeeks:3];
            NSLog(@"THREE WEEKS AGO USING DATE TOOLS: %@", dateToCompare);
            break;
        case KLEDateRangeModeThreeMonths:
            dateToCompare = [todaysDate dateBySubtractingMonths:3];
            NSLog(@"THREE MONTHS AGO USING DATE TOOLS: %@", dateToCompare);
            break;
        case KLEDateRangeModeSixMonths:
            dateToCompare = [todaysDate dateBySubtractingMonths:6];
            NSLog(@"SIX MONTHS AGO USING DATE TOOLS: %@", dateToCompare);
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

- (void)changeDateRange
{
    NSLog(@"Change Date Range");
    
    UIAlertController *dateRangeActionSheet = [UIAlertController alertControllerWithTitle:@"Date Range" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [dateRangeActionSheet.view setTintColor:[UIColor orangeColor]];
    
    UIAlertAction *setRangeToThreeWeeks = [UIAlertAction actionWithTitle:@"3 Weeks" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"SET TO 3 WEEKS");
        [self configureFetchGraphData:KLEDateRangeModeThreeWeeks withExercise:[_exercisesFromHistory objectAtIndex:_currentIndexInPicker]];
        [self reloadGraph];
        
    }];
    UIAlertAction *setRangeToThreeMonths = [UIAlertAction actionWithTitle:@"3 Months" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"SET TO 3 MONTHS");
        [self configureFetchGraphData:KLEDateRangeModeThreeMonths withExercise:[_exercisesFromHistory objectAtIndex:_currentIndexInPicker]];
        [self reloadGraph];
    }];
    UIAlertAction *setRangeToSixMonths = [UIAlertAction actionWithTitle:@"6 Months" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"SET TO 6 MONTHS");
        [self configureFetchGraphData:KLEDateRangeModeSixMonths withExercise:[_exercisesFromHistory objectAtIndex:_currentIndexInPicker]];
        [self reloadGraph];
    }];
    UIAlertAction *setRangeToOneYear = [UIAlertAction actionWithTitle:@"1 Year" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"SET TO 1 YEAR");
        [self configureFetchGraphData:KLEDateRangeModeOneYear withExercise:[_exercisesFromHistory objectAtIndex:_currentIndexInPicker]];
        [self reloadGraph];
    }];
    UIAlertAction *setRangeToAll = [UIAlertAction actionWithTitle:@"All" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"SET TO ALL");
        [self configureFetchGraphData:KLEDateRangeModeAll withExercise:[_exercisesFromHistory objectAtIndex:_currentIndexInPicker]];
        [self reloadGraph];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"SET TO CANCEL");
    }];
    
    [dateRangeActionSheet addAction:setRangeToThreeWeeks];
    [dateRangeActionSheet addAction:setRangeToThreeMonths];
    [dateRangeActionSheet addAction:setRangeToSixMonths];
    [dateRangeActionSheet addAction:setRangeToOneYear];
    [dateRangeActionSheet addAction:setRangeToAll];
    [dateRangeActionSheet addAction:cancelAction];
    
    [self presentViewController:dateRangeActionSheet animated:YES completion:nil];
}

#pragma mark GRAPHING

- (void)configureGraphView
{
    _graphView.dataSource = self;
    _graphView.delegate = self;
    _graphView.widthLine = 3.0;
    _graphView.widthTouchInputLine = 5.0;
    _graphView.alwaysDisplayDots = NO;
    _graphView.alwaysDisplayPopUpLabels = NO;
    _graphView.enableReferenceAxisFrame = YES;
    _graphView.enableReferenceXAxisLines = YES;
    _graphView.enableReferenceYAxisLines = YES;
    _graphView.enableTouchReport = YES;
    _graphView.enablePopUpReport = YES;
    _graphView.enableXAxisLabel = NO;
    _graphView.enableYAxisLabel = YES;
    _graphView.autoScaleYAxis = YES;
    
    // colors
    _graphView.colorTop = [UIColor kGraphPrimaryColor];
    _graphView.colorBottom = [UIColor kGraphSecondaryColor];
    _graphView.colorLine = [UIColor kGraphPrimaryLineColor];
    _graphView.colorReferenceLines = [UIColor kGraphPrimaryLineColor];
    _graphView.colorPoint = [UIColor kGraphTouchLineColor];
    _graphView.colorTouchInputLine = [UIColor kGraphTouchLineColor];
    _graphView.colorBackgroundXaxis = [UIColor kGraphPrimaryColor];
    _graphView.colorBackgroundYaxis = [UIColor kGraphPrimaryColor];
    _graphView.colorXaxisLabel = [UIColor kGraphAxisLabelColor];
    _graphView.colorYaxisLabel = [UIColor kGraphAxisLabelColor];
    
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    
    _graphView.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    _detailStreamLabel.text = @"";
    
    
    if ([_dateCompletedArray count] == 0 || [_dateCompletedArray firstObject] == nil || [_dateCompletedArray lastObject] == nil)
    {
        _dateLabel.text = @"";
    }
    else
    {
        _dateLabel.text = [NSString stringWithFormat:@"%@ - %@", [_dateCompletedArray firstObject], [_dateCompletedArray lastObject]];
    }
    
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index
{
    CGFloat weight = [[_maxWeightArray objectAtIndex:index] floatValue];
    // y points
    return weight;
}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph
{
    // x points
    // Dates
    NSArray *exerciseCompletedArray = [_fetchedResultsController fetchedObjects];

    _maxWeightArray = [NSMutableArray new];
    _dateCompletedArray = [NSMutableArray new];
    _exerciseNameArray = [NSMutableArray new];
    _routineNameArray = [NSMutableArray new];
    
    for (KLEExerciseCompleted *exerciseCompleted in exerciseCompletedArray) {
        
        NSLog(@"EXERCISE REPS WEIGHT ARRAY %@",exerciseCompleted.maxweight);
        
        NSString *dateCompleted = [self setDateCompletedString:exerciseCompleted.datecompleted];

        [_exerciseNameArray addObject:exerciseCompleted.exercisename];
        [_routineNameArray addObject:exerciseCompleted.routinename];
        [_dateCompletedArray addObject:dateCompleted];
        [_maxWeightArray addObject:exerciseCompleted.maxweight];

    }
    NSLog(@"MAX WEIGHT ARRAY : DATE COMPLETED ARRAY %@ %@", _maxWeightArray, _dateCompletedArray);
    
    return [exerciseCompletedArray count];
}

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 1;
}

- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph
{
    if ([[KLEUtility weightUnitType] isEqualToString:kUnitPounds]) {
        return [NSString stringWithFormat:@" %@", kUnitPounds];
    }
    return [NSString stringWithFormat:@" %@", kUnitKilograms];
}

// turned off
- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index
{
    // x axis label
    NSString *dateCompleted = _dateCompletedArray[index];
    NSLog(@"date Completed %@", dateCompleted);
    
    return dateCompleted;
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index
{
    NSLog(@"DID TOUCH GRAPH");
    
    _detailStreamLabel.text = [NSString stringWithFormat:@"%@ Routine", _routineNameArray[index]];
    _dateLabel.text = [NSString stringWithFormat:@"%@", _dateCompletedArray[index]];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index
{
    NSLog(@"DID RELEASE TOUCH");
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _detailStreamLabel.alpha = 0.0;
        _dateLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        _detailStreamLabel.text = @"";
        _dateLabel.text = [NSString stringWithFormat:@"%@ - %@", [_dateCompletedArray firstObject], [_dateCompletedArray lastObject]];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _detailStreamLabel.alpha = 1.0;
            _dateLabel.alpha = 1.0;
        } completion:nil];
    }];
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph
{
    _detailStreamLabel.text = @"";
    
    if ([_dateCompletedArray count] == 0) {
        return;
    }
    _dateLabel.text = [NSString stringWithFormat:@"%@ - %@", [_dateCompletedArray firstObject], [_dateCompletedArray lastObject]];
}

- (BOOL)noDataLabelEnableForLineGraph:(BEMSimpleLineGraphView *)graph
{
    return YES;
}

- (NSString *)noDataLabelTextForLineGraph:(BEMSimpleLineGraphView *)graph
{
    NSString *noDataLabel = @"There's not enough data";
    
    return noDataLabel;
}

- (void)reloadGraph
{
    [self.graphView reloadGraph];
}

#pragma mark FETCHED RESULTS CONTROLLER

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"CONTROLLER WILL CHANGE CONTENT");
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"CONTROLLER DID CHANGE CONTENT");
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            NSLog(@"INSERT");
            [self configureFetchGraphData:_dateRangeMode withExercise:[_exercisesFromHistory objectAtIndex:_currentIndexInPicker]];
            [self reloadGraph];
            // insert
            break;
        case NSFetchedResultsChangeDelete:
            // delete
            NSLog(@"DELETE");
            [self configureFetchGraphData:_dateRangeMode withExercise:[_exercisesFromHistory objectAtIndex:_currentIndexInPicker]];
            [self reloadGraph];
            break;
        case NSFetchedResultsChangeUpdate:
            // configure cell
            NSLog(@"CHANGE UPDATE");
            break;
        case NSFetchedResultsChangeMove:
            // delete, insert rows
            NSLog(@"CHANGE MOVE");
            break;
            
        default:
            break;
    }
}

- (NSString *)setDateCompletedString:(NSDate *)dateCompleted
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    NSString *dateCompletedText = [dateFormat stringFromDate:dateCompleted];
    NSLog(@"TODAYS DATE %@", dateCompleted);
    
    return dateCompletedText;
}

#pragma mark PICKER DATA SOURCE DELEGATE

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] init];
    
    label.text = _exercisesFromHistory[row];
    [label setFont:[KLEUtility getFontFromFontFamilyWithSize:16.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    return label;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([_exercisesFromHistory count] == 0) {
        return 0;
    }
    
    return [_exercisesFromHistory count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([_exercisesFromHistory count] == 0) {
        return;
    }
    
    _currentIndexInPicker = row;
    [self configureFetchGraphData:_dateRangeMode withExercise:[_exercisesFromHistory objectAtIndex:row]];
    [self reloadGraph];
}

@end
