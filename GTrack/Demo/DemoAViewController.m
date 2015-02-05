//
//  DemoAViewController.m
//  GTrack
//
//  Created by Michael Amaral on 2/5/15.
//  Copyright (c) 2015 Michael Amaral. All rights reserved.
//

#import "DemoAViewController.h"
#import "DemoBViewController.h"
#import "GTTracker.h"

@interface DemoAViewController () {
    UILabel *_sliderValueLabel;
    UISlider *_favoriteNumberSlider;
}

@end

@implementation DemoAViewController


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup the view for the demo.
    [self setupView];
}

- (void)setupView {
    self.title = @"View Controller A";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(handleNext)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _sliderValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, CGRectGetWidth(self.view.frame) - 20, 20)];
    _sliderValueLabel.text = @"Use the slider to enter your favorite number.";
    [self.view addSubview:_sliderValueLabel];
    
    _favoriteNumberSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_sliderValueLabel.frame) + 20, CGRectGetWidth(self.view.frame) - 20, 50)];
    _favoriteNumberSlider.minimumValue = 0;
    _favoriteNumberSlider.maximumValue = 100;
    [_favoriteNumberSlider addTarget:self action:@selector(handleSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_favoriteNumberSlider];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Save Your Favorite Number" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(10, CGRectGetMaxY(_favoriteNumberSlider.frame) + 20, CGRectGetWidth(self.view.frame) - 20, 50)];
    [button addTarget:self action:@selector(handleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Now that the view has appeared, send an analytics screen event.
    [[GTTracker sharedInstance] sendScreenEventWithTitle:@"View Controller A"];
}


#pragma mark - Actions

- (void)handleButtonPressed {
    // Send an analytics event associated with this controller, attaching the value of the slider indicating their favorite number.
    [[GTTracker sharedInstance] sendAnalyticsEventWithCategory:@"View Controller A" action:@"Button Pressed" label:@"Favorite Number" value:@(roundf(_favoriteNumberSlider.value))];
    
    [[[UIAlertView alloc] initWithTitle:@"Success!" message:@"Your favorite number has been saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)handleNext {
    [self.navigationController pushViewController:[DemoBViewController new] animated:YES];
}

- (void)handleSliderValueChanged:(UISlider *)slider {
    _sliderValueLabel.text = [NSString stringWithFormat:@"Your favorite number: %@", @(roundf(slider.value))];
}

@end
