//
//  JFFTimeCounter.m
//  TestThreads01
//
//  Created by admin on 11/11/14.
//  Copyright (c) 2014 home ltd. All rights reserved.
//

#import "JFFTimeCounter.h"

@interface JFFTimeCounter ()

@property (strong) NSString *name;
@property (strong) NSDate *startDate;
@property (strong) NSDate *stopDate;

@end

@implementation JFFTimeCounter

- (instancetype)init {
    self = [super init];
    if (self) {
        [self start];
        self.stopDate = nil;
        self.name = nil;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)counterName {
    if (self.init) {
        self.name = counterName;
//        NSLog(@"start counter with name %@", counterName);
    }
    return self;
}

- (void)start {
    self.startDate = [NSDate date];
}

- (void)stop {
    self.stopDate = [NSDate date];
}

- (NSTimeInterval)getTimeIntervaStartToDate:(NSDate *)stopDate {
    NSTimeInterval timeInterval = [stopDate timeIntervalSinceDate:self.startDate];
    return timeInterval;
}

- (NSTimeInterval)getTimeIntervaStartToNow {
    NSTimeInterval timeInterval = [self getTimeIntervaStartToDate:[NSDate date]];
    return timeInterval;
}

- (NSTimeInterval)getTimeIntervaStartToFinish {
    NSTimeInterval timeInterval = [self getTimeIntervaStartToDate:self.stopDate];
    return timeInterval;
}


- (NSString *)makePrintStringForFinishDate:(NSDate *)stopDate {
    NSString *printPrefix = @"Timer :";
    if (self.name) {
        printPrefix = [NSString stringWithFormat:@"%@: ", self.name];
    }
    NSTimeInterval timeInterval = [self getTimeIntervaStartToDate:stopDate];
    
    NSString *print = [NSString stringWithFormat:@"%@%f", printPrefix, timeInterval];
    return print;
}

- (void)printTimeIntervaStartToNow {
    NSLog(@"%@", [self makePrintStringForFinishDate:[NSDate date]]);
}

- (void)printTimeIntervaStartToFinish {
    NSLog(@"%@", [self makePrintStringForFinishDate:self.stopDate]);
}

- (void)stopAndPrint {
    [self stop];
    [self printTimeIntervaStartToFinish];
}

- (NSString *)description {
    return [self makePrintStringForFinishDate:[NSDate date]];
}

@end
