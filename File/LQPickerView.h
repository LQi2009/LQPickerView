//
//  LQPickerView.h
//  LQToolKit-ObjectiveC
//
//  Created by LiuQiqiang on 2018/7/15.
//  Copyright © 2018年 QiqiangLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LQPickerItem;

/**
 回调Block

 @param objs 当前选择的元素集合，内含选择的LQPickerItem实例对象
 @param dsc 拼接的当前现实的内容字符串，例如：北京-北京市-海淀区
 */
typedef void(^LQPickerViewHandler)(NSArray<LQPickerItem *> *objs, NSString *dsc);
@interface LQPickerView : UIView

/**
 背景图片
 */
@property (nonatomic, strong) UIImage *backgroundImage;

//建议 NSFontAttributeName 和 NSForegroundColorAttributeName一同设置
/** 选择器文本内容字体属性,默认:蓝色,14号 */
@property (nonatomic, strong)NSDictionary *textAttributes;
/** 按钮标题字体属性,默认:蓝色,14号 */
@property (nonatomic, strong)NSDictionary *buttonTitleAttributes;

/**
 毛玻璃效果
 */
@property (nonatomic, assign) BOOL isBlur;

/**
 是否自动回调结果，若为YES，则会多次调用回调，默认YES
 */
@property (nonatomic, assign) BOOL autoEnable;

/**
 顶部分割线颜色
 */
@property (nonatomic, strong) UIColor *topLineColor;

/**
 类方法创建pickerView

 @param frame frame
 @param datas 内容数组，包含LQPickerItem实例对象
 @param handler 按钮点击回调
 @param autoHandler 选择自动回调，需要autoEnable为YES
 @return 返回实例对象
 */
+ (instancetype) pickerViewFrame:(CGRect)frame datas:(NSArray<LQPickerItem *> *)datas commitHandler: (LQPickerViewHandler)handler autoHandler:(LQPickerViewHandler)autoHandler;

/**
 类方法创建pickerView

 @param view 添加到的父视图
 @param frame frame
 @param datas 内容数组，包含LQPickerItem实例对象
 @param handler 回调
 @param autoHandler 选择自动回调，需要autoEnable为YES
 @return 返回实例对象
 */
+ (instancetype) showOnView:(UIView *)view frame:(CGRect) frame datas:(NSArray<LQPickerItem *> *) datas commitHandler: (LQPickerViewHandler)handler autoHandler:(LQPickerViewHandler)autoHandler ;

/**
 外部加载数据源方法

 @param datas 内容数组，包含LQPickerItem实例对象
 */
- (void) loadDates:(NSArray<LQPickerItem *> *)datas ;

/**
 外部获取回调方法

 @param handler 回调
 */
- (void) didSelectedHandler:(LQPickerViewHandler)handler;

- (void) autoSelectedHandler:(LQPickerViewHandler)handler;
@end

#pragma mark - 选择器数据源model
// 可直接使用此类，把其他的参数赋值给属性 obj ，或者使用继承自此类的子类
@interface LQPickerItem : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, assign) id obj;
@property (nonatomic, copy) NSArray *datas;

/**
 配置model子数据源方法，方法内只是对属性datas进行赋值，其他的属性值通过回调配置

 @param count 包含的子数据数目，即属性datas包含的数据
 @param config 配置子数据的内容闭包，参数同为LQPickerItem实例
 */
- (void) loadData:(NSInteger)count config:(void(^)(LQPickerItem *item, NSInteger index)) config ;
@end
