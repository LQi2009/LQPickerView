//
//  LQCityPicker.m
//  LQToolKit-ObjectiveC
//
//  Created by LiuQiqiang on 2018/7/15.
//  Copyright © 2018年 QiqiangLiu. All rights reserved.
//

#import "LQCityPicker.h"
#import "LQPickerView.h"

#define lz_screenWidth ([UIScreen mainScreen].bounds.size.width)
#define lz_screenHeight ([UIScreen mainScreen].bounds.size.height)

static CGFloat const lz_contentHeight = 246.0;

@interface LQCityPicker ()
{
    // 记录当前选择器是否已经显示
    BOOL __isShowed ;
}

@property (nonatomic, copy) LQCityPickerHandler selectBlock;
@property (nonatomic, copy) LQCityPickerCancelHandler cancelBlock;
@property (nonatomic, strong) LQPickerView *pickerView;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) CALayer *backgroundLayer;
@property (nonatomic, assign) BOOL isNewWindow;
@end
@implementation LQCityPicker

+ (instancetype)showInView:(UIView *)view datas:(NSArray *)datas didSelectWithBlock:(LQCityPickerHandler)block cancelBlock:(LQCityPickerCancelHandler)cancel {
    
    LQCityPicker* cityPicker = [[LQCityPicker alloc]init];
    cityPicker.frame = CGRectMake(0, 0, lz_screenWidth, lz_screenHeight);
    
    cityPicker.autoChange = YES;
    cityPicker.selectBlock = block;
    cityPicker.cancelBlock = cancel;
    cityPicker.interval = 0.20;
    [cityPicker loadDatas:datas];
    [cityPicker show];
    if (view) {
        [view addSubview:cityPicker];
    } else {
        [cityPicker.window addSubview:cityPicker];
    }
    
    return cityPicker;
}

#pragma mark - /** 加载数据源 */
- (void)loadDatas:(NSArray *)datas {
    
    [self.pickerView loadDates:datas];
}

- (void)setAutoChange:(BOOL)autoChange {
    _autoChange = autoChange;
    self.pickerView.autoEnable = autoChange;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _interval = 0.2;
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor clearColor];
        [self backgroundLayer];
        self.titleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blueColor]};
        self.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blueColor]};
        __weak typeof(self) ws = self;
        [self.pickerView didSelectedHandler:^(NSArray<LQPickerItem *> *objs, NSString *dsc) {
            [ws dismiss];
            if (ws.selectBlock) {
                ws.selectBlock(objs, dsc);
            }
        }];
        
        [self.pickerView autoSelectedHandler:^(NSArray<LQPickerItem *> *objs, NSString *dsc) {
            
            if (ws.selectBlock) {
                ws.selectBlock(objs, dsc);
            }

        }];
    }
    
    return self;
}

- (void)dealloc {
    
    NSLog(@"视图销毁了");
}

- (void)show {
    if (__isShowed == YES) {
        return;
    }
    
    __isShowed = YES;
    [UIView animateWithDuration:self.interval animations:^{
        self.pickerView.frame = CGRectMake(0, lz_screenHeight - lz_contentHeight, lz_screenWidth, lz_contentHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    
    if (__isShowed == NO) {
        return;
    }
    
    __isShowed = NO;
    [UIView animateWithDuration:self.interval animations:^{
        self.pickerView.frame = CGRectMake(0, lz_screenHeight, lz_screenWidth, lz_contentHeight);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        if (self.isNewWindow) {
            self.window.hidden = YES;
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.pickerView.frame, point) == NO) {
        [self dismiss];
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }
}

#pragma mark - property getter
-(void)setTextAttributes:(NSDictionary *)textAttributes {
    _textAttributes = textAttributes;
    self.pickerView.textAttributes = textAttributes;
}

- (void)setTitleAttributes:(NSDictionary *)titleAttributes {
    _titleAttributes = titleAttributes;
    self.pickerView.buttonTitleAttributes = titleAttributes;
}

- (LQPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[LQPickerView alloc]init];
        
        _pickerView.buttonTitleAttributes = self.titleAttributes;
        _pickerView.textAttributes = self.textAttributes;
//        _pickerView.isBlur = YES;
        _pickerView.frame = CGRectMake(0, lz_screenHeight, lz_screenWidth, lz_contentHeight);
        [self addSubview:_pickerView];
    }
    
    return _pickerView;
}

//=====================================
- (CALayer *)backgroundLayer {
    if (_backgroundLayer == nil) {
        _backgroundLayer = [CALayer layer];
        _backgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
        _backgroundLayer.opacity = 0.6;
        _backgroundLayer.frame = [UIScreen mainScreen].bounds;
        [self.layer addSublayer:_backgroundLayer];
    }
    
    return _backgroundLayer;
}

- (UIWindow *)window {
    if (_window == nil) {

        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (window == nil) {
            window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
            window.rootViewController = [[UIViewController alloc]init];
            window.windowLevel = UIWindowLevelStatusBar + 1;
            window.hidden = NO;
            window.alpha = 1.0;
            self.isNewWindow = YES;
        }

        _window = window;
    }

    return _window;
}
@end
