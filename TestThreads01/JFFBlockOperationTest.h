//
//  JFFOperationBlockTest.h
//  TestThreads01
//
//  Created by oleksandr.buravlyov on 11/13/14.
//  Copyright (c) 2014 home ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFFBlockOperationTest : NSObject
@property BOOL complete;

- (void)performTask:(id)task times:(int)taskCount counterLimit:(int)counterLimit;

@end
