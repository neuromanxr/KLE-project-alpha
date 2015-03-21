//
//  KLEWorkoutTimer.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/21/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEUtility.h"
#import "KLEWorkoutTimer.h"

@interface KLEWorkoutTimer ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (assign, nonatomic) NSTimeInterval time;

@property (assign, nonatomic) NSTimeInterval timePaused;

@property (assign, nonatomic) NSTimeInterval resumeTime;

@property (nonatomic) BOOL start;

@property (nonatomic) BOOL resume;

- (IBAction)timerButtonAction:(UIButton *)sender;

@end

@implementation KLEWorkoutTimer

- (void)awakeFromNib
{
    [[NSBundle mainBundle] loadNibNamed:@"KLEWorkoutTimer" owner:self options:nil];
    
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.contentView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    _start = NO;
    _resume = NO;
}

- (NSString *)minutesAndSeconds:(NSTimeInterval)time
{
    // minutes in elapsed
    int minutes = (int)(time / 60.0);
    
    int seconds = (int)(time = time - (minutes * 60));
    
    NSString *timerString = [NSString stringWithFormat:@"%u:%02u", minutes, seconds];
    
    return timerString;
}

- (void)updateTime
{
    if (_start == NO) {
        return;
    }
    
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    
    NSTimeInterval elapsedTime = currentTime - _time;
    
    _resumeTime = elapsedTime;

    NSLog(@"NSTIMEINTERVAL elapsed time: %.2f", elapsedTime);
    NSLog(@"TIME %.2f", _time);
    
    _timer.text = [self minutesAndSeconds:elapsedTime];
    
    // recursion
    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.1];
}


- (IBAction)timerButtonAction:(UIButton *)sender
{
    if (_start == NO) {
        
        _start = YES;
        
        if (_resume == YES)
        {
            _time = [NSDate timeIntervalSinceReferenceDate] - _resumeTime;
            NSLog(@"Resume elapsed time %@", [self minutesAndSeconds:_time]);
            _resume = NO;
        }
        else
        {
            _time = [NSDate timeIntervalSinceReferenceDate];
        }
        
        
        
        NSLog(@"Time %.2f", _time);
        
        [sender setTitle:@"STOP" forState:UIControlStateNormal];
        
        [self updateTime];
    }
    else
    {
        _start = NO;
        
        _resume = YES;
        
//        NSLog(@"RESUME TIME %@", [self minutesAndSeconds:_resumeTime]);
        
        [sender setTitle:@"START" forState:UIControlStateNormal];
    }
}

@end
