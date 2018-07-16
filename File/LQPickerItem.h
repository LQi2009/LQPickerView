//
//  LQPickerItem.h
//  LQToolKit-ObjectiveC
//
//  Created by LiuQiqiang on 2018/7/15.
//  Copyright © 2018年 QiqiangLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LQPickerItem : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, assign) id obj;
@property (nonatomic, copy) NSArray *datas;

- (void) loadData:(NSInteger)count config:(void(^)(LQPickerItem *item, NSInteger index)) config ;
@end



// ===============================================

@class LQPickerCity;
@interface LQPickerProvince : LQPickerItem

@property (nonatomic, strong) NSArray *cities;
- (void)configWithDic:(NSDictionary *)dic;

- (void) loadCity:(NSInteger)count config:(void(^)(LQPickerCity *city, NSInteger index)) config ;
@end

@interface LQPickerCity : LQPickerItem

@property (nonatomic, copy) NSString *province;
@property (nonatomic, strong) NSArray *areas;
- (void)configWithArr:(NSArray *)arr;
@end

@interface LQPickerArea : LQPickerItem

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy, readonly) NSString *address;
@end
