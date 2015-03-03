//
//  KLEGraphViewController.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/25/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//
#import "KLEUtility.h"
#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"


@interface KLEGraphViewController : UIViewController <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *graphView;

@property (nonatomic, copy) NSArray *exercisesFromHistory;

@property (nonatomic, assign) KLEDateRangeMode dateRangeMode;

@end
