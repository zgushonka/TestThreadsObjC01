//
//  JFFConcurrentTaskPerformer.m
//  TestThreads01
//
//  Created by oleksandr.buravlyov on 11/12/14.
//  Copyright (c) 2014 home ltd. All rights reserved.
//

#import "JFFConcurrentTaskPerformer.h"

#import "JFFTask.h"
#import "JFFTimeCounter.h"


@interface JFFConcurrentTaskPerformer ()
@property BOOL complete;
@end


@implementation JFFConcurrentTaskPerformer

- (void)performTask:(id)task times:(int)taskCount counterLimit:(int)counterLimit {
    self.complete = NO;
    JFFTimeCounter *globalConcurrentTimeCounter = [[JFFTimeCounter alloc] initWithName:@"Concurrent Operation Array With Callback Counter"];
    
    NSMutableArray *operationArray = [NSMutableArray array];
    for (NSInteger i = 0; i < taskCount; i++) {
        NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:task selector:@selector(countWithWhileTo:) object:@(counterLimit)];
        [operationArray addObject:invocationOperation];
        
    }
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:operationArray waitUntilFinished:NO];
    [queue addObserver:self forKeyPath:@"operations" options:0 context:(__bridge void *)(globalConcurrentTimeCounter)];
    [queue waitUntilAllOperationsAreFinished];
    
    while (!self.complete) {
        //  wait callback function
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"operations"]) {
        NSOperationQueue *queue = (NSOperationQueue *)object;
        if ([queue.operations count] == 0) {
            JFFTimeCounter *globalConcurrentTimeCounter = (__bridge JFFTimeCounter *)context;
            [globalConcurrentTimeCounter stopAndPrint];
            self.complete = YES;
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}

@end


