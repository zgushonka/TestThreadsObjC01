//
//  JFFOperationBlockTest.m
//  TestThreads01
//
//  Created by oleksandr.buravlyov on 11/13/14.
//  Copyright (c) 2014 home ltd. All rights reserved.
//

#import "JFFBlockOperationTest.h"

#import "JFFTask.h"
#import "JFFTimeCounter.h"

@implementation JFFBlockOperationTest

- (void)performTask:(id)task times:(int)taskCount counterLimit:(int)counterLimit {
    JFFTimeCounter *globalConcurentTimeCounter = [[JFFTimeCounter alloc] initWithName:@"Global Concurent Block Operation Counter"];
    
    void (^taskBlock)(void) = ^{
        JFFTask *jffTask = (JFFTask *)task;
        [jffTask counterTo:@(counterLimit)];
    };
    
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{}];
    for (int i = 0; i < taskCount; i++) {
        [blockOperation addExecutionBlock:taskBlock];
    }
    
    __weak JFFBlockOperationTest *weakSelf = self;
    [blockOperation setCompletionBlock:^{
        weakSelf.complete = YES;
    }];
    
    [blockOperation start];
    [blockOperation waitUntilFinished];
    
    [globalConcurentTimeCounter stopAndPrint];
}

@end
