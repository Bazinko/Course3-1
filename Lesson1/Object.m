//
//  Object.m
//  Lesson1
//
//  Created by Евгений Сергеев on 01.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "Object.h"

@implementation Object

- (instancetype)initWithNumber:(NSInteger)number text:(NSString *)text {
    self = [super init];
    if (self) {
        _number = number;
        _text = text;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    Object *object = [[[self class] allocWithZone:zone] init];
    object->_number = _number;
    object->_text = [_text copyWithZone:zone];
    return object;
}

@end

