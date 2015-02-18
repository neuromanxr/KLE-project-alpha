//
//  KLEHistoryViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 1/27/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEHistoryTableViewCell.h"
#import "CoreDataHelper.h"
#import "KLEAppDelegate.h"
#import "KLEHistoryViewController.h"

@interface KLEHistoryViewController ()

@end

@implementation KLEHistoryViewController

- (void)configureFetch
{
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KLERoutine"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"dayname" ascending:YES], nil];
    //    KLERoutines *routines = (KLERoutines *)[self.frc.managedObjectContext existingObjectWithID:self.routinesID error:nil];
    //    KLERoutines *routines = (KLERoutines *)[self.frc.managedObjectContext objectWithID:self.routinesID];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"routines == %@", routines];
    //    [request setPredicate:predicate];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:@"dayname" cacheName:nil];
    self.frc.delegate = self;
    //    NSLog(@"routines %@", routines);
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        // title for hvc
        navItem.title = @"History";
        
        // button to add exercises
        //        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewRoutine)];
        
        // button to edit routine
        //        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:nil];
        
        // set bar button to toggle editing mode
        //        editButton = self.editButtonItem;
        
        // set the button to be the right nav button of the nav item
        //        navItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:addButton, editButton, nil];
        
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // create an instance of UITableViewCell, with default appearance
    KLEHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLEHistoryTableViewCell" forIndexPath:indexPath];
    
//    KLERoutine *routine = [self.frc objectAtIndexPath:indexPath];

//    cell.nameLabel.text = routine.routinename;
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Cell selected");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if the table view is asking to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
//        KLERoutine *deleteTarget = [self.frc objectAtIndexPath:indexPath];
//        [self.frc.managedObjectContext deleteObject:deleteTarget];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // alert the user about deletion
        UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Delete routine" message:@"This will also delete the routine in Daily" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [deleteAlert show];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureFetch];
    [self performFetch];
    
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