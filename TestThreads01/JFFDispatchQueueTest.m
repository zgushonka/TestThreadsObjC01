//
//  JFFDispatchQueueTest.m
//  TestThreads01
//
//  Created by oleksandr.buravlyov on 11/17/14.
//  Copyright (c) 2014 home ltd. All rights reserved.
//

#import "JFFDispatchQueueTest.h"

#import "JFFTask.h"
#import "JFFTimeCounter.h"


@interface JFFDispatchQueueTest ()
@property BOOL complete;
@end


@implementation JFFDispatchQueueTest

- (void)performCalcInSerialQueueWithTask:(id)task times:(int)taskCount counterLimit:(int)counterLimit {
    self.complete = NO;
    
    @autoreleasepool {
        JFFTimeCounter *timeCounter = [[JFFTimeCounter alloc] initWithName:@"Serial Queue Counter"];
        dispatch_queue_t serialQueue = dispatch_queue_create("my.serial.queue", NULL);
        if (!serialQueue) {
            NSLog(@"Error: serial Queue creation error");
            return;     //  !!! error exit point
        }
        
        [self placeTask:task asyncToQueue:serialQueue times:taskCount counterLimit:counterLimit];
        
        while (!self.complete) {
            //  wait
        }
        [timeCounter stopAndPrint];
    }
}

- (void)performCalcInGloballQueueWithTask:(id)task times:(int)taskCount counterLimit:(int)counterLimit {
    self.complete = NO;
    
    @autoreleasepool {
        JFFTimeCounter *timeCounter = [[JFFTimeCounter alloc] initWithName:@"GlobalQueue concurrent Counter"];
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        if (!globalQueue) {
            NSLog(@"Error: global Queue creation error");
            return;     //  !!! error exit point
        }
        
        [self placeTask:task asyncToQueue:globalQueue times:taskCount counterLimit:counterLimit];
        
        while (!self.complete) {
            //  wait
        }
        [timeCounter stopAndPrint];
    }
}


- (void)placeTask:(id)task asyncToQueue:(dispatch_queue_t)queue times:(int)taskCount counterLimit:(int)counterLimit {
    JFFTask *myTask = (JFFTask *)task;
    @autoreleasepool {
        for (int i = 0; i < taskCount; i++) {
            __weak id weakSelf = self;
            dispatch_async(queue, ^{
                [myTask countWithWhileTo:@(counterLimit)];
                
                //  Completion Task
                if (i == taskCount-1) {
                    [weakSelf performSelectorInBackground:@selector(setCompleteFlag) withObject:nil];
                }
                
            });
        }
    }
}

- (void)setCompleteFlag {
    self.complete = YES;
}

@end
