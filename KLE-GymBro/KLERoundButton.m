//
//  KLERoundButton.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/21/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEUtility.h"
#import "KLERoundButton.h"

@interface KLERoundButton ()

@property (nonatomic, strong) UILabel *finishLabel;

@property (nonatomic, assign) CGFloat endAngle;

@end

@implementation KLERoundButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self createFinishLabel];
        
        _endAngle = 0.0;
        
        NSLog(@"INIT CODER FINISH BUTTON");
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [self drawBlurRing:rect];
    
    [self drawDashRing];
    
    //    [self drawCenter];
    
}

- (void)createFinishLabel
{
    _finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / 4,
                                                             self.bounds.size.height / 4,
                                                             self.bounds.size.width / 2,
                                                             self.bounds.size.height / 2)];
    _finishLabel.text = @"Finish";
    [_finishLabel setFont:[KLEUtility getFontFromFontFamilyWithSize:14.0]];
    _finishLabel.textColor = [UIColor kPrimaryColor];
    _finishLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_finishLabel];
}

//- (void)drawCenter
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    [[UIColor redColor] set];
//
//    // draw a circle
//    CGRect circlePoint = CGRectMake(CGRectGetMidX(self.bounds) / 2,
//                                    CGRectGetMidY(self.bounds) / 2,
//                                    self.bounds.size.width / 2,
//                                    self.bounds.size.height / 2);
//    CGContextFillEllipseInRect(context, circlePoint);
//
//    CGContextRestoreGState(context);
//}

- (void)drawDashRing
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 4.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    //    CGFloat dashLengths[] = {20.0, 40.0};
    //    CGContextSetLineDash(context, 2.0, dashLengths, 2);
    CGContextSetAlpha(context, 0.5);
    [[UIColor yellowColor] set];
    
    CGContextAddArc(context,
                    (self.frame.size.width / 2),
                    (self.frame.size.height / 2),
                    (self.frame.size.width - 50) / 2,
                    0.0,
                    _endAngle,
                    0);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)drawBlurRing:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    // background
    CGContextAddArc(context,
                    (self.frame.size.width / 2.0),
                    (self.frame.size.height / 2.0),
                    (self.frame.size.width - 30) / 2,
                    0,
                    M_PI * 2.0,
                    1);
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
    CGFloat *startColor = (CGFloat *)CGColorGetComponents([UIColor kPrimaryColor].CGColor);
    CGFloat *endColor = (CGFloat *)CGColorGetComponents([UIColor kPrimaryColor].CGColor);
    CGFloat colorComponents[8] = { startColor[0], startColor[1], startColor[2], startColor[3], endColor[0], endColor[1], endColor[2], endColor[3] };
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colorComponents, nil, 2);
    // gradient start and end
    CGPoint startPoint = CGPointMake(CGRectGetMinY(rect), CGRectGetMidX(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxY(rect), CGRectGetMidX(rect));
    // draw gradient
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"TOUCHES BEGAN");
    
    _endAngle = M_PI * 2;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _finishLabel.alpha = 0.3;
        
    } completion:nil];
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    NSLog(@"TOUCHES MOVE");
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"TOUCHES CANCEL");
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    NSLog(@"TOUCHES END");
    
    _endAngle = 0.0;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _finishLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        _finishLabel.text = @"Finish";
    }];
    
    [self setNeedsDisplay];
}

@end
