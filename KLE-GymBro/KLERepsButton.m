//
//  KLERepsButton.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/18/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLERepsButton.h"

#define BUTTONCOLOR [UIColor orangeColor]
#define BUTTONSELECTCOLOR [UIColor redColor]

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
        [self setTitle:@"Reps" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        self.opaque = NO;
        self.layer.borderWidth = 0;
        self.layer.cornerRadius = 26;
        self.layer.masksToBounds = YES;
        
        NSLog(@"INIT CODER BUTTON");
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
//    [self drawRing];
    [self drawRoundedRect];
//    [UIView transitionWithView:self duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//        [self.layer displayIfNeeded];
//    } completion:nil];
    
}

- (void)drawRoundedRect
{
    UIColor *buttonColor = BUTTONCOLOR;
    UIColor *buttonSelectColor = BUTTONSELECTCOLOR;
    
    CGRect leftHalf = CGRectMake(0, 0, 50, 50);
    CGRect rightHalf = CGRectMake(50, 0, 50, 50);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (buttonSwitch) {
        
        CGContextSetFillColorWithColor(context, buttonSelectColor.CGColor);
        CGContextFillRect(context, leftHalf);
        CGContextSetFillColorWithColor(context, buttonColor.CGColor);
        CGContextFillRect(context, rightHalf);
    }
    else
    {
        
        CGContextSetFillColorWithColor(context, buttonSelectColor.CGColor);
        CGContextFillRect(context, rightHalf);
        CGContextSetFillColorWithColor(context, buttonColor.CGColor);
        CGContextFillRect(context, leftHalf);
    }
    
    
    if (!self.isTouchInside) {
        CGContextSaveGState(context);
        CGContextSetFillColorWithColor(context, buttonColor.CGColor);
        CGContextFillRect(context, self.bounds);
        CGContextRestoreGState(context);
    }
}

//- (void)drawRing
//{
//    UIColor *buttonColor = [UIColor orangeColor];
//    UIColor *buttonSelectColor = [UIColor redColor];
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    [buttonColor set];
//    
//    // draw a circle
//    CGRect circlePoint = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
//    CGContextFillEllipseInRect(context, circlePoint);
//    
//    CGContextRestoreGState(context);
//    
//    if (self.state != UIControlStateHighlighted) {
//        
//        CGContextSaveGState(context);
//        [buttonSelectColor set];
//        
//        CGRect circlePoint = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
//        CGContextFillEllipseInRect(context, circlePoint);
//        
//        CGContextRestoreGState(context);
//    }
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    if (location.x > 0 && location.x < 51) {
        NSLog(@"TOUCH LEFT HALF");
        buttonSwitch = YES;
    }
    else
    {
        NSLog(@"TOUCH RIGHT HALF");
        buttonSwitch = NO;
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
