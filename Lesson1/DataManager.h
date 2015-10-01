//
//  DataManager.h
//  Lesson1
//
//  Created by Евгений Сергеев on 01.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KVOMutableArray+ReactiveCocoaSupport.h>
#import "Object.h"

@interface DataManager : NSObject

+ (instancetype)sharedInstance;

@property (strong, nonatomic, readonly) KVOMutableArray *objects;

- (Object *)objectAtIndex:(NSInteger)index;
- (void)addObject:(Object *)object;
- (void)deleteObjectAtIndex:(NSInteger)index;
- (void)saveObject:(Object *)object atIndex:(NSInteger)index;

@end

