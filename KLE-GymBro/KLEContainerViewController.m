//
//  KLEContainerViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 1/14/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEContainerViewController.h"

// needs work. After transition to landscape mode and tabbing through the views, the views are displayed in a unexpected way. Look at viewWillTransitionToSize..

@interface KLEContainerViewController ()

@end

@implementation KLEContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEmbeddedViewController:(UISplitViewController *)splitViewController
{
    if (splitViewController != nil) {
        self.viewController = splitViewController;
        
        [self addChildViewController:self.viewController];
        [self.view addSubview:self.viewController.view];
        [self.viewController didMoveToParentViewController:self];
        
        // uncomment to have split view for both orientations
//        [self setOverrideTraitCollection: [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular] forChildViewController:self.viewController];
    }
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    NSLog(@"##WILL TRANSITION TO TRAIT COLLECTION");
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // transition to match context duration
        CATransition *transition = [[CATransition alloc] init];
        transition.duration = [context transitionDuration];
        // fade
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        [self.view.layer addAnimation:transition forKey:@"Fade"];
    } completion:nil];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    NSLog(@"**VIEW WILL TRANSITION TO SIZE");

    if (size.width > size.height) {
        
        [self setOverrideTraitCollection:[UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular] forChildViewController:self.viewController];
    } else {
        
        [self setOverrideTraitCollection:nil forChildViewController:self.viewController];
    }
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

@end
