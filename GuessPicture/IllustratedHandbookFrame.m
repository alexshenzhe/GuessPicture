//
//  IllustratedHandbookFrame.m
//  GuessPicture
//
//  Created by 沈喆 on 16/11/6.
//  Copyright © 2016年 沈喆. All rights reserved.
//

#import "IllustratedHandbookFrame.h"
#import "QuestionModel.h"

@implementation IllustratedHandbookFrame

- (void)setQuestionModel:(QuestionModel *)questionModel {
    _questionModel = questionModel;
    
    // 获取当前屏幕尺寸
    CGRect screenF = [UIScreen mainScreen].bounds;
    float viewW = screenF.size.width;
    float viewH = screenF.size.height;
    
    // ---------------------图鉴背景框---------------------
    float handbookW = (viewW * 4) / 5;
    float handbookH = (viewH * 2) / 3;
    float handbookX = (viewW - handbookW) / 2;
    float handbookY = (viewH - handbookH) / 2;
    _handbookFrame = CGRectMake(handbookX, handbookY, handbookW, handbookH);
    
    // ---------------------进化图片---------------------
    NSString *ImageName = _questionModel.evolution;
    
    // 为适应不同尺寸的图片
    float tempValue;
    
    // 判断字符串是否以1或2结尾，用于判断图片尺寸
    if ([ImageName hasSuffix:@"1"]) {
        tempValue = 2.5;
    } else if ([ImageName hasSuffix:@"2"]) {
        tempValue = 4.73;
    } else {
        tempValue = 7;
    }
    
    float imageH = handbookH / 4;
    float imageW = (imageH * tempValue) / 3;
    float imageX = (handbookW - imageW) * 0.5;
    float imageY = -20;
    _evolutionFrame = CGRectMake(imageX, imageY, imageW, imageH);
    
    // ---------------------显示名字---------------------
    float nameW = handbookW;
    float nameH = 30;
    float nameX = 0;
    float nameY = imageH + imageY;
    _nameFrame = CGRectMake(nameX, nameY, nameW, nameH);
    
    // ---------------------显示简介---------------------
    float introX = 30;
    float introY = nameY + nameH;
    float introW = handbookW - introX * 2;
    float introH = handbookH - introY - introX;
    
    _introFrame = CGRectMake(introX, introY, introW, introH);
}

@end
