//
//  QuestionModel.m
//  GuessPicture
//
//  Created by 沈喆 on 16/7/15.
//  Copyright © 2016年 沈喆. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)questionWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
