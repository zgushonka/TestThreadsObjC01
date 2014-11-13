//
//  main.m
//  TestThreads01
//
//  Created by admin on 11/11/14.
//  Copyright (c) 2014 home ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JFFTask.h"
#import "JFFTimeCounter.h"
#import "JFFConcurentTaskPerformer.h"
#import "JFFBlockOperationTest.h"

void performSerialTask(int taskCount, int counterLimit);
void performConcurentInvocationOperationTask(int taskCount, int counterLimit);
void performConcurentBlocksTask(int taskCount, int counterLimit);
void performOperationArrayTask(int taskCount, int counterLimit);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        const int taskCount = 100;
        const int counterLimit = 10000000;
        
        NSLog(@"Start");
        NSLog(@"Task parameters. taskCount - %i, counterLimit - %i", taskCount, counterLimit);
        
#ifdef DEBUG
        NSLog(@"Debug mode");
#else
        NSLog(@"Release mode");
#endif
        
        performSerialTask(taskCount, counterLimit);
        performConcurentInvocationOperationTask(taskCount, counterLimit);
        performConcurentBlocksTask(taskCount, counterLimit);
        performOperationArrayTask(taskCount, counterLimit);
        
        JFFConcurentTaskPerformer *concurentTaskPerformer = [[JFFConcurentTaskPerformer alloc] init];
        [concurentTaskPerformer performTask:[[JFFTask alloc] init] times:taskCount counterLimit:counterLimit];
        
        JFFBlockOperationTest *blockOperationTest = [[JFFBlockOperationTest alloc] init];
        [blockOperationTest performTask:[[JFFTask alloc] init] times:taskCount counterLimit:counterLimit];
        
        NSLog(@"Finish");
    }
    
    return 0;
}



void performSerialTask(int taskCount, int counterLimit) {
    JFFTimeCounter *globalSerialTimeCounter = [[JFFTimeCounter alloc] initWithName:@"Global Serial Counter"];
    JFFTask *task01 = [[JFFTask alloc] init];
    
    NSTimeInterval averageTaskTime = 0;
    
    //  serial tasks
    for (NSInteger i = 0; i < taskCount; i++) {
//        NSLog(@"start %li tast of %i", i, taskCount);
        JFFTimeCounter *localSerialCounter = [[JFFTimeCounter alloc] initWithName:@"Local Serial Counter"];
        [task01 counterTo:@(counterLimit)];
        averageTaskTime += [localSerialCounter getTimeIntervaStartToNow];
//        [localSerialCounter stopAndPrint];
    }
    
    averageTaskTime /= taskCount;
    NSLog(@"Task average time: %f", averageTaskTime);
    
    [globalSerialTimeCounter stopAndPrint];
}



void performConcurentInvocationOperationTask(int taskCount, int counterLimit) {
    JFFTimeCounter *globalConcurentTimeCounter = [[JFFTimeCounter alloc] initWithName:@"Global Concurent InvocationOperation Counter"];
    JFFTask *task01 = [[JFFTask alloc] init];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    for (NSInteger i = 0; i < taskCount; i++) {
        NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:task01 selector:@selector(counterTo:) object:@(counterLimit)];
        [queue addOperation:invocationOperation];
    }
    [queue waitUntilAllOperationsAreFinished];
    
    [globalConcurentTimeCounter stopAndPrint];
}



void performConcurentBlocksTask(int taskCount, int counterLimit) {
    JFFTimeCounter *globalConcurentTimeCounter = [[JFFTimeCounter alloc] initWithName:@"Global Concurent Blocks Counter"];
    JFFTask *task01 = [[JFFTask alloc] init];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    for (NSInteger i = 0; i < taskCount; i++) {
        
        [queue addOperationWithBlock:^{
            [task01 counterTo:@(counterLimit)];
        }];
    }
    [queue waitUntilAllOperationsAreFinished];
    
    [globalConcurentTimeCounter stopAndPrint];
}




void performOperationArrayTask(int taskCount, int counterLimit) {
    JFFTimeCounter *globalConcurentTimeCounter = [[JFFTimeCounter alloc] initWithName:@"Global Concurent Operation Array Counter"];
    JFFTask *task01 = [[JFFTask alloc] init];
    
    NSMutableArray *operationArray = [NSMutableArray array];
    for (NSInteger i = 0; i < taskCount; i++) {
        NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:task01 selector:@selector(counterTo:) object:@(counterLimit)];
        [operationArray addObject:invocationOperation];
    }
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:operationArray waitUntilFinished:YES];
    
    [globalConcurentTimeCounter stopAndPrint];
}



