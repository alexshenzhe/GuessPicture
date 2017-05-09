//
//  QuestionModel.h
//  GuessPicture
//
//  Created by 沈喆 on 16/7/15.
//  Copyright © 2016年 沈喆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject

@property (nonatomic, copy) NSString *answer; // 答案
@property (nonatomic, copy) NSString *icon; // 图标
@property (nonatomic, copy) NSArray *attribute; // 属性
@property (nonatomic, copy) NSString *intro; // 简介
@property (nonatomic, copy) NSString *evolution; // 进化
@property (nonatomic, strong) NSArray *options; // 选项

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)questionWithDict:(NSDictionary *)dict;

@end
