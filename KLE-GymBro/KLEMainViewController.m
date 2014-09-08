//
//  KLEMainViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/1/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

//#import "KLEMainView.h"
#import "KLEMainViewController.h"

@interface KLEMainViewController ()

//@property (nonatomic, strong) KLEMainView *squareView;

@end

@implementation KLEMainViewController

//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    
//    if (self) {
//        
//    }
//    return self;
//}

//- (void)loadView
//{
//    // create the parent view
//    CGRect mainFrame = [UIScreen mainScreen].bounds;
//    UIView *mainView = [[UIView alloc] initWithFrame:mainFrame];
//    mainView.backgroundColor = [UIColor grayColor];
//    
//    // create the square view
//    self.squareView = [[KLEMainView alloc] init];
//    
//    // add the parent view to this view controller
//    self.view = mainView;
//    
//    // add square view as a subview to the parent view
//    [self.view addSubview:self.squareView];
//}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    self.view.backgroundColor = [UIColor whiteColor];

    // list of exercises
//    self.exerciseArray = [[NSArray alloc] initWithObjects:@"Bench Press", @"Deadlift", @"Squats", @"Arm Curls", @"French Press", @"Army Press", nil];
    
    // create a sublayer
//    CALayer *blueLayer = [CALayer layer];
//    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
//    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    
//    [self.view.layer addSublayer:blueLayer];
    
    // load an image and add it directly to square view's layer
//    UIImage *image = [UIImage imageNamed:@"Porsche_logo.png"];
//    self.squareView.layer.contents = (id)image.CGImage;
//    self.squareView.layer.contentsGravity = kCAGravityCenter;
//    self.squareView.layer.contentsScale = [UIScreen mainScreen].scale;
//    self.squareView.layer.masksToBounds = YES;
    // add blue layer as a subview to the square view
//    [self.squareView.layer addSublayer:blueLayer];
//}

@end
