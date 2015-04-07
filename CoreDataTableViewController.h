//
//  CoreDataTVC.h
//  Grocery Dude
//
//  Created by Tim Roadley on 19/09/13.
//  Copyright (c) 2013 Tim Roadley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelperKit.h"
@interface CoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *frc;

- (void)performFetch;

@end
