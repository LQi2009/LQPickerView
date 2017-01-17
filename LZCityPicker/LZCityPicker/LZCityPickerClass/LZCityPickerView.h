//
//  LZCityPickerView.h
//  LZCityPicker
//
//  Created by Artron_LQQ on 16/8/29.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^backBlock)(NSString *address, NSString *province,NSString *city,NSString *area);

@interface LZCityPickerView : UIView
/** 是否自动显示选择结果 */
@property (assign, nonatomic)BOOL autoChange;
/** 设置背景图片,带有模糊效果 */
@property (strong, nonatomic)UIImage *backgroundImage;

//建议 NSFontAttributeName 和 NSForegroundColorAttributeName一同设置
/** 选择器文本内容字体属性,默认:蓝色,14号 */
@property (strong, nonatomic)NSDictionary *textAttributes;
/** 按钮标题字体属性,默认:蓝色,14号 */
@property (strong, nonatomic)NSDictionary *titleAttributes;
/**
 *  @author LQQ, 16-08-30 11:08:49
 *
 *  创建,添加选择器
 *
 *  @param vc 添加到的视图
 *  @param block 选择结果回调
 *
 *  @return 选择器实例
 */
+ (instancetype)showInView:(UIView *)view didSelectWithBlock:(backBlock)block;

//+ (void)autoChangeValue:(BOOL)isAuto;
//+ (void)
@end
