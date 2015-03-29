//
//  KLEWeightControl.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/15/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//
#import "KLEUtility.h"
#import "KLEWeightControl.h"

#define ONLY_NUMBERS @"0123456789."

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

    [self setupTextFieldRightLabel];
    [self updateWeightUnit];
    
    self.weightTextField.delegate = self;
    [self.weightTextField setKeyboardType:UIKeyboardTypeDecimalPad];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    
    if (newWindow == nil) {
        
        NSLog(@"WINDOW IS NIL %@", newWindow);
    }
}

- (void)didMoveToWindow
{
    
    if (self.window) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWeightUnit) name:kWeightUnitChangedNote object:nil];
        NSLog(@"OBSERVER ADDED");
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWeightUnitChangedNote object:nil];
    NSLog(@"OBSERVER REMOVED");
}

- (void)updateWeightUnit
{
    NSLog(@"UPDATE WEIGHT UNIT");
    if ([[KLEUtility weightUnitType] isEqualToString:kUnitPounds])
    {
        _weightIncrementNumbers = @[@(1.0), @(2.5), @(5), @(10), @(25), @(35), @(45)];
        _rightWeightLabel.text = kUnitPounds;
        
        NSLog(@"WEIGHT TEXT LB %@", _weightTextField.text);
    }
    else
    {
        _weightIncrementNumbers = @[@(0.5), @(1.0), @(1.5), @(2.0), @(2.5), @(5.0), @(10.0), @(15.0), @(20.0), @(25.0)];
        _rightWeightLabel.text = kUnitKilograms;

        NSLog(@"WEIGHT TEXT KG %@", _weightTextField.text);
    }
    
    NSUInteger numberOfSteps = [_weightIncrementNumbers count] - 1;
    
    _weightIncrementSlider.maximumValue = numberOfSteps;
    _weightIncrementSlider.minimumValue = 0;
    [_weightIncrementSlider setValue:_weightIncrementSlider.minimumValue];
    [_weightIncrementLabel setText:[NSString stringWithFormat:@"%@", [_weightIncrementNumbers firstObject]]];

}

- (void)setupTextFieldRightLabel
{
    // weight unit label
    _rightWeightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    [_rightWeightLabel setFont:[KLEUtility getFontFromFontFamilyWithSize:16.0]];
    [_rightWeightLabel setTextColor:[UIColor kPrimaryColor]];
    _rightWeightLabel.text = [KLEUtility weightUnitType];
    [_weightTextField setRightViewMode:UITextFieldViewModeAlways];
    [_weightTextField setRightView:_rightWeightLabel];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"TEXTFIELD CS");
    if (textField) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ONLY_NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // don't allow text input
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"WEIGHT CONTROL BEGAN EDITING");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"WEIGHT CONTROL END EDITING");

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)setupWeightSlider
{
    if ([[KLEUtility weightUnitType] isEqualToString:kUnitPounds])
    {
        _weightIncrementNumbers = @[@(1.0), @(2.5), @(5), @(10), @(25), @(35), @(45)];
    }
    else
    {
        _weightIncrementNumbers = @[@(0.5), @(1.0), @(1.5), @(2.0), @(2.5), @(5.0), @(10.0), @(15.0), @(20.0), @(25.0)];
    }
    
    NSUInteger numberOfSteps = [_weightIncrementNumbers count] - 1;
    
    _weightIncrementSlider.maximumValue = numberOfSteps;
    _weightIncrementSlider.minimumValue = 0;
    [_weightIncrementSlider setValue:_weightIncrementSlider.minimumValue];
    [_weightIncrementLabel setText:[NSString stringWithFormat:@"%@", [_weightIncrementNumbers firstObject]]];
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
    
//    NSLog(@"~~SLIDERINDEX: %lu", index);
//    NSLog(@"~~number: %@", number);
}

- (IBAction)weightIncrementSliderAction:(UISlider *)sender
{
    // round the slider position to the nearest index of the weight increment numbers array
    NSUInteger index = _weightIncrementSlider.value + 0.5;
    [_weightIncrementSlider setValue:index animated:NO];
    NSNumber *number = [_weightIncrementNumbers objectAtIndex:index];
    
    _weightIncrementLabel.text = [NSString stringWithFormat:@"%@", number];
    
//    NSLog(@"~~SLIDERINDEX: %lu", index);
//    NSLog(@"~~number: %@", number);
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
- (IBAction)clearWeightButtonAction:(UIButton *)sender
{
    _weightTextField.text = [NSString stringWithFormat:@"%.2f", 0.0];
}
@end
