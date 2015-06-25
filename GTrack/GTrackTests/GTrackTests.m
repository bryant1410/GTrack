//
//  GTrackTests.m
//  GTrack
//
//  Created by Michael Amaral on 2/5/15.
//  Copyright (c) 2015 Michael Amaral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GTTracker.h"

#define ARC4RANDOM_MAX 0x100000000
#define TEST_ITERATIONS 100

static NSString * const ALPHABET = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";

@interface GTrackTests : XCTestCase {
    GTTracker *_tracker;
}

@end

@implementation GTrackTests

- (void)setUp {
    [super setUp];

    _tracker = [GTTracker sharedInstance];
    _tracker.loggingEnabled = YES;
}

- (void)tearDown {
    _tracker.loggingEnabled = NO;
    _tracker = nil;

    [super tearDown];
}


#pragma mark - GTTracker

- (void)testStartAndEndAnalyticsSession {
    [_tracker startAnalyticsSession];

    XCTAssertTrue(_tracker.isSessionActive);

    [_tracker endAnalyticsSession];

    XCTAssertFalse(_tracker.isSessionActive);
}

/*
 We can't really test the results of the analytics event dispatching,
 but we can send them with various payloads and ensure they don't
 blow up.
*/

- (void)testEventWithCategory {
    [_tracker sendAnalyticsEventWithCategory:nil];
    [_tracker sendAnalyticsEventWithCategory:@""];
    [_tracker sendAnalyticsEventWithCategory:@"Test category"];
}

- (void)testEventWithCategoryAndAction {
    [_tracker sendAnalyticsEventWithCategory:nil action:nil];
    [_tracker sendAnalyticsEventWithCategory:@"" action:@""];
    [_tracker sendAnalyticsEventWithCategory:@"Test category" action:@"Test action"];
}

- (void)testEventWithCategoryActionAndLabel {
    [_tracker sendAnalyticsEventWithCategory:nil action:nil label:nil];
    [_tracker sendAnalyticsEventWithCategory:@"" action:@"" label:@""];
    [_tracker sendAnalyticsEventWithCategory:@"Test category" action:@"Test action" label:@"Test Label"];
}

- (void)testEventWithCategoryActionLabelAndValue {
    [_tracker sendAnalyticsEventWithCategory:nil action:nil label:nil value:nil];
    [_tracker sendAnalyticsEventWithCategory:@"" action:@"" label:@"" value:@0];
    [_tracker sendAnalyticsEventWithCategory:@"Test category" action:@"Test action" label:@"Test Label" value:@50];
}


#pragma mark - GTInterval

- (void)testIntervalPropertiesSet {
    for (NSInteger i = 0; i < TEST_ITERATIONS; i++) {
        GTInterval *interval = [GTInterval intervalWithNowAsStartDate];
        [interval end];
        
        XCTAssertNotNil(interval.startDate);
        XCTAssertNotNil(interval.endDate);
        XCTAssertGreaterThan(interval.timeInterval, kAnalyticsDefaultTimeInterval);
    }
}

- (void)testIntervalSecondsCalculation {
    for (NSInteger i = 0; i < TEST_ITERATIONS; i++) {
        NSTimeInterval secondsInFuture = [self randomIntervalBetween:1 and:300];
        
        GTInterval *interval = [GTInterval new];
        interval.startDate = [NSDate date];
        interval.endDate = [NSDate dateWithTimeInterval:secondsInFuture sinceDate:interval.startDate];
        
        NSTimeInterval calculatedSeconds = [[interval intervalAsSeconds] doubleValue];
        
        XCTAssertEqualWithAccuracy(calculatedSeconds, secondsInFuture, .1);
    }
}

- (void)testIntervalMinutesCalculation {
    for (NSInteger i = 0; i < TEST_ITERATIONS; i++) {
        NSTimeInterval secondsInFuture = [self randomIntervalBetween:1 and:60 * kAnalyticsSecondsPerMinute];
        NSTimeInterval minutesInFuture = secondsInFuture / kAnalyticsSecondsPerMinute;
        
        GTInterval *interval = [GTInterval new];
        interval.startDate = [NSDate date];
        interval.endDate = [NSDate dateWithTimeInterval:secondsInFuture sinceDate:interval.startDate];
        
        NSTimeInterval calculatedMinutes = [[interval intervalAsMinutes] doubleValue];
        
        XCTAssertEqualWithAccuracy(calculatedMinutes, minutesInFuture, .1);
    }
}

- (void)testIntervalHoursCalculation {
    for (NSInteger i = 0; i < TEST_ITERATIONS; i++) {
        NSTimeInterval secondsInFuture = [self randomIntervalBetween:1 and:5 * kAnalyticsSecondsPerHour];
        NSTimeInterval hoursInFuture = secondsInFuture / kAnalyticsSecondsPerHour;
        
        GTInterval *interval = [GTInterval new];
        interval.startDate = [NSDate date];
        interval.endDate = [NSDate dateWithTimeInterval:secondsInFuture sinceDate:interval.startDate];
        
        NSTimeInterval calculatedHours = [[interval intervalAsHours] doubleValue];
        
        XCTAssertEqualWithAccuracy(calculatedHours, hoursInFuture, .1);
    }
}


#pragma mark - GTTimedEvent

- (void)testTimedEvents {
    for (NSInteger i = 0; i < TEST_ITERATIONS; i++) {
        NSString *randomCategory = [self randomStringWithLength:5];
        NSString *randomAction = [self randomStringWithLength:5];
        NSString *randomLabel = [self randomStringWithLength:5];
        
        GTTimedEvent *timedEvent = [GTTimedEvent eventStartingNowWithCategory:randomCategory action:randomAction label:randomLabel];
        [timedEvent.eventInterval end];
        
        XCTAssertNotNil(timedEvent);
        XCTAssert([randomCategory isEqualToString:timedEvent.category]);
        XCTAssert([randomAction isEqualToString:timedEvent.action]);
        XCTAssert([randomLabel isEqualToString:timedEvent.label]);
        XCTAssertNotNil(timedEvent.eventInterval);
        XCTAssertGreaterThan(timedEvent.eventInterval.timeInterval, kAnalyticsDefaultTimeInterval);
    }
}


#pragma mark - Test Utils

- (NSTimeInterval)randomIntervalBetween:(NSTimeInterval)min and:(NSTimeInterval)max {
    return ((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min;
}

- (NSString *)randomStringWithLength:(NSInteger)length {
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (NSInteger i = 0; i < length; i++) {
        u_int32_t r = arc4random() % ALPHABET.length;
        unichar c = [ALPHABET characterAtIndex:r];
        [randomString appendFormat:@"%C", c];
    }
    
    return randomString;
}

@end

