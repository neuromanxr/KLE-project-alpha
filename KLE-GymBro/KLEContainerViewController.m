//
//  KLEContainerViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 1/14/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEContainerViewController.h"

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
        [self setOverrideTraitCollection: [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular] forChildViewController:self.viewController];
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

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    if (size.width > size.height) {
//        [self setOverrideTraitCollection:[UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular] forChildViewController:self.viewController];
//    } else {
//        [self setOverrideTraitCollection:nil forChildViewController:self.viewController];
//    }
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
