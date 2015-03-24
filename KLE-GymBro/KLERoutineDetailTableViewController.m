//
//  KLERoutineDetailTableViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/15/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEUtility.h"
#import "KLERoutineDetailTableViewController.h"
#import "KLERoutine.h"

@interface KLERoutineDetailTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *routineNameTextField;

@end

@implementation KLERoutineDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _routineNameTextField.delegate = self;
    
    // custom title for navigation title
    NSAttributedString *attribString = [[NSAttributedString alloc] initWithString:_selectedRoutine.routinename attributes:@{ NSFontAttributeName : [KLEUtility getFontFromFontFamilyWithSize:18.0], NSUnderlineStyleAttributeName : @0, NSBackgroundColorAttributeName : [UIColor clearColor] }];
    // custom title for navigation title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.numberOfLines = 0;
    title.attributedText = attribString;
    [title sizeToFit];
    [self.navigationItem setTitleView:title];
    
    _routineNameTextField.text = _selectedRoutine.routinename;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 18 && range.length == 0) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"BEGAN EDITING");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"END EDITING");
    
    _selectedRoutine.routinename = self.routineNameTextField.text;
    self.routineNameTextField.placeholder = _selectedRoutine.routinename;
    
    // custom title for navigation title
    NSAttributedString *attribString = [[NSAttributedString alloc] initWithString:_selectedRoutine.routinename attributes:@{ NSFontAttributeName : [KLEUtility getFontFromFontFamilyWithSize:18.0], NSUnderlineStyleAttributeName : @0, NSBackgroundColorAttributeName : [UIColor clearColor] }];
    // custom title for navigation title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.numberOfLines = 0;
    title.attributedText = attribString;
    [title sizeToFit];
    [self.navigationItem setTitleView:title];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
