//
//  KLEExerciseListViewController.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/11/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "CoreDataHelper.h"
#import <Foundation/Foundation.h>

@class KLEExerciseListViewController;

// not being used
// declare delegate to pass data from elvc to revc
@protocol ELVCDelegate <NSObject>

- (void)selectionFromELVC:(KLEExerciseListViewController *)elvc thisSelection:(NSIndexPath *)selection;

@end

@interface KLEExerciseListViewController : UITableViewController

- (instancetype)initForNewExercise:(BOOL)isNew;
- (instancetype)initWithStyle:(UITableViewStyle)style;

// stat store from revc will be passed to here
@property (nonatomic, strong) KLEStatStore *statStore;

@property (nonatomic, strong) KLEStat *stat;

@property (nonatomic, weak) id<ELVCDelegate> delegate;

@property (nonatomic, copy) void (^dismissBlock)(void);

@property (nonatomic, strong, readonly) CoreDataHelper *coreDataHelper;

@end
