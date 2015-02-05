//
//  DemoBViewController.m
//  GTrack
//
//  Created by Michael Amaral on 2/5/15.
//  Copyright (c) 2015 Michael Amaral. All rights reserved.
//

#import "DemoBViewController.h"
#import "GTTracker.h"

@interface DemoBViewController () {
    GTTracker *_tracker;
    
    BOOL _hasUnsavedChanges;
    GTInterval *_formInterval;
    
    UITextField *_favoriteColorField;
}

@end

@implementation DemoBViewController


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tracker = [GTTracker sharedInstance];
    
    // Setup the view for the demo.
    [self setupView];
}

- (void)setupView {
    self.title = @"View Controller B";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(handleCancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(handleSubmit)];
    
    _favoriteColorField = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, CGRectGetWidth(self.view.frame) - 20, 30)];
    _favoriteColorField.placeholder = @"Enter your favorite color...";
    _favoriteColorField.delegate = self;
    [self.view addSubview:_favoriteColorField];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_favoriteColorField becomeFirstResponder];
    
    // Now that the view has appeared, send an analytics screen event.
    [_tracker sendScreenEventWithTitle:@"View Controller B"];
    
    // There are multiple events we want to time from when the view first
    // appears, so lets create a GTInterval instance, starting now, that
    // we can use to track them.
    _formInterval = [GTInterval intervalWithNowAsStartDate];
}


#pragma mark - Actions


- (void)handleCancel {
    // If they have unsaved changes, ask them if they are sure.
    if (_hasUnsavedChanges) {
        [[[UIAlertView alloc] initWithTitle:@"Are You Sure?" message:@"You have unsaved changes, are you sure you want to cancel?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"No", nil] show];
    }
    
    // Otherwise they haven't made any changes...
    else {
        // End the interval.
        [_formInterval end];
        
        // Send an event associated with this form submission, identifying that the process was cancelled without changes
        // by the user, and attach the interval's seconds as the value for the event.
        [_tracker sendAnalyticsEventWithCategory:@"View Controller B Form Submission" action:@"Cancelled w/o Changes" label:@"Duration (seconds)" value:_formInterval.intervalAsSeconds];
        
        [self goBack];
    }
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSubmit {
    // Ensure they entered something into the field.
    if ([_favoriteColorField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please enter your favorite color." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    // End the interval.
    [_formInterval end];
    
    // Send another event associated with this form submission, identifying that the process was completed successfully
    // by the user, and attach their entry as the label, and the interval's seconds as the value.
    [_tracker sendAnalyticsEventWithCategory:@"View Controller B Form Submission" action:@"Completed - Favorite Color" label:_favoriteColorField.text value:_formInterval.intervalAsSeconds];
    
    [[[UIAlertView alloc] initWithTitle:@"Success!" message:@"Your favorite color has been saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    [self goBack];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // End the interval.
        [_formInterval end];
        
        // Send an analytics event associated with this form submission, identifying that the process was cancelled with changes made
        // and attach the interval's seconds as the value for the event.
        [_tracker sendAnalyticsEventWithCategory:@"View Controller B Form Submission" action:@"Cancelled with Changes" label:@"Duration (seconds)" value:_formInterval.intervalAsSeconds];
        
        [self goBack];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    _hasUnsavedChanges = YES;
    
    return YES;
}

@end
