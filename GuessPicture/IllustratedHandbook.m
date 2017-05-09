//
//  IllustratedHandbook.m
//  GuessPicture
//
//  Created by 沈喆 on 16/10/3.
//  Copyright © 2016年 沈喆. All rights reserved.
//

#import "IllustratedHandbook.h"
#import "IllustratedHandbookFrame.h"
#import "QuestionModel.h"

@interface IllustratedHandbook ()

@property (nonatomic, strong) UIView *illustratedHandbookView; // 图鉴View
@property (nonatomic, strong) UIImageView *evolutionImageView; // 进化的图片
@property (nonatomic, strong) UILabel *nameLabel; // 名字的Label
@property (nonatomic , strong) UITextView *introText; // 简介

@end

@implementation IllustratedHandbook

- (instancetype)initWithCover:(UIButton *)cover handbookFrame:(IllustratedHandbookFrame *)handbookFrame {
    if (self = [super init]) {
        // ---------------------创建图鉴背景框---------------------
        UIView *illustratedHandbookView = [[UIView alloc] init];
        illustratedHandbookView.backgroundColor = [UIColor whiteColor];
        // 设置圆角半径
        illustratedHandbookView.layer.cornerRadius = 3.5;
        
        // 将图鉴view添加到阴影view中
        [cover addSubview:illustratedHandbookView];
        self.illustratedHandbookView = illustratedHandbookView;
        
        // ---------------------显示进化介绍---------------------
        UIImageView *evolutionImageView = [[UIImageView alloc] init];
        [illustratedHandbookView addSubview:evolutionImageView];
        self.evolutionImageView = evolutionImageView;
        
        // ---------------------显示名字---------------------
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:20];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setTextColor:[UIColor blackColor]];
        
        [illustratedHandbookView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // ---------------------显示简介---------------------
        UITextView *introText = [[UITextView alloc] init];
        introText.font = [UIFont systemFontOfSize:15];
        introText.editable = NO;
        introText.selectable = NO;
        [introText setTextAlignment:NSTextAlignmentLeft];
        [introText setTextColor:[UIColor blackColor]];
        [introText setBackgroundColor:[UIColor clearColor]];
    
        [illustratedHandbookView addSubview:introText];
        self.introText = introText;
        
        // 设置Frame和数据
        [self settingFrameWithHandbookFrame:handbookFrame];
        [self settingDataWithHandbookFrame:handbookFrame];
    }

    return self;
}

/**
 *  设置数据
 */
- (void)settingDataWithHandbookFrame:(IllustratedHandbookFrame *)handbookFrame {
    // 设置进化图片
    [self.evolutionImageView setImage:[UIImage imageNamed:handbookFrame.questionModel.evolution]];
    
    // 设置名字
    self.nameLabel.text = handbookFrame.questionModel.answer;
    
    // 设置简介
    self.introText.text = handbookFrame.questionModel.intro;
}

/**
 *  设置Frame
 */
- (void)settingFrameWithHandbookFrame:(IllustratedHandbookFrame *)handbookFrame {
    // 设置图鉴Frame
    self.illustratedHandbookView.frame = handbookFrame.handbookFrame;
    
    // 设置进化Frame
    self.evolutionImageView.frame = handbookFrame.evolutionFrame;
    
    // 设置名字Frame
    self.nameLabel.frame = handbookFrame.nameFrame;
    
    // 设置简介Frame
    self.introText.frame = handbookFrame.introFrame;
}


/**
 *  类方法
 */
+ (instancetype)illustratedHandbookWithCover:(UIButton *)cover handbookFrame:(IllustratedHandbookFrame *)handbookFrame {
    return [[self alloc] initWithCover:cover handbookFrame:handbookFrame];
}

//// 计算文本尺寸
//- (CGSize)sizeWithFont:(UIFont *)font text:(NSString *)text maxSize:(CGSize)maxSize {
//    NSDictionary *attrs = @{NSFontAttributeName : font};
//    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//}

@end
