//
//  KLEGraphViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/25/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEExerciseCompleted.h"
#import "KLEAppDelegate.h"
#import "KLEGraphViewController.h"

@interface KLEGraphViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailStreamLabel;

@property (strong, nonatomic) IBOutlet UILabel *exerciseCompletedStepperLabel;
@property (strong, nonatomic) IBOutlet UIStepper *exerciseCompletedStepper;
- (IBAction)exerciseCompletedStepperAction:(id)sender;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, copy) NSMutableArray *dateCompletedArray;
@property (nonatomic, copy) NSMutableArray *maxWeightArray;
@property (nonatomic, copy) NSMutableArray *exerciseNameArray;

@end

@implementation KLEGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureFetchGraphData) name:@"SomethingChanged" object:nil];
    
    [self configureFetchGraphData];
    
    [self configureGraphView];
    
    _exerciseCompletedStepper.value = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureFetchGraphData
{
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"KLEExerciseCompleted"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"datecompleted" ascending:NO], nil];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:cdh.context sectionNameKeyPath:nil cacheName:nil];
    [_fetchedResultsController setDelegate:self];
    
    NSError *error = nil;
    [_fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"Unable to perform fetch %@, %@", error, error.localizedDescription);
    }
    
    NSLog(@"FETCHED RESULTS %@", [[_fetchedResultsController fetchedObjects] componentsJoinedByString:@"-"]);
}

- (void)configureGraphView
{
    _graphView.dataSource = self;
    _graphView.delegate = self;
    _graphView.widthLine = 3.0;
    _graphView.alwaysDisplayDots = NO;
    _graphView.alwaysDisplayPopUpLabels = NO;
    _graphView.enableReferenceAxisFrame = YES;
    _graphView.enableReferenceXAxisLines = YES;
    _graphView.enableReferenceYAxisLines = YES;
    _graphView.enableTouchReport = YES;
    _graphView.enablePopUpReport = YES;
    _graphView.enableXAxisLabel = YES;
    _graphView.enableYAxisLabel = YES;
    _graphView.autoScaleYAxis = YES;
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    
    _graphView.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    _graphView.colorTop = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    _graphView.colorBottom = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    _graphView.colorLine = [UIColor whiteColor];
    _graphView.colorXaxisLabel = [UIColor whiteColor];
    _graphView.colorYaxisLabel = [UIColor whiteColor];
    
    _detailStreamLabel.text = @"Exercise";
    _dateLabel.text = [NSString stringWithFormat:@"between %@ and %@", [_dateCompletedArray firstObject], [_dateCompletedArray lastObject]];
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
    _maxWeightArray = [[NSMutableArray alloc] init];
    _dateCompletedArray = [[NSMutableArray alloc] init];
    _exerciseNameArray = [[NSMutableArray alloc] init];
    NSArray *exerciseCompletedArray = [_fetchedResultsController fetchedObjects];
    
    for (KLEExerciseCompleted *exerciseCompleted in exerciseCompletedArray) {
        
        NSLog(@"EXERCISE REPS WEIGHT ARRAY %@",exerciseCompleted.maxweight);
        NSString *dateCompleted = [self dateCompleted:exerciseCompleted.datecompleted];
//        NSString *setsCompleted = [NSString stringWithFormat:@"%lu", [exerciseCompleted.setscompleted integerValue]];
        [_exerciseNameArray addObject:exerciseCompleted.exercisename];
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
    return @" lb";
}

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
    
    _detailStreamLabel.text = [NSString stringWithFormat:@"%@", _exerciseNameArray[index]];
    _dateLabel.text = [NSString stringWithFormat:@"%@", _dateCompletedArray[index]];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index
{
    NSLog(@"DID RELEASE TOUCH");
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _detailStreamLabel.alpha = 0.0;
        _dateLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        _detailStreamLabel.text = @"Exercise";
        _dateLabel.text = [NSString stringWithFormat:@"between %@ and %@", [_dateCompletedArray firstObject], [_dateCompletedArray lastObject]];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _detailStreamLabel.alpha = 1.0;
            _dateLabel.alpha = 1.0;
        } completion:nil];
    }];
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph
{
    _detailStreamLabel.text = @"Exercise";
    _dateLabel.text = [NSString stringWithFormat:@"between %@ and %@", [_dateCompletedArray firstObject], [_dateCompletedArray lastObject]];
}

- (void)reloadGraph
{
    [self.graphView reloadGraph];
}

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
            [self configureFetchGraphData];
            [self reloadGraph];
            // insert
            break;
        case NSFetchedResultsChangeDelete:
            // delete
            NSLog(@"DELETE");
            [self configureFetchGraphData];
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

- (NSString *)dateCompleted:(NSDate *)dateCompleted
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    NSString *dateCompletedText = [dateFormat stringFromDate:dateCompleted];
    NSLog(@"TODAYS DATE %@", dateCompleted);
    
    return dateCompletedText;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)exerciseCompletedStepperAction:(id)sender
{
    _exerciseCompletedStepperLabel.text = [NSString stringWithFormat:@"%.f", _exerciseCompletedStepper.value];
}
@end
