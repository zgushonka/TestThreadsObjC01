//
//  JFFDispatchQueueTest.h
//  TestThreads01
//
//  Created by oleksandr.buravlyov on 11/17/14.
//  Copyright (c) 2014 home ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFFDispatchQueueTest : NSObject

- (void)performCalcInSerialQueueWithTask:(id)task times:(int)taskCount counterLimit:(int)counterLimit;
- (void)performCalcInGloballQueueWithTask:(id)task times:(int)taskCount counterLimit:(int)counterLimit;

@end
