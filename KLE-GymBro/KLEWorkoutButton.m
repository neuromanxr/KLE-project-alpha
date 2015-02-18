//
//  KLEWorkoutButton.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 1/25/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEWorkoutButton.h"

#define SK_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.0174532952f) // PI / 180
#define SK_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f) // PI * 180

@interface KLEWorkoutButton ()

{
    float ringAngle;
}

@property (nonatomic, strong) NSNumber *currentSet;

@end

@implementation KLEWorkoutButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setTitle:@"Reps" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        self.backgroundColor = [UIColor clearColor];
//        self.layer.masksToBounds = YES;
        ringAngle = 0.0;
        _currentSet = [NSNumber numberWithInteger:0];
        NSLog(@"SETS FOR ANGLE %@", self.setsForAngle);
        NSLog(@"RING ANGLE %f", ringAngle);
        NSLog(@"INIT CODER BUTTON");
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    UIColor *buttonColor = [UIColor colorWithRed:32/255.0f green:116/255.0f blue:138/255.0f alpha:1.0f];
//    UIColor *buttonSelectColor = [UIColor colorWithRed:9/255.0f green:48/255.0f blue:74/255.0f alpha:1.0f];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawRing:context];
    [self drawProgressRing:context];
    [self drawWorkoutRing];
}

- (void)drawRing:(CGContextRef)context
{
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 8.0);
    [[UIColor redColor] set];
    // draw a circle
    CGContextAddArc(context, (self.frame.size.width / 2), (self.frame.size.height / 2), (self.frame.size.width - 10) / 2, 0.0, M_PI * 2.0, 1);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)drawWorkoutRing
{
//    int radius = 100;
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake((self.frame.size.width / 2), (self.frame.size.height / 2)) radius:(self.frame.size.width - 40) / 2 startAngle:0.0 endAngle:(M_PI * 2.0) clockwise:1].CGPath;
//    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((self.frame.size.width / 4), (self.frame.size.height / 4), (self.frame.size.width - 10) / 2, (self.frame.size.height - 10) / 2) cornerRadius:radius].CGPath;
//    circle.position = CGPointMake(self.frame.origin.x, self.frame.origin.y);
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor blueColor].CGColor;
    circle.lineWidth = 5.0;
    // fix blurred edges
    CALayer *mainLayer = [self layer];
    [mainLayer setRasterizationScale:[[UIScreen mainScreen] scale]];
    circle.contentsScale = 4.0 * [[UIScreen mainScreen] scale];
//    circle.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
//    circle.shouldRasterize = YES;
    [mainLayer setShouldRasterize:YES];
    [self.layer addSublayer:circle];
    
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration = 1.0;
    drawAnimation.repeatCount = 1.0;
    drawAnimation.removedOnCompletion = NO;
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
}

- (void)drawProgressRing:(CGContextRef)context
{
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 8.0);
//    CGContextSetLineDash(context, 0.0, [3,2] , 0);
    [[UIColor blueColor] set];
    NSLog(@"RING ANGLE IN DRAW PROGRESS %f", ringAngle);
    CGContextAddArc(context,
                    (self.frame.size.width / 2),
                    (self.frame.size.height / 2),
                    (self.frame.size.width - 30) / 2,
                    0.0,
                    ringAngle,
                    0);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)resetAngle:(float)angle
{
    NSLog(@"RESET ANGLE %f", angle);
    ringAngle = angle;
    _currentSet = [NSNumber numberWithInteger:angle];
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
//    if ([self.setsForAngle integerValue] > 0) {
//        ringAngle = 360 / [self.setsForAngle floatValue];
//        self.setsForAngle = [NSNumber numberWithInteger:([self.setsForAngle integerValue] - 1)];
//        [self setTitle:[NSString stringWithFormat:@"%@", self.setsForAngle] forState:UIControlStateNormal];
//    } else {
//        [self setTitle:[NSString stringWithFormat:@"%@", self.setsForAngle] forState:UIControlStateNormal];
//    }
    
    NSLog(@"RING ANGLE IN BUTTON %f", ringAngle);
    if (ringAngle >= SK_DEGREES_TO_RADIANS(360)) {
        
        ringAngle = SK_DEGREES_TO_RADIANS(0);
        NSUInteger sets = [self.setsForAngle integerValue];
        NSNumber *setsNumber = [NSNumber numberWithInteger:sets];
        
        // start the current set at zero
        _currentSet = [NSNumber numberWithInteger:0];
        NSLog(@"CURRENT SET %lu", [_currentSet integerValue]);
        NSLog(@"SETS NUMBER %@", setsNumber);
        [self setTitle:[NSString stringWithFormat:@"%@", setsNumber] forState:UIControlStateNormal];
    } else {
        
        NSUInteger sets = [self.titleLabel.text integerValue];
        NSLog(@"SETS FOR ANGLE %lu", [self.setsForAngle integerValue]);
        if ([self.setsForAngle integerValue] != 0) {
            ringAngle += SK_DEGREES_TO_RADIANS((360 / [_setsForAngle floatValue]));
            sets--;
            // increment current set every tap
            _currentSet = [NSNumber numberWithInteger:([_currentSet integerValue] + 1)];
            [self.delegate currentSet:[_currentSet integerValue]];
            
            NSLog(@"CURRENT SET %lu", [_currentSet integerValue]);
        }
        NSNumber *setsNumber = [NSNumber numberWithInteger:sets];
        [self setTitle:[NSString stringWithFormat:@"%@", setsNumber] forState:UIControlStateNormal];
    }
    
    [self setNeedsDisplay];
    NSLog(@"CIRCLE BUTTON TOUCHES BEGAN");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
    NSLog(@"CIRCLE BUTTON TOUCHES ENDED");
}

@end
