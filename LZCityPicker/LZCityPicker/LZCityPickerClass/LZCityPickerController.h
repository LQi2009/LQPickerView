//
//  LZCityPickerController.h
//  LZCityPicker
//
//  Created by Artron_LQQ on 2017/1/20.
//  Copyright © 2017年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^__actionBlock)(NSString *address, NSString *province,NSString *city,NSString *area);

@interface LZCityPickerController : UIViewController

+ (instancetype)showPickerInViewController:(UIViewController *)vc
                               selectBlock:(__actionBlock)block ;
@end
