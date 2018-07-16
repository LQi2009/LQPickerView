//
//  LQPickerView.m
//  LQToolKit-ObjectiveC
//
//  Created by LiuQiqiang on 2018/7/15.
//  Copyright © 2018年 QiqiangLiu. All rights reserved.
//

#import "LQPickerView.h"

#define LQPickerView_screenWidth ([UIScreen mainScreen].bounds.size.width)
#define LQPickerView_screenHeight ([UIScreen mainScreen].bounds.size.height)
#define LQPickerView_pickerHeight 246.0
//#define LQPickerView_Height 216.0
#define LQPickerView_buttonHeight 30.0
@interface LQPickerView () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong)CALayer *topLine;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong)UIImageView *backgroundImageView;
@property (nonatomic, strong)UIVisualEffectView *blurView;
@property (strong, nonatomic)UIButton *commitButton;
@property (nonatomic, strong) NSMutableArray *currentItems;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) LQPickerViewHandler commitHandler;
@property (nonatomic, copy) LQPickerViewHandler autoHandler;
@end
@implementation LQPickerView
+ (instancetype) showOnView:(UIView *)view frame:(CGRect) frame datas:(NSArray<LQPickerItem *> *) datas commitHandler: (LQPickerViewHandler)handler autoHandler:(LQPickerViewHandler)autoHandler {

    LQPickerView *picker = [[LQPickerView alloc]initWithFrame:frame];
    [view addSubview:view];
    picker.commitHandler = handler;
    picker.autoHandler = autoHandler;
    [picker loadDates:datas];
    return picker;
}

+ (instancetype) pickerViewFrame:(CGRect)frame datas:(NSArray<LQPickerItem *> *)datas commitHandler: (LQPickerViewHandler)handler autoHandler:(LQPickerViewHandler)autoHandler {
    
    LQPickerView *picker = [[LQPickerView alloc]initWithFrame:frame];
    [picker loadDates:datas];
    picker.commitHandler = handler;
    picker.autoHandler = handler;
    return picker;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.bounds = CGRectMake(0, 0, LQPickerView_screenWidth, LQPickerView_pickerHeight);
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, LQPickerView_screenWidth, LQPickerView_pickerHeight);
        self.backgroundColor = [UIColor whiteColor];
        self.pickerView.backgroundColor = [UIColor whiteColor];
        _isBlur = YES;
        _autoEnable = YES;
        _topLineColor = [UIColor grayColor];
    }
    return self;
}

- (void) didSelectedHandler:(LQPickerViewHandler)handler {
    
    self.commitHandler = handler;
}

- (void) autoSelectedHandler:(LQPickerViewHandler)handler {
    self.autoHandler = handler;
}

- (void) loadDates:(NSArray *)datas {
    self.dataSource = [NSArray arrayWithArray:datas];
    
    [self configDefaultItemFromDatas:datas];
//    [self.pickerView reloadAllComponents];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.topLine.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 1);
    self.commitButton.frame = CGRectMake(CGRectGetWidth(self.frame) - 60, 0, 60, LQPickerView_buttonHeight);
    self.pickerView.frame = CGRectMake(0, LQPickerView_buttonHeight, CGRectGetWidth(self.frame), LQPickerView_pickerHeight - LQPickerView_buttonHeight);
    
    if (self.isBlur) {
        self.blurView.frame = self.bounds;
        [self insertSubview:self.blurView atIndex:0];
    }
    
    if (self.backgroundImage) {
        [self insertSubview:self.backgroundImageView atIndex:0];
    }
}

#pragma mark - 按钮点击事件
- (void)commitButtonClick:(UIButton *)button {
    
    // 选择结果回调
    [self commitSelectedData:self.commitHandler];
}

- (void) commitSelectedData:(LQPickerViewHandler)handler {
    
    if (handler) {
        
        NSMutableString *str = [[NSMutableString alloc]init];
        for (LQPickerItem *item in self.currentItems) {
            if (str.length <= 0) {
                [str appendString:item.name];
                continue;
            }
            
            [str appendString:@"-"];
            [str appendString:item.name];
        }
        handler(self.currentItems, [str copy]);
    }
}

#pragma mark - UIPickerViewDelegate & UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return self.currentItems.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return self.dataSource.count;
    } else {
        
        LQPickerItem *item = [self.currentItems objectAtIndex:component - 1];
       
        return item.datas.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    UILabel *label = (UILabel *)view;
    if (label == nil) {
        
        label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    if (component == 0) {
        
        LQPickerItem *item = [self.dataSource objectAtIndex:row];
        NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:item.name attributes:self.textAttributes];
        label.attributedText = attStr;
    } else {
        LQPickerItem *item = [self.currentItems objectAtIndex:component - 1];
        if (item.datas.count > row) {
            
            LQPickerItem *item1 = [item.datas objectAtIndex:row];
            NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:item1.name attributes:self.textAttributes];
            label.attributedText = attStr;
        }
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    
    if (component == 0) {
        
        LQPickerItem *item = [self.dataSource objectAtIndex:row];
        [self replaceItem:item atIndex:0];
    } else {
        
        if (self.currentItems.count > component - 1 ) {
            LQPickerItem *item = [self.currentItems objectAtIndex:component - 1];
            
            if (item.datas.count > row) {
                LQPickerItem *item1 = [item.datas objectAtIndex:row];
                [self replaceItem:item1 atIndex:component];
            }
        }
    }
    
    [self reloadPickerAtIndex:component + 1];
    
    if (self.autoEnable) {
        [self commitSelectedData:self.autoHandler];
    }
}

#pragma mark - 递归分配数据
- (void) configDefaultItemFromDatas:(NSArray *)datas {
    
    if (datas.count > 0) {
        LQPickerItem *item = [datas firstObject];
        [self.currentItems addObject:item];
        if (item.datas) {
            [self configDefaultItemFromDatas:item.datas];
        }
    }
}

- (void) replaceItem:(LQPickerItem *)item atIndex:(NSInteger)index {
    
    
    if (self.currentItems.count > index) {
        [self.currentItems replaceObjectAtIndex:index withObject:item];
    } else {
        [self.currentItems addObject:item];
    }
    
    if (item.datas.count > 0) {
        LQPickerItem *item1 = [item.datas firstObject];
        index++;
        [self replaceItem:item1 atIndex:index];
    }
}

- (void) reloadPickerAtIndex:(NSInteger)index {
    
    if (index >= self.currentItems.count) {
        return;
    }
    
    [self.pickerView reloadComponent:index];
    [self.pickerView selectRow:0 inComponent:index animated:YES];
    index++;
    [self reloadPickerAtIndex:index];
}

#pragma mark - setter method
- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    
    self.backgroundImageView.image = backgroundImage;
}

- (void)setIsBlur:(BOOL)isBlur {
    _isBlur = isBlur;
    
    if (isBlur) {
        
        self.backgroundColor = [UIColor clearColor];
        self.pickerView.backgroundColor = [UIColor clearColor];
    } else {
        [self.blurView removeFromSuperview];
    }
}

#pragma mark - lazy method
- (NSMutableArray *)currentItems {
    if (_currentItems == nil) {
        _currentItems = [NSMutableArray array];
    }
    
    return _currentItems;
}

- (UIButton *)commitButton {
    if (_commitButton == nil) {
        
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"完成" attributes:self.buttonTitleAttributes];
        [_commitButton setAttributedTitle:str forState:UIControlStateNormal];
        
        [_commitButton addTarget:self action:@selector(commitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_commitButton];
    }
    
    return _commitButton;
}

- (UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {

        _backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
    }

    return _backgroundImageView;
}

- (UIVisualEffectView *)blurView {
    if (_blurView == nil) {

        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];

        _blurView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        _blurView.frame = self.bounds;
    }

    return _blurView;
}

- (NSDictionary *)textAttributes {
    if (_textAttributes == nil) {
        _textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blueColor]};
    }
    
    return _textAttributes;
}

- (NSDictionary *)buttonTitleAttributes {
    if (_buttonTitleAttributes == nil) {
        _buttonTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blueColor]};
    }
    
    return _buttonTitleAttributes;
}


- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, LQPickerView_buttonHeight, LQPickerView_screenWidth, LQPickerView_pickerHeight - LQPickerView_buttonHeight)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self addSubview:_pickerView];
    }
    
    return _pickerView;
}

- (CALayer *)topLine {
    if (_topLine == nil) {
        _topLine = [CALayer layer];
        _topLine.backgroundColor = self.topLineColor.CGColor;
        [self.layer addSublayer:_topLine];
    }
    
    return _topLine;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

#pragma mark - 选择器数据源model
@implementation LQPickerItem

- (void) loadData:(NSInteger)count config:(void(^)(LQPickerItem *item, NSInteger index)) config {
    if (count <= 0) {
        NSLog(@"至少需要一个数据源！");
        return;
    }
    
    NSMutableArray *temps = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        LQPickerItem *city = [[LQPickerItem alloc]init];
        if (config) {
            config(city, i);
        }
        
        [temps addObject:city];
    }
    
    self.datas = [NSArray arrayWithArray:temps];
}

@end
