//
//  JFFTask.m
//  TestThreads01
//
//  Created by admin on 11/11/14.
//  Copyright (c) 2014 home ltd. All rights reserved.
//

#import "JFFTask.h"

@implementation JFFTask

- (double)counterTo:(NSNumber *)finalNumber {
    NSInteger counter = 0;
    
    double test = 0.0;
    
    while (counter < finalNumber.integerValue) {
        counter++;
        
//        test += (counter * (-1^(counter%3)) );
    }
    
//    NSLog(@"%f", test);
    return test;
}

@end
