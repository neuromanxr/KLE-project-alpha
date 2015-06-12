//
//  KLEGraphViewController.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/25/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"


@interface KLEGraphViewController : UIViewController <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *graphView;

@property (nonatomic, strong) NSArray *exercisesFromHistory;

@property (nonatomic, assign) KLEDateRangeMode dateRangeMode;

@end
