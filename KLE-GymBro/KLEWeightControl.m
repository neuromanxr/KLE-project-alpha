//
//  KLEWeightControl.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/15/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEWeightControl.h"

@interface KLEWeightControl ()

@property (nonatomic, copy) NSArray *weightIncrementNumbers;

- (IBAction)weightIncrementSliderAction:(UISlider *)sender;
- (IBAction)increaseWeightAction:(UIButton *)sender;
- (IBAction)decreaseWeightAction:(UIButton *)sender;


@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation KLEWeightControl

- (void)awakeFromNib
{
    [[NSBundle mainBundle] loadNibNamed:@"KLEWeightControl" owner:self options:nil];
    
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.contentView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    [self setupWeightSlider];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupWeightSlider
{
    _weightIncrementNumbers = @[@(2.5), @(5), @(10), @(25), @(35), @(45)];
    NSUInteger numberOfSteps = [_weightIncrementNumbers count] - 1;
    
    _weightIncrementSlider.maximumValue = numberOfSteps;
    _weightIncrementSlider.minimumValue = 0;
    [_weightIncrementSlider setValue:_weightIncrementSlider.minimumValue];
    [_weightIncrementSlider setMaximumTrackTintColor:[UIColor redColor]];
    _weightIncrementSlider.continuous = YES;
    
    
}

- (void)weightValueChanged:(UISlider *)sender
{
    // round the slider position to the nearest index of the weight increment numbers array
    NSUInteger index = _weightIncrementSlider.value + 0.5;
    [_weightIncrementSlider setValue:index animated:NO];
    NSNumber *number = [_weightIncrementNumbers objectAtIndex:index];
    
    _weightIncrementLabel.text = [NSString stringWithFormat:@"%@", number];
    
    NSLog(@"~~SLIDERINDEX: %lu", index);
    NSLog(@"~~number: %@", number);
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    NSLog(@"BEGAN EDITING");
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    NSLog(@"END EDITING");
//    _selectedRoutineExercise.weight = [NSNumber numberWithInteger:[_weightTextField.text integerValue]];
//    NSLog(@"NEW WEIGHT %@", _selectedRoutineExercise.weight);
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}

- (IBAction)weightIncrementSliderAction:(UISlider *)sender
{
    // round the slider position to the nearest index of the weight increment numbers array
    NSUInteger index = _weightIncrementSlider.value + 0.5;
    [_weightIncrementSlider setValue:index animated:NO];
    NSNumber *number = [_weightIncrementNumbers objectAtIndex:index];
    
    _weightIncrementLabel.text = [NSString stringWithFormat:@"%@", number];
    
    NSLog(@"~~SLIDERINDEX: %lu", index);
    NSLog(@"~~number: %@", number);
}

- (IBAction)increaseWeightAction:(UIButton *)sender
{
    CGFloat weightChangeValue = [_weightIncrementLabel.text floatValue];
    CGFloat weightTextFieldValue = [_weightTextField.text floatValue];
    
    weightTextFieldValue += weightChangeValue;
    
    _weightTextField.text = [NSString stringWithFormat:@"%.2f", weightTextFieldValue];
    
    NSLog(@"WEIGHT TEXT FIELD VALUE %.f", weightTextFieldValue);
}

- (IBAction)decreaseWeightAction:(UIButton *)sender
{
    CGFloat weightChangeValue = [_weightIncrementLabel.text floatValue];
    
    if ([_weightTextField.text floatValue] >= weightChangeValue)
    {
        CGFloat weightTextFieldValue = [_weightTextField.text floatValue];
        weightTextFieldValue -= weightChangeValue;
        
        _weightTextField.text = [NSString stringWithFormat:@"%.2f", weightTextFieldValue];
    }
    else
    {
        NSLog(@"CHANGE VALUE IS GREATER THAN THE WEIGHT VALUE");
    }
}
@end
