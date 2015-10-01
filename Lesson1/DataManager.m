//
//  DataManager.m
//  Lesson1
//
//  Created by Евгений Сергеев on 01.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "DataManager.h"
#import "Object.h"

@interface DataManager()

@property (strong, nonatomic, readwrite) KVOMutableArray *objects;

@end

@implementation DataManager

+ (instancetype)sharedInstance {
    static id _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _objects = [KVOMutableArray new];
    }
    return self;
}

- (Object *)objectAtIndex:(NSInteger)index {
    Object *object = self.objects[index];
    return [object copy];
}

- (void)saveObject:(Object *)object atIndex:(NSInteger)index {
    self.objects[index] = [object copy];
}

- (void)addObject:(Object *)object {
    [self.objects addObject:[object copy]];
}

- (void)deleteObjectAtIndex:(NSInteger)index {
    [self.objects removeObjectAtIndex:index];
}


@end

