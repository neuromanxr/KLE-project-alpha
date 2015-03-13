//
//  KLEWorkoutButton.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 1/25/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEWorkoutButton.h"

#define BUTTONCOLOR [UIColor orangeColor]
#define BUTTONTWOTONECOLOR [UIColor colorWithRed:255.f green:204.f blue:102.f alpha:1.0]
#define BUTTONSELECTCOLOR [UIColor redColor]

#define SK_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.0174532952f) // PI / 180
#define SK_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f) // PI * 180

@interface KLEWorkoutButton ()

{
    CGFloat ringAngle;
    BOOL inProgress;
}

@property (nonatomic, strong) NSNumber *currentSet;

@end

@implementation KLEWorkoutButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        ringAngle = 0.0;
        _currentSet = [NSNumber numberWithInteger:0];
        
        NSLog(@"SETS FOR ANGLE %@", self.setsForAngle);
        NSLog(@"RING ANGLE %f", ringAngle);
        NSLog(@"INIT CODER BUTTON");
        
        [self createSetsButton];
        
        [self drawPulseRing];
    }
    return self;
}

- (void)createSetsButton
{
    _setsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width / 4, self.bounds.size.height / 4, self.bounds.size.width / 2, self.bounds.size.height / 2)];
    //    _setsButton.backgroundColor = [UIColor orangeColor];
    
    [_setsButton setTitle:@"Sets" forState:UIControlStateNormal];
    [_setsButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [_setsButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_setsButton];
}

- (void)buttonPressed:(UIButton *)button
{
    NSLog(@"BUTTON PRESSED");
    
    NSLog(@"RING ANGLE IN BUTTON %f", ringAngle);
    if (ringAngle >= SK_DEGREES_TO_RADIANS(360)) {
        
        inProgress = NO;
        ringAngle = SK_DEGREES_TO_RADIANS(0);
        NSUInteger sets = [self.setsForAngle integerValue];
        NSNumber *setsNumber = [NSNumber numberWithInteger:sets];
        
        // start the current set at zero
        _currentSet = [NSNumber numberWithInteger:0];
        NSLog(@"CURRENT SET %lu", [_currentSet integerValue]);
        NSLog(@"SETS NUMBER %@", setsNumber);
        [_setsButton setTitle:[NSString stringWithFormat:@"%@", setsNumber] forState:UIControlStateNormal];
        [_setsButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
    } else {
        
        // button title set in view controller to amount of sets
        NSUInteger sets = [_setsButton.titleLabel.text integerValue];
        NSLog(@"SETS FOR ANGLE %lu", [self.setsForAngle integerValue]);
        if ([self.setsForAngle integerValue] != 0) {
            
            inProgress = YES;
            ringAngle += SK_DEGREES_TO_RADIANS((360 / [_setsForAngle floatValue]));
            // decrement sets left
            sets--;
            
            // increment current set every tap
            _currentSet = [NSNumber numberWithInteger:([_currentSet integerValue] + 1)];
            
            // run delegate methods
            [self.delegate currentSet:[_currentSet integerValue]];
            [self.delegate logCurrentSetsRepsWeight];
            
            NSLog(@"CURRENT SET %lu : SETS LEFT %lu", [_currentSet integerValue], sets);
            
        }
        NSNumber *setsNumber = [NSNumber numberWithInteger:sets];
        [_setsButton setTitle:[NSString stringWithFormat:@"%@", setsNumber] forState:UIControlStateNormal];
        [_setsButton setHighlighted:YES];
        [_setsButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self drawBlurRing:rect];
    
    [self drawProgressRing];
    
    //    [self flashOn:self];
    
}

- (void)drawBlurRing:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    // background
    CGContextAddArc(context, (self.frame.size.width / 2.0), (self.frame.size.height / 2.0), (self.frame.size.width - 30) / 2, 0, M_PI * 2.0, 1);
    [[UIColor orangeColor] set];
    CGContextSetLineWidth(context, 18);
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextDrawPath(context, kCGPathStroke);
    
    // ring where gradient will be
    UIGraphicsBeginImageContext(CGSizeMake(self.bounds.size.width, self.bounds.size.height));
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    CGContextAddArc(imageContext, (self.frame.size.width / 2), (self.frame.size.height / 2), (self.frame.size.width - 30) / 2, 0.0, M_PI * 2.0, 1);
    [[UIColor redColor] set];
    
    // shadow for blur effect
    CGContextSetShadowWithColor(imageContext, CGSizeMake(0, 0), (M_PI * 2.0), [UIColor blackColor].CGColor);
    // path for shadow
    CGContextSetLineWidth(imageContext, 16);
    CGContextDrawPath(imageContext, kCGPathStroke);
    
    // create mask from image
    CGImageRef mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    
    // save context into mask
    CGContextSaveGState(context);
    
    CGContextClipToMask(context, self.bounds, mask);
    
    // gradient colors
    CGFloat *startColor = (CGFloat *)CGColorGetComponents([UIColor redColor].CGColor);
    CGFloat *endColor = (CGFloat *)CGColorGetComponents([UIColor yellowColor].CGColor);
    CGFloat colorComponents[8] = { startColor[0], startColor[1], startColor[2], startColor[3], endColor[0], endColor[1], endColor[2], endColor[3] };
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colorComponents, nil, 2);
    // gradient start and end
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    // draw gradient
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
}

- (void)drawPulseRing
{
    
    // inner circle
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake((self.frame.size.width / 2), (self.frame.size.height / 2)) radius:(self.frame.size.width - 50) / 2 startAngle:0.0 endAngle:(M_PI * 2.0) clockwise:1].CGPath;
    
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor orangeColor].CGColor;
    circle.lineWidth = 5.0;
    
    // fix blurred edges
    CALayer *mainLayer = [self layer];
    [mainLayer setRasterizationScale:[[UIScreen mainScreen] scale]];
    circle.contentsScale = 4.0 * [[UIScreen mainScreen] scale];
    [mainLayer setShouldRasterize:YES];
    
    [self.layer addSublayer:circle];
    
    // pulse animation
    CABasicAnimation *pulseAnimation;
    pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    pulseAnimation.duration = 1.0;
    pulseAnimation.repeatCount = HUGE_VALF;
    pulseAnimation.autoreverses = YES;
    pulseAnimation.fromValue = [NSNumber numberWithFloat:0.7];
    pulseAnimation.toValue = [NSNumber numberWithFloat:0.1];
    [circle addAnimation:pulseAnimation forKey:@"animateOpacity"];
    
    // outer ring
    CAShapeLayer *outerCircle = [CAShapeLayer layer];
    outerCircle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake((self.frame.size.width / 2), (self.frame.size.height / 2)) radius:(self.frame.size.width - 20) / 2 startAngle:0.0 endAngle:(M_PI * 2.0) clockwise:1].CGPath;
    outerCircle.fillColor = [UIColor clearColor].CGColor;
    outerCircle.strokeColor = [UIColor orangeColor].CGColor;
    outerCircle.lineWidth = 5.0;
    
    [self.layer addSublayer:outerCircle];
    
    [outerCircle addAnimation:pulseAnimation forKey:@"animateOpacity"];
}

- (void)drawProgressRing
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 10.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    //    CGContextSetLineDash(context, 0.0, [3,2] , 0);
    [[UIColor yellowColor] set];
    NSLog(@"RING ANGLE IN DRAW PROGRESS %f", ringAngle);
    CGContextAddArc(context,
                    (self.frame.size.width / 2),
                    (self.frame.size.height / 2),
                    (self.frame.size.width - 40) / 2,
                    0.0,
                    ringAngle,
                    0);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)resetAngle:(CGFloat)angle
{
    NSLog(@"RESET ANGLE %f", angle);
    
    ringAngle = angle;
    _currentSet = [NSNumber numberWithInteger:angle];
    
    [self setNeedsDisplay];
}

- (BOOL)isWorkoutInProgress
{
    if (inProgress) {
        NSLog(@"WORKOUT IN PROGRESS");
        return YES;
    }
    NSLog(@"WORKOUT NOT IN PROGRESS");
    return NO;
}

@end
