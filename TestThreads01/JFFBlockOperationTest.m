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

@interface JFFBlockOperationTest()
@property NSBlockOperation *blockOperation;
@end

@implementation JFFBlockOperationTest

- (void)performTask:(id)task times:(int)taskCount counterLimit:(int)counterLimit {
    
    JFFTimeCounter *globalConcurentTimeCounter = [[JFFTimeCounter alloc] initWithName:@"Global Concurent Block Operation Counter"];
    
    self.blockOperation = nil;
    
    for (int i = 0; i < taskCount; i++) {
        
        void (^taskBlock)(void) = ^{
            JFFTask *jffTask = (JFFTask *)task;
            [jffTask counterTo:@(counterLimit)];
        };
        
        if (!self.blockOperation) {
            self.blockOperation = [NSBlockOperation blockOperationWithBlock:taskBlock];
            
            __weak JFFBlockOperationTest *weakSelf = self;
            [self.blockOperation setCompletionBlock:^{
                weakSelf.complete = YES;
            }];
        } else {
            [self.blockOperation addExecutionBlock:taskBlock];
        }
    }
    
    [self.blockOperation start];
    
    while (!self.complete) {
        //  wait
    }
    
    [globalConcurentTimeCounter stopAndPrint];
    
}

@end
