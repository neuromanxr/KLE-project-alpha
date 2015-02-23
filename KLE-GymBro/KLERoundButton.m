//
//  KLERoundButton.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/21/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLERoundButton.h"

@implementation KLERoundButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
//        [self xibSetup];
    }
    return self;
}

//- (void)xibSetup
//{
//    UIView *view = [self loadViewFromNib];
//    
//    view.frame = self.bounds;
//    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self addSubview:view];
//}

//- (UIView *)loadViewFromNib
//{
//    NSBundle *bundle = [NSBundle mainBundle];
//    UINib *nib = [UINib nibWithNibName:@"KLERoundButton" bundle:bundle];
//    
//    UIView *view = [[nib instantiateWithOwner:self options:nil] firstObject];
//    
//    return view;
//}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self drawRing];
    
}

- (void)drawRing
{
    UIColor *buttonColor = [UIColor orangeColor];
    UIColor *buttonSelectColor = [UIColor redColor];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [buttonColor set];
    
    // draw a circle
    CGRect circlePoint = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    CGContextFillEllipseInRect(context, circlePoint);
    
    CGContextRestoreGState(context);
    
    if (self.state != UIControlStateHighlighted) {
        
        CGContextSaveGState(context);
        [buttonSelectColor set];
        
        CGRect circlePoint = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        CGContextFillEllipseInRect(context, circlePoint);
        
        CGContextRestoreGState(context);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
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
