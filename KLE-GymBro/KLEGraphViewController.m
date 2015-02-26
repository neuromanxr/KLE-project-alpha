//
//  KLEGraphViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/25/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEAppDelegate.h"
#import "KLEGraphViewController.h"

@interface KLEGraphViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *textLabel;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation KLEGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.textLabel.text = [[self fetchCompletedExercises] componentsJoinedByString:@"-"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchCompletedExercises) name:@"SomethingChanged" object:nil];
    
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"KLEExerciseCompleted"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"routinename" ascending:YES], nil];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:cdh.context sectionNameKeyPath:nil cacheName:nil];
    [_fetchedResultsController setDelegate:self];
    
    NSError *error = nil;
    [_fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"Unable to perform fetch %@, %@", error, error.localizedDescription);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            // insert
            break;
        case NSFetchedResultsChangeDelete:
            // delete
            NSLog(@"DELETE");
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

- (NSArray *)fetchCompletedExercises
{
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KLEExerciseCompleted"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"routinename" ascending:YES], nil];

    // fetch the routines with daynumbers that match the section and bool value is set to yes
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"inworkout == %@ AND daynumber == %@", @(YES), @(indexPath.section)];
//    [request setPredicate:predicate];

    NSArray *requestObjects = [cdh.context executeFetchRequest:request error:nil];
    
    NSLog(@"fetch objects in graph %@", requestObjects);
    
    return requestObjects;
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
