//
//  KLERepsButton.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/18/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLERepsButton.h"

#define BUTTONCOLOR [UIColor orangeColor]
#define BUTTONTWOTONECOLOR [UIColor colorWithRed:255.f green:204.f blue:102.f alpha:1.0]
#define BUTTONSELECTCOLOR [UIColor redColor]

#define SK_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.0174532952f) // PI / 180
#define SK_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f) // PI * 180

@interface KLERepsButton ()

{
    BOOL buttonSwitch;
}

@end

@implementation KLERepsButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self drawTextLabels];
        
        NSLog(@"INIT CODER BUTTON");
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self drawBlurRing:rect];
    
    [self drawLeftRightArc];
    
}

- (void)drawTextLabels
{
    _repsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.bounds) / 2,
                                                           CGRectGetMidY(self.bounds) / 2,
                                                           CGRectGetMidX(self.bounds),
                                                           CGRectGetMidY(self.bounds) / 2)];
    _repsLabel.text = @"R";
    _repsLabel.font = [UIFont fontWithName:@"Helvetica" size:CGRectGetMidX(self.bounds) / 2];
    _repsLabel.textColor = [UIColor redColor];
    _repsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_repsLabel];
    
    _minusLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.bounds),
                                                            CGRectGetMidY(self.bounds) / 2,
                                                            CGRectGetMidX(self.bounds) / 2,
                                                            CGRectGetMidY(self.bounds))];
    _minusLabel.text = @"-";
    _minusLabel.font = [UIFont fontWithName:@"Helvetica" size:CGRectGetMidX(self.bounds) / 2];
    _minusLabel.textColor = [UIColor redColor];
    _minusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_minusLabel];
    
    CALayer *minusLayer = _minusLabel.layer;
    CABasicAnimation *pulseAnimation;
    pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    pulseAnimation.duration = 1.0;
    pulseAnimation.repeatCount = HUGE_VALF;
    pulseAnimation.autoreverses = YES;
    pulseAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    pulseAnimation.toValue = [NSNumber numberWithFloat:0.5];
    [minusLayer addAnimation:pulseAnimation forKey:@"animateOpacity"];
    
    _plusLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bounds) * 0.75,
                                                           CGRectGetMidY(self.bounds) / 2,
                                                           CGRectGetMidX(self.bounds) / 2,
                                                           CGRectGetMidY(self.bounds))];
    _plusLabel.text = @"+";
    _plusLabel.font = [UIFont fontWithName:@"Helvetica" size:CGRectGetMidX(self.bounds) / 2];
    _plusLabel.textColor = [UIColor yellowColor];
    _plusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_plusLabel];
    
    CALayer *plusLayer = _plusLabel.layer;
    [plusLayer addAnimation:pulseAnimation forKey:@"animateOpacity"];
}

- (void)drawLeftRightArc
{
    if (buttonSwitch) {
        _minusLabel.textColor = [UIColor yellowColor];
        
    }
    else
    {
        _plusLabel.textColor = [UIColor redColor];
        
    }
    
    if (!self.isTouchInside) {
        
        _plusLabel.textColor = [UIColor yellowColor];
        _minusLabel.textColor = [UIColor redColor];
        
    }
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
    CGPoint startPoint = CGPointMake(CGRectGetMaxY(rect), CGRectGetMinX(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMinY(rect), CGRectGetMaxX(rect));
    // draw gradient
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    if (location.x > CGRectGetMinX(self.bounds) && location.x < CGRectGetMidX(self.bounds)) {
        
        NSLog(@"TOUCH LEFT HALF");
        buttonSwitch = YES;
        
        // tell delegate the half is tapped
        [self.delegate changeRepsValue:buttonSwitch];
    }
    else
    {
        
        NSLog(@"TOUCH RIGHT HALF");
        buttonSwitch = NO;
        
        // tell delegate the half is tapped
        [self.delegate changeRepsValue:buttonSwitch];
    }
    
    NSLog(@"TOUCH LOCATION %f %f", location.x, location.y);
    
    [self setNeedsDisplay];
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
}

@end
