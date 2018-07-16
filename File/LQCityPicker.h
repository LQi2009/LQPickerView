//
//  LQCityPicker.h
//  LQToolKit-ObjectiveC
//
//  Created by LiuQiqiang on 2018/7/15.
//  Copyright © 2018年 QiqiangLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LQCityPickerHandler)(NSArray *objs, NSString *dsc);
typedef void(^LQCityPickerCancelHandler)(void);

@interface LQCityPicker : UIView

/** 是否自动显示选择结果 */
@property (assign, nonatomic)BOOL autoChange;

/** 动画时间间隔 默认 0.2s*/
@property (nonatomic, assign) NSTimeInterval interval;
//建议 NSFontAttributeName 和 NSForegroundColorAttributeName一同设置
/** 选择器文本内容字体属性,默认:蓝色,14号 */
@property (strong, nonatomic)NSDictionary *textAttributes;
/** 按钮标题字体属性,默认:蓝色,14号 */
@property (strong, nonatomic)NSDictionary *titleAttributes;

+ (instancetype)showInView:(UIView *)view datas:(NSArray *)datas didSelectWithBlock:(LQCityPickerHandler)block cancelBlock:(LQCityPickerCancelHandler)cancel ;

- (void)show ;
- (void)dismiss ;

- (void)loadDatas:(NSArray *)datas;
@end
