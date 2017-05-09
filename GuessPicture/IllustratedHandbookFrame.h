//
//  IllustratedHandbookFrame.h
//  GuessPicture
//
//  Created by 沈喆 on 16/11/6.
//  Copyright © 2016年 沈喆. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class QuestionModel;
@interface IllustratedHandbookFrame : NSObject

@property (nonatomic, assign, readonly) CGRect handbookFrame;
@property (nonatomic, assign, readonly) CGRect evolutionFrame;
@property (nonatomic, assign, readonly) CGRect nameFrame;
@property (nonatomic, assign, readonly) CGRect introFrame;

@property (nonatomic, strong) QuestionModel *questionModel;
@end
