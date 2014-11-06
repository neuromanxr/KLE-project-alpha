//
//  KLEDailyViewController.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/6/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLEDailyViewController : UITableViewController

@property NSUInteger newRoutineIndex;
@property NSUInteger newStartIndex;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSArray *currentActionRowPaths;

- (NSArray *)createActionRowPathsFromRoutineIndex:(NSUInteger)routineIndex startIndex:(NSUInteger)startIndex atIndexPath:(NSIndexPath *)indexPath;

@end
