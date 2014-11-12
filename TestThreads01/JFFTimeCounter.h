//
//  JFFTimeCounter.h
//  TestThreads01
//
//  Created by admin on 11/11/14.
//  Copyright (c) 2014 home ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFFTimeCounter : NSObject

- (instancetype)init;
- (instancetype)initWithName:(NSString *)counterName;

- (void)start;
- (void)stop;
- (void)stopAndPrint;

- (NSTimeInterval)getTimeIntervaStartToNow;
- (NSTimeInterval)getTimeIntervaStartToFinish;

- (void)printTimeIntervaStartToNow;
- (void)printTimeIntervaStartToFinish;

@end
