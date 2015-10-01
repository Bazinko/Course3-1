//
//  Object.h
//  Lesson1
//
//  Created by Евгений Сергеев on 01.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Object : NSObject

@property (assign, nonatomic) NSInteger number;
@property (strong, nonatomic) NSString *text;

- (instancetype)initWithNumber:(NSInteger)number text:(NSString *)text;

@end
