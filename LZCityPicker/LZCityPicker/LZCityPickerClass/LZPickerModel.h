//
//  LZPickerModel.h
//  LZCityPicker
//
//  Created by Artron_LQQ on 2017/1/20.
//  Copyright © 2017年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZPickerModel : NSObject

@property (nonatomic, copy) NSString* name;
@end

@interface LZProvince : LZPickerModel

@property (nonatomic, strong) NSArray *cities;
- (void)configWithDic:(NSDictionary *)dic;
@end

@interface LZCity : LZPickerModel

@property (nonatomic, copy) NSString *province;
@property (nonatomic, strong) NSArray *areas;
- (void)configWithArr:(NSArray *)arr;
@end

@interface LZArea : LZPickerModel

//@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@end
