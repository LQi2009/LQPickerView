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
static LZCityPickerView *__cityPicker = nil;
static backBlock __selectBlock;
// 记录当前选择器是否已经显示
static BOOL __isShowed = NO;
// 当前父视图
static UIView *__supperView;

static NSString *__tempProvince;
static NSString *__tempCity;
static NSString *__tempArea;

@interface LZCityPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic)UIView *contentView;
@property (strong, nonatomic)UIPickerView *pickerView;
@property (strong, nonatomic)UIButton *commitButton;
@property (strong, nonatomic)UIButton *cancelButton;
@property (strong, nonatomic)UIImageView *bkgImageView;
@property (strong, nonatomic)UIVisualEffectView *blurView;

@property (strong, nonatomic)NSMutableArray *provinces;
@property (strong, nonatomic)NSMutableDictionary *dataDic;
@property (strong, nonatomic)NSMutableArray *cities;
@property (strong, nonatomic)NSMutableArray *areas;

//@property (copy, nonatomic);
@end
@implementation LZCityPickerView

+ (instancetype)showInView:(UIView *)view didSelectWithBlock:(backBlock)block {
    
    __cityPicker = [[LZCityPickerView alloc]init];
    __cityPicker.frame = CGRectMake(0, lz_screenHeight, lz_screenWidth, lz_pickerHeight);
    __supperView = view;
    
    [__cityPicker show];
    
    __selectBlock = block;
    return __cityPicker;
}

- (void)show {
    if (__isShowed == YES) {
        return;
    }
    
    __isShowed = YES;
    [__supperView addSubview:__cityPicker];
    [UIView animateWithDuration:0.20 animations:^{
        __cityPicker.frame = CGRectMake(0, lz_screenHeight - lz_pickerHeight, lz_screenWidth, lz_pickerHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    
    if (__isShowed == NO) {
        return;
    }
    
    __isShowed = NO;
    [UIView animateWithDuration:0.20 animations:^{
        __cityPicker.frame = CGRectMake(0, lz_screenHeight, lz_screenWidth, lz_pickerHeight);
    } completion:^(BOOL finished) {
        
        [__cityPicker removeFromSuperview];
        __cityPicker = nil;
    }];
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
        
        NSAssert(!__supperView, @"ERROR: Please use 'showInView:didSelectWithBlock:' to initialize, and the first parameter can not be nil!");
//        NSLog(@"视图初始化了");
        self.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
        [self loadData];
    }
    
    return self;
}

- (void)dealloc {
    
    NSLog(@"视图销毁了");
}

/** 加载数据源 */
- (void)loadData {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Address" ofType:@"plist"];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
    
    [self.dataDic setValuesForKeysWithDictionary:dic];
    
    NSArray *provinces = [dic allKeys];
    [self.provinces addObjectsFromArray:provinces];
    __tempProvince = [self.provinces firstObject];
    
    NSString *provinc = [self.provinces firstObject];
    NSArray *arr = [self.dataDic objectForKey:provinc];
    
    NSDictionary *cityDic = [arr firstObject];
    NSArray *cities = [cityDic allKeys];
    
    if (self.cities.count > 0) {
        [self.cities removeAllObjects];
    }
    
    [self.cities addObjectsFromArray:cities];
    __tempCity = [self.cities firstObject];
    
    NSString *city = [cities firstObject];
    NSArray *areas = [cityDic objectForKey:city];
    
    if (self.areas.count > 0) {
        [self.areas removeAllObjects];
    }
    
    [self.areas addObjectsFromArray:areas];
    __tempArea = [self.areas firstObject];
}

- (void)reloadDate {
    
}

- (NSMutableDictionary *)dataDic {
    if (_dataDic == nil) {
        _dataDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    
    return _dataDic;
}
- (NSMutableArray *)provinces {
    if (_provinces == nil) {
        _provinces = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _provinces;
}

- (NSMutableArray *)cities {
    if (_cities == nil) {
        _cities = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _cities;
}
- (NSMutableArray *)areas {
    if (_areas == nil) {
        _areas = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _areas;
}

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
        
//        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"取消" attributes:self.titleAttributes];
        [_cancelButton setAttributedTitle:str forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cancelButton];
    }
    
    return _cancelButton;
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
    
}
- (void)layoutMainView {
    
}

- (void)commitButtonClick:(UIButton *)button {
    
    // 选择结果回调
    if (__selectBlock) {
        
        NSString *address = [NSString stringWithFormat:@"%@-%@-%@",__tempProvince,__tempCity,__tempArea];
        __selectBlock(address,__tempProvince,__tempCity,__tempArea);
    }
    
    [self dismiss];
}

- (void)cancelButtonClick:(UIButton *)button {
    
    [self dismiss];
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
        
        return self.provinces.count;
    } else if (component == 1) {
        
        return self.cities.count;
    } else {
        
        return self.areas.count;
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
        
        NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:[self.provinces objectAtIndex:row] attributes:self.textAttributes];
        label.attributedText = attStr;
    } else if (component == 1) {
        
        if (self.cities.count > row) {
            
            NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:[self.cities objectAtIndex:row] attributes:self.textAttributes];
            label.attributedText = attStr;
        }
    } else {
        
        NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:[self.areas objectAtIndex:row] attributes:self.textAttributes];
        label.attributedText = attStr;
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    
    if (component == 0) {
        
        NSString *province = [self.provinces objectAtIndex:row];
        __tempProvince = province;
        
        
        NSArray *arr = [self.dataDic objectForKey:province];
        
        NSDictionary *cityDic = [arr firstObject];
        NSArray *cities = [cityDic allKeys];
        
        if (self.cities.count > 0) {
            [self.cities removeAllObjects];
        }
        
        [self.cities addObjectsFromArray:cities];
        __tempCity = [self.cities firstObject];
        
        NSString *cityArea = [cities firstObject];
        NSArray *areas = [cityDic objectForKey:cityArea];
        
        if (self.areas.count > 0) {
            [self.areas removeAllObjects];
        }
        
        [self.areas addObjectsFromArray:areas];
        __tempArea = [self.areas firstObject];
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    } else if (component == 1) {
        
        NSArray *arr = [self.dataDic objectForKey:__tempProvince];
        
        NSDictionary *cityDic = [arr firstObject];
        
        NSString *city = [self.cities objectAtIndex:row];
        __tempCity = city;
        
        NSArray *areas = [cityDic objectForKey:city];
        
        if (self.areas.count > 0) {
            [self.areas removeAllObjects];
        }
        
        [self.areas addObjectsFromArray:areas];
        __tempArea = [self.areas firstObject];
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    } else if (component == 2) {
        
        NSString *area = [self.areas objectAtIndex:row];
        
        __tempArea = area;
    }
    
    // 选择结果回调
    if (__selectBlock && self.autoChange) {
        
        NSString *address = [NSString stringWithFormat:@"%@-%@-%@",__tempProvince,__tempCity,__tempArea];
        __selectBlock(address,__tempProvince,__tempCity,__tempArea);
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
