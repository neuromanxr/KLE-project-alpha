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

@property (assign, nonatomic) NSTimeInterval beginTime;

@property (assign, nonatomic) NSTimeInterval timeElapsed;

@property (nonatomic) BOOL timerStart;

@property (nonatomic) BOOL timerResume;

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
    
    _timerStart = NO;
    _timerResume = NO;
}

- (NSString *)minutesAndSecondsFromTimeInterval:(NSTimeInterval)time
{
    // minutes in elapsed
    int minutes = (int)(time / 60.0);
    
    int seconds = (int)(time = time - (minutes * 60));
    
    NSString *timerString = [NSString stringWithFormat:@"%u:%02u", minutes, seconds];
    
    return timerString;
}

- (void)updateTime
{
    // timer is paused
    if (_timerStart == NO) {
        return;
    }
    // get the current time interval
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    
    // calculate elapsed time by subtracting starting time interval
    NSTimeInterval elapsedTime = currentTime - _beginTime;
    NSLog(@"ELAPSED TIME: %.2f", elapsedTime);
    
    // for pausing and resuming time
    _timeElapsed = elapsedTime;
    
    // format the time interval to minutes and seconds
    _timer.text = [self minutesAndSecondsFromTimeInterval:elapsedTime];
    
    // recursion
    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.1];
}

- (IBAction)timerButtonAction:(UIButton *)sender
{
    if (_timerStart == NO) {
        
        _timerStart = YES;
        
        // for pausing the timer
        if (_timerResume == YES)
        {
            // new begin time by subtracting the elapsed time
            _beginTime = [NSDate timeIntervalSinceReferenceDate] - _timeElapsed;
            _timerResume = NO;
        }
        else
        {
            // timer first started
            _beginTime = [NSDate timeIntervalSinceReferenceDate];
        }
        
        [sender setTitle:@"||" forState:UIControlStateNormal];
        
        [self updateTime];
    }
    else
    {
        _timerStart = NO;
        
        // pause timer
        _timerResume = YES;
        
        [sender setTitle:@">" forState:UIControlStateNormal];
    }
}

- (IBAction)resetTimerButtonAction:(UIButton *)sender
{
    _timerStart = NO;
    _timerResume = NO;
    _beginTime = [NSDate timeIntervalSinceReferenceDate];
    _timer.text = [self minutesAndSecondsFromTimeInterval:_beginTime - _beginTime];
}

@end
