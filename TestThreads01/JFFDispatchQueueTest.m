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
    JFFTimeCounter *timeCounter = [[JFFTimeCounter alloc] initWithName:@"Serial Queue Counter"];
    self.complete = NO;
    
    dispatch_queue_t serialQueue = dispatch_queue_create("my serial queue", NULL);
    JFFTask *myTask = (JFFTask *)task;
    for (int i = 0; i < taskCount; i++) {
        
        __block JFFTimeCounter *blockTimeCounter = timeCounter;
        dispatch_async(serialQueue, ^{
            [myTask countWithWhileTo:@(counterLimit)];
            
            if (i == taskCount) {
                [blockTimeCounter stopAndPrint];
            }
            
        });
    }
    
    [self performSelector:@selector(setCompleteFlag) withObject:nil afterDelay:10];
    
    
    while (!self.complete) {
        //  wait
    }
    
    [timeCounter stopAndPrint];
    
}

- (void)performCalcInGloballQueueWithTask:(id)task times:(int)taskCount counterLimit:(int)counterLimit {
    JFFTimeCounter *timeCounter = [[JFFTimeCounter alloc] initWithName:@"Global concurrent Queue Counter"];
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [self placeTask:task asyncToQueue:globalQueue times:taskCount counterLimit:counterLimit];
    [timeCounter stopAndPrint];
}


- (void)placeTask:(id)task asyncToQueue:(dispatch_queue_t)queue times:(int)taskCount counterLimit:(int)counterLimit {
    JFFTask *myTask = (JFFTask *)task;
    for (int i = 0; i < taskCount; i++) {
        
        dispatch_async(queue, ^{
            [myTask countWithWhileTo:@(counterLimit)];
        });
    }
}

- (void)setCompleteFlag {
    self.complete = YES;
}

@end
