//
//  LZCityPickerView.m
//  LZCityPicker
//
//  Created by Artron_LQQ on 16/8/29.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZCityPickerView.h"


#define lz_screenWidth ([UIScreen mainScreen].bounds.size.width)
#define lz_screenHeight ([UIScreen mainScreen].bounds.size.height)
// 216 UIPickerView固定高度
static NSInteger const lz_pickerHeight = 246;
static NSInteger const lz_buttonHeight = 30;

@interface LZCityPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource> {
    
    // 记录当前选择器是否已经显示
    BOOL __isShowed ;
    
    LZProvince *__currentProvience;
    LZCity *__currentCity;
    LZArea *__currentArea;
}
 // 当前父视图
@property (nonatomic, strong) UIView *_superView;
@property (nonatomic, copy) lz_backBlock _selectBlock;
@property (nonatomic, copy) lz_actionBlock _cancelBlock;

// subViews
@property (strong, nonatomic)UIView *contentView;
@property (strong, nonatomic)UIPickerView *pickerView;
@property (strong, nonatomic)UIButton *commitButton;
@property (strong, nonatomic)UIButton *cancelButton;
@property (strong, nonatomic)UIImageView *bkgImageView;
@property (strong, nonatomic)UIVisualEffectView *blurView;
@property (strong, nonatomic)CALayer *topLine;
//dataSource
@property (nonatomic, strong) NSMutableArray *dataSource;
@end
@implementation LZCityPickerView

+ (instancetype)showInView:(UIView *)view didSelectWithBlock:(lz_backBlock)block cancelBlock:(lz_actionBlock)cancel {
    
    LZCityPickerView* cityPicker = [[LZCityPickerView alloc]init];
    cityPicker.frame = CGRectMake(0, lz_screenHeight, lz_screenWidth, lz_pickerHeight);
    cityPicker._superView = view;
    
    cityPicker.autoChange = YES;
    [cityPicker showWithBlock:nil];
    
    cityPicker._selectBlock = block;
    cityPicker._cancelBlock = cancel;
    return cityPicker;
}

- (void)showWithBlock:(void(^)())block {
    if (__isShowed == YES) {
        return;
    }
    
    __isShowed = YES;
    [self._superView addSubview:self];
    [UIView animateWithDuration:0.20 animations:^{
        self.frame = CGRectMake(0, lz_screenHeight - lz_pickerHeight, lz_screenWidth, lz_pickerHeight);
    } completion:^(BOOL finished) {
        if (block) {
            block();
        }
    }];
}

- (void)dismissWithBlock:(void(^)())block {
    
    if (__isShowed == NO) {
        return;
    }
    
    __isShowed = NO;
    [UIView animateWithDuration:0.20 animations:^{
        self.frame = CGRectMake(0, lz_screenHeight, lz_screenWidth, lz_pickerHeight);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        if (block) {
            block();
        }
    }];
}

#pragma mark - property getter
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataSource;
}

- (NSDictionary *)textAttributes {
    if (_textAttributes == nil) {
        _textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blueColor]};
    }
    
    return _textAttributes;
}

- (NSDictionary *)titleAttributes {
    if (_titleAttributes == nil) {
        _titleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blueColor]};
    }
    
    return _titleAttributes;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSAssert(!self._superView, @"ERROR: Please use 'showInView:didSelectWithBlock:' to initialize, and the first parameter can not be nil!");
//        NSLog(@"视图初始化了");
        self.backgroundColor = [UIColor whiteColor];
        [self loadData];
    }
    
    return self;
}

- (void)dealloc {
    
    NSLog(@"视图销毁了");
}
#pragma mark - /** 加载数据源 */
- (void)loadData {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Address" ofType:@"plist"];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
    
    NSArray *provinces = [dic allKeys];
    
    for (NSString *tmp in provinces) {
        
        LZProvince *province = [[LZProvince alloc]init];
        province.name = tmp;
        
        NSArray *arr = [dic objectForKey:tmp];
        
        NSDictionary *cityDic = [arr firstObject];
        
        [province configWithDic:cityDic];
        
        [self.dataSource addObject:province];
    }
    
    // 设置当前数据
    LZProvince *defPro = [self.dataSource firstObject];
    
    __currentProvience = defPro;
    
    LZCity *defCity = [defPro.cities firstObject];
    
    __currentCity = defCity;
    
    __currentArea = [defCity.areas firstObject];
}

#pragma mark - 懒加载子视图
- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:self.bounds];
        _contentView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_contentView];
    }
    
    return _contentView;
}

- (UIImageView *)bkgImageView {
    if (_bkgImageView == nil) {
        _bkgImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _bkgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bkgImageView.clipsToBounds = YES;
        [self insertSubview:_bkgImageView atIndex:0];
    }
    
    return _bkgImageView;
}

- (UIVisualEffectView *)blurView {
    if (_blurView == nil) {
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        blurView.frame = _bkgImageView.bounds;
        
        _blurView = blurView;
    }
    
    return _blurView;
}

- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, lz_buttonHeight, lz_screenWidth, lz_pickerHeight - lz_buttonHeight)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
        [self.contentView addSubview:_pickerView];
    }
    
    return _pickerView;
}

- (UIButton *)commitButton {
    if (_commitButton == nil) {
        
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"完成" attributes:self.titleAttributes];
        [_commitButton setAttributedTitle:str forState:UIControlStateNormal];
        
        [_commitButton addTarget:self action:@selector(commitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_commitButton];
    }
    
    return _commitButton;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"取消" attributes:self.titleAttributes];
        [_cancelButton setAttributedTitle:str forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cancelButton];
    }
    
    return _cancelButton;
}

- (CALayer *)topLine {
    if (_topLine == nil) {
        _topLine = [CALayer layer];
        _topLine.backgroundColor = [UIColor grayColor].CGColor;
    }
    
    return _topLine;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self pickerView];
    
    if (self.backgroundImage) {
        
        self.bkgImageView.image = self.backgroundImage;
        
        [self insertSubview:self.blurView aboveSubview:self.bkgImageView];
    }
    
    if (!self.autoChange) {
        
        self.cancelButton.frame = CGRectMake(10, 5, 40, lz_buttonHeight - 10);
        
    }
    
    self.commitButton.frame = CGRectMake(lz_screenWidth - 50, 5, 40, lz_buttonHeight - 10);
    
    self.topLine.frame = CGRectMake(0, 0, lz_screenWidth, 0.4);
    [self.contentView.layer addSublayer:self.topLine];
}
#pragma mark - 按钮点击事件
- (void)commitButtonClick:(UIButton *)button {
    
    // 选择结果回调
    if (self._selectBlock) {
        
        NSString *address = [NSString stringWithFormat:@"%@-%@-%@",__currentArea.province,__currentArea.city,__currentArea.name];
        self._selectBlock(address,__currentArea.province,__currentArea.city,__currentArea.name);
    }
    
    __weak typeof(self)ws = self;
    [self dismissWithBlock:^{
        
        if (ws._cancelBlock) {
            ws._cancelBlock();
        }
    }];
}

- (void)cancelButtonClick:(UIButton *)button {
    
    __weak typeof(self)ws = self;
    [self dismissWithBlock:^{
        
        if (ws._cancelBlock) {
            ws._cancelBlock();
        }
    }];
}

#pragma mark - UIPickerView 代理和数据源方法
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    
//    CGFloat width = lz_screenWidth/3.0;
//    
//    if (component == 0) {
//        return width - 20;
//    } else if (component == 1) {
//        
//        return width;
//    } else {
//        
//        return width + 20;
//    }
//}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return self.dataSource.count;
    } else if (component == 1) {
        
        return __currentProvience.cities.count;
    } else {
        
        return __currentCity.areas.count;
    }
}

//- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    
//    return @"城市列表";
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    
    if (component == 0) {
        
        LZProvince *pro = [self.dataSource objectAtIndex:row];
        NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:pro.name attributes:self.textAttributes];
        label.attributedText = attStr;
    } else if (component == 1) {
        
        if (__currentProvience.cities.count > row) {
            
            LZCity *city = [__currentProvience.cities objectAtIndex:row];
            NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:city.name attributes:self.textAttributes];
            label.attributedText = attStr;
        }
    } else {
        
        if (__currentCity.areas.count > row) {
            
            LZArea *area = [__currentCity.areas objectAtIndex:row];
            NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:area.name attributes:self.textAttributes];
            label.attributedText = attStr;
        }
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    
    if (component == 0) {
        
        LZProvince *province = [self.dataSource objectAtIndex:row];
        __currentProvience = province;
        
        LZCity *city = [province.cities firstObject];
        __currentCity = city;
        
        __currentArea = [city.areas firstObject];
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    } else if (component == 1) {
        
        if (__currentProvience.cities.count > row) {
            
            LZCity *city = [__currentProvience.cities objectAtIndex:row];
            __currentCity = city;
            
            __currentArea = [city.areas firstObject];
        }
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    } else if (component == 2) {
        
        if (__currentCity.areas.count > row) {
             __currentArea = [__currentCity.areas objectAtIndex:row];
        }
    }
    
    // 选择结果回调
    if (__selectBlock && self.autoChange) {
        
        NSString *address = [NSString stringWithFormat:@"%@-%@-%@",__currentArea.province,__currentArea.city,__currentArea.name];
        __selectBlock(address,__currentArea.province,__currentArea.city,__currentArea.name);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
