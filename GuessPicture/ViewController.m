//
//  ViewController.m
//  GuessPicture
//
//  Created by 沈喆 on 16/7/15.
//  Copyright © 2016年 沈喆. All rights reserved.
//

#import "ViewController.h"
#import "QuestionModel.h"
#import "IllustratedHandbook.h"
#import "IllustratedHandbookFrame.h"

@interface ViewController ()
- (IBAction)illustratedHandbookButton:(id)sender; // 图鉴按钮
- (IBAction)previousQuestionButton:(id)sender; // 上一题按钮
- (IBAction)bigImageButton:(id)sender; // 放大按钮
- (IBAction)nextQuestionButton:(id)sender; // 下一题按钮
- (IBAction)centerImageButton:(id)sender; // 精灵图片按钮

@property (weak, nonatomic) IBOutlet UILabel *numberOfQuestionsLabel; // 题号／小精灵编号
@property (weak, nonatomic) IBOutlet UIButton *coinButton; // 金币按钮
@property (weak, nonatomic) IBOutlet UIButton *previousQuestionButtonInfo; // 上一题按钮信息
@property (weak, nonatomic) IBOutlet UIButton *nextQuestionButtonInfo; // 下一题按钮信息
@property (weak, nonatomic) IBOutlet UIButton *centerImageInfo; // 精灵图片信息
@property (weak, nonatomic) IBOutlet UIButton *illustratedHandbookButtonInfo; // 图鉴按钮信息

@property (weak, nonatomic) IBOutlet UIView *answerView; // 答案区域
@property (weak, nonatomic) IBOutlet UIView *optionsView; // 待选项区域
@property (weak, nonatomic) IBOutlet UIView *attributeView; // 属性区域

//@property (nonatomic, strong) NSArray *questions;
@property (nonatomic, assign) NSInteger index; // 索引
@property (nonatomic, weak) UIButton *cover; // 阴影
@property (nonatomic, assign) CGRect centerImageFrame; // 保存原图片位置信息
@property (nonatomic, strong) NSArray *illustratedHandbookFrame;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startAgain];
}

- (NSArray *)illustratedHandbookFrame {
    if (_illustratedHandbookFrame == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@".plist"];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *HandbookFrameArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            QuestionModel *questionModel = [QuestionModel questionWithDict:dict];
            
            IllustratedHandbookFrame *illustratedHandbookFrame = [[IllustratedHandbookFrame alloc] init];
            illustratedHandbookFrame.questionModel = questionModel;
            [HandbookFrameArray addObject:illustratedHandbookFrame];
        }
        _illustratedHandbookFrame = HandbookFrameArray;
    }
    return _illustratedHandbookFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button

/**
 *  图鉴按钮
 */
- (IBAction)illustratedHandbookButton:(id)sender {
    for (UIButton *answerButton in self.answerView.subviews) {
        [self clickAnswerButton:answerButton];
    }
    
    IllustratedHandbookFrame *illustratedHandbookFrame = self.illustratedHandbookFrame[self.index];
    
    // 获取答案的第一个字符
    NSString *firstString = [illustratedHandbookFrame.questionModel.answer substringToIndex:1];
    
    // 找出待选项中的答案的第一个字符
    for (UIButton *optionButton in self.optionsView.subviews) {
        NSString *optionTitle = optionButton.currentTitle;
        if ([optionTitle isEqualToString:firstString]) {
            [self clickOptionButton:optionButton];
        }
    }
    [self settingScore:-2000];
    self.illustratedHandbookButtonInfo.enabled = NO;
    
    // 创建阴影
    [self createCoverWithAction:@selector(killCover) alphaValue:0.95];
    
    // 创建图鉴
    [IllustratedHandbook illustratedHandbookWithCover:self.cover handbookFrame:illustratedHandbookFrame];
}

/**
 *  图片按钮
 */
- (IBAction)centerImageButton:(id)sender {
    if (self.cover == nil) {
        [self bigImageButton:nil];
    } else {
        [self smallImage];
    }
}

/**
 *  放大图片按钮
 */
- (IBAction)bigImageButton:(id)sender {
    [self createCoverWithAction:@selector(smallImage) alphaValue:0.7];
    
    // 使图片置顶
    [self.view bringSubviewToFront:self.centerImageInfo];
    
    self.centerImageFrame = self.centerImageInfo.frame;
    float centerImageW = self.view.frame.size.width;
    float centerImageH = centerImageW;
    float centerImageX = 0;
    float centerImageY = (self.view.frame.size.height - centerImageH) * 0.5;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.centerImageInfo.frame = CGRectMake(centerImageX, centerImageY, centerImageW, centerImageH);
    }];
}

/**
 *  缩小图片事件
 */
- (void)smallImage {
    [UIView animateWithDuration:0.25 animations:^{
        self.centerImageInfo.frame = self.centerImageFrame;
        [self killCover];
    }];
}

/**
 *  上一题按钮
 */
- (IBAction)previousQuestionButton:(id)sender {
    [self changeQuestionToNext:NO];
}

/**
 *  下一题按钮
 */
- (IBAction)nextQuestionButton:(id)sender {
    [self changeQuestionToNext:YES];
}

/**
 *  设置通用的按钮frame
 */
- (void)settingButtonFrame:(UIButton *)button width:(float)buttonW height:(float)buttonH count:(NSInteger)count numberOfRow:(NSInteger)numberOfRow indexPath:(NSInteger)indexpath {
    float viewW = self.view.frame.size.width;
    if (numberOfRow == 1) {
        // 单行按钮的情况
        float gap = 10;
        float leftGap = (viewW - count * buttonW - gap * (count - 1)) * 0.5;
        float buttonX = leftGap + indexpath * (buttonW + gap);
        float buttonY = 0;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    } else {
        // 多行按钮的情况
        float gap = (viewW - buttonW * 7) / 8;
        float gapH = 15;
        float row = indexpath / numberOfRow;
        float column = indexpath % numberOfRow;
        float leftGap = (viewW - numberOfRow * buttonW - (numberOfRow - 1) * gap) * 0.5;
        float buttonX = leftGap + column * (buttonW + gap);
        float buttonY = row * (buttonH + gapH);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }
}

/**
 *  添加属性按钮
 */
- (void)addAttributeButton:(IllustratedHandbookFrame *)illustratedHandbookFrame {
    // 移除上一题的属性按钮
    [self.attributeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 设置属性文字
    NSDictionary *imageOfAttribute = @{@"妖精":@"demon", @"龙":@"dragon", @"电":@"electricity", @"火":@"fire", @"飞行":@"flight",
                                       @"一般":@"general", @"幽灵":@"ghost", @"格斗":@"grapple", @"草":@"grass", @"地面":@"ground",
                                       @"冰":@"ice", @"虫":@"insect", @"岩石":@"rock", @"钢":@"steel", @"超能力":@"superpower",
                                       @"毒":@"toxin", @"水":@"water"};
    
    // 添加属性按钮
    NSInteger attributeCount = illustratedHandbookFrame.questionModel.attribute.count;
    for (NSInteger index = 0; index < attributeCount; index ++) {
        UIButton *attributeButton = [[UIButton alloc] init];
        [attributeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // 从字典中找出对应属性所应该显示的图片
        NSString *tempAttribute = illustratedHandbookFrame.questionModel.attribute[index];
        NSString *nameOfImage = imageOfAttribute[tempAttribute];
        [attributeButton setBackgroundImage:[UIImage imageNamed:nameOfImage] forState:UIControlStateNormal];
        
        // 设置显示的属性名称
        [attributeButton setTitle:tempAttribute forState:UIControlStateNormal];
        
        // 根据属性名称的长度调整字体大小
        if (tempAttribute.length >= 3) {
            attributeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        } else {
            attributeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        }

        // 设置属性按钮的frame
        [self settingButtonFrame:attributeButton width:45 height:45 count:attributeCount numberOfRow:1 indexPath:index];
        
        // 设置属性按钮的点击监听
//        [attributeButton addTarget:self action:@selector(clickAnswerButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.attributeView addSubview:attributeButton];
        
        // 无点击效果（暂时）
        attributeButton.adjustsImageWhenHighlighted = NO;
    }
}

/**
 *  添加正确答案按钮
 */
- (void)addAnswerButton:(IllustratedHandbookFrame *)illustratedHandbookFrame {
    // 移除上一题的答案按钮
    [self.answerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //    for (UIView *subview in self.answerView.subviews) {
    //        [subview removeFromSuperview];
    //    }
    
    // 添加答案按钮
    NSInteger answerCount = illustratedHandbookFrame.questionModel.answer.length;
    for (NSInteger index = 0; index < answerCount; index ++) {
        UIButton *answerButton = [[UIButton alloc] init];
        [answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [answerButton setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [answerButton setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        
        // 设置答案按钮的frame
        [self settingButtonFrame:answerButton width:45 height:45 count:answerCount numberOfRow:1 indexPath:index];
        
        // 设置点击监听
        [answerButton addTarget:self action:@selector(clickAnswerButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.answerView addSubview:answerButton];
    }
}

/**
 *  监听答案按钮点击
 */
- (void)clickAnswerButton:(UIButton *)answerButton {
    NSString *answerTitle = [answerButton titleForState:UIControlStateNormal];
    for (UIButton *optionButton in self.optionsView.subviews) {
        NSString *optionTitle = optionButton.currentTitle;
        if ([optionTitle isEqualToString:answerTitle] && optionButton.hidden == YES) {
            optionButton.hidden = NO;
            [answerButton setTitle:nil forState:UIControlStateNormal];
            break;
        }
    }
    for (UIButton *answerButton in self.answerView.subviews) {
        [answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    for (UIButton *optionButton in self.optionsView.subviews) {
        optionButton.enabled = YES;
    }
}

/**
 *  添加待选项按钮
 */
- (void)addOptionsButton:(IllustratedHandbookFrame *)illustratedHandbookFrame {
    // 移除上一题的待选项按钮
    [self.optionsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 添加带选项按钮
    NSInteger optionsCount = illustratedHandbookFrame.questionModel.options.count;
    for (NSInteger index = 0; index < optionsCount; index ++) {
        UIButton *optionsButton = [[UIButton alloc] init];
        [optionsButton setBackgroundImage:[UIImage imageNamed:@"btn_option" ] forState:UIControlStateNormal];
        [optionsButton setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];

        [self settingButtonFrame:optionsButton width:45 height:45 count:0 numberOfRow:7 indexPath:index];
        
        [optionsButton setTitle:illustratedHandbookFrame.questionModel.options[index] forState:UIControlStateNormal];
        [optionsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // 设置点击监听
        [optionsButton addTarget:self action:@selector(clickOptionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.optionsView addSubview:optionsButton];
    }
}

/**
 *  监听待选项按钮点击
 */
- (void)clickOptionButton:(UIButton *)optionButton {
    optionButton.hidden = YES;
    
    for (UIButton *answerButton in self.answerView.subviews) {
        NSString *answerTitle = answerButton.currentTitle;
        
        if (answerTitle.length == 0) {
            NSString *optionTitle = [optionButton titleForState:UIControlStateNormal];
            [answerButton setTitle:optionTitle forState:UIControlStateNormal];
            break;
        }
    }
    // 检查结果
    [self checkResult];
}

#pragma mark - cover

/**
 *  创建阴影
 */
- (void)createCoverWithAction:(SEL)action alphaValue:(float)alphaValue {
    UIButton *cover = [[UIButton alloc] init];
    
    // 设置阴影尺寸、颜色、透明度
    cover.frame = [UIScreen mainScreen].bounds;
    cover.backgroundColor = [UIColor lightGrayColor];
    cover.alpha = 0.0;
    
    [self.view addSubview:cover];
    
    // 添加阴影点击事件
    [cover addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    self.cover = cover;
    
    //动画
    [UIView animateWithDuration:0.25 animations:^{
        cover.alpha = alphaValue;
    }];
}

/**
 *  去除阴影
 */
- (void)killCover {
    [UIView animateWithDuration:0.25 animations:^{
        self.cover.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.cover removeFromSuperview];
        self.cover = nil;
    }];
}

#pragma mark - 功能

/**
 *  切换题目
 */
- (void)changeQuestionToNext:(BOOL)ifNext {
    if (ifNext) {
        self.index ++;
    } else {
        self.index --;
    }
    IllustratedHandbookFrame *illustratedHandbookFrame = self.illustratedHandbookFrame[self.index];
    
    // 设置序号、图片、按钮属性
    [self settingGuessPictureData:illustratedHandbookFrame];
    
    //添加属性按钮
    [self addAttributeButton:illustratedHandbookFrame];
    
    // 添加正确答案按钮
    [self addAnswerButton:illustratedHandbookFrame];
    
    // 添加待选项按钮
    [self addOptionsButton:illustratedHandbookFrame];
    
    // 激活图鉴按钮
    self.illustratedHandbookButtonInfo.enabled = YES;
}

/**
 *  设置序号图片、按钮属性
 */
- (void)settingGuessPictureData:(IllustratedHandbookFrame *)illustratedHandbookFrame {
    self.numberOfQuestionsLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.index + 1, self.illustratedHandbookFrame.count];
    
    [self.centerImageInfo setImage:[UIImage imageNamed:illustratedHandbookFrame.questionModel.icon] forState:UIControlStateNormal];
    
    // 使下一题按钮在最后一张图片时失效无法点击
    if (self.index >= self.illustratedHandbookFrame.count - 1) {
        self.nextQuestionButtonInfo.enabled = NO;
    }
    
    // 使上一题按钮在第一张图片时失效无法点击
    if (self.index == 0) {
        self.previousQuestionButtonInfo.enabled = NO;
    } else {
        self.previousQuestionButtonInfo.enabled = YES;
    }
}

/**
 *  检查结果是否正确
 */
- (void)checkResult {
    // 用full来判断答案是否填满
    BOOL full = YES;
    
    NSMutableString *tempAnswer = [NSMutableString string];
    
    // 遍历拼接答案
    for (UIButton *answerButton in self.answerView.subviews) {
        NSString *answerTitle = [answerButton titleForState:UIControlStateNormal];
        if (answerTitle.length == 0) {
            full = NO;
        }
        // 拼接答案
        if (answerTitle) {
            [tempAnswer appendString:answerTitle];
        }
    }
    
    // 判断答案是否填满
    if (full) {
        // 如果答案框满了，则无法再点击选项按钮
        for (UIButton *optionButton in self.optionsView.subviews) {
            optionButton.enabled = NO;
        }
        
        // 判断答案是否正确
        IllustratedHandbookFrame *illustratedHandbookFrame = self.illustratedHandbookFrame[self.index];
        if ([tempAnswer isEqualToString:illustratedHandbookFrame.questionModel.answer]) {
            // 答案正确，则判断是否是最后一题，若不是则跳转下一题，若是则弹出警告提示框
            if (self.index < self.illustratedHandbookFrame.count - 1) {
                [self performSelector:@selector(nextQuestionButton:) withObject:nil afterDelay:0.2];
            } else {
                [self showAlertView];
            }
            [self settingScore:1000];
        } else {
            // 答案错误情况
            for (UIButton *answerButton in self.answerView.subviews) {
                [answerButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
    }
}

/**
 *  重新开始游戏
 */
- (void)startAgain {
    self.index = -1;
    [self nextQuestionButton:nil];
    self.nextQuestionButtonInfo.enabled = YES;
}

/**
 *  设置分数
 *  @param setScore 需要设置的分数分值
 */
- (void)settingScore:(NSInteger)setScore {
    int score = self.coinButton.currentTitle.intValue;
    score += setScore;
    [self.coinButton setTitle:[NSString stringWithFormat:@"%d", score] forState:UIControlStateNormal];
}

#pragma mark - others

/**
 *  警告提示框
 */
- (void)showAlertView {
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
    NSString *message = @"您已经认识了所有的宠物小精灵，您需要重新温习一下吗？";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"恭喜！" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startAgain];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  设置状态栏颜色
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
