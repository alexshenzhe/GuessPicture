//
//  InfoViewController.m
//  GuessPicture
//
//  Created by 沈喆 on 16/11/17.
//  Copyright © 2016年 沈喆. All rights reserved.
//

#import "InfoViewController.h"
// 正文的字体
#define TextFont [UIFont systemFontOfSize:15]
@interface InfoViewController ()
- (IBAction)backButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 使文字从第一行开始显示
-(void)viewDidAppear:(BOOL)animated{
    [_textView setContentOffset:CGPointZero animated:YES];
}

// 计算文本尺寸
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
