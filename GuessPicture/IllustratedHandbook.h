//
//  IllustratedHandbook.h
//  GuessPicture
//
//  Created by 沈喆 on 16/10/3.
//  Copyright © 2016年 沈喆. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IllustratedHandbookFrame;
@interface IllustratedHandbook : UIView

- (instancetype)initWithCover:(UIButton *)cover handbookFrame:(IllustratedHandbookFrame *)handbookFrame;

+ (instancetype)illustratedHandbookWithCover:(UIButton *)cover handbookFrame:(IllustratedHandbookFrame *)handbookFrame;

@end
