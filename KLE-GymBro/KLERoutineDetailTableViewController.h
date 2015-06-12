//
//  KLERoutineDetailTableViewController.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/15/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLERoutine;

@interface KLERoutineDetailTableViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) KLERoutine *selectedRoutine;

@end
