//
//  KLEContainerViewController.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 1/14/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLEContainerViewController : UIViewController

@property (nonatomic, strong) UISplitViewController *viewController;

- (void)setEmbeddedViewController:(UISplitViewController *)splitViewController;

@end
