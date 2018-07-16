//
//  LQPickerItem.m
//  LQToolKit-ObjectiveC
//
//  Created by LiuQiqiang on 2018/7/15.
//  Copyright © 2018年 QiqiangLiu. All rights reserved.
//

#import "LQPickerItem.h"

@implementation LQPickerItem

- (void) loadData:(NSInteger)count config:(void(^)(LQPickerItem *item, NSInteger index)) config {
    
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

// ===============================================

@implementation LQPickerProvince

- (void) loadCity:(NSInteger )count config:(void(^)(LQPickerCity *city, NSInteger index)) config {
    
    NSMutableArray *temps = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        LQPickerCity *city = [[LQPickerCity alloc]init];
        if (config) {
            config(city, i);
        }
        
        [temps addObject:city];
    }
    
    self.cities = [NSArray arrayWithArray:temps];
}

- (void)configWithDic:(NSDictionary *)dic {
    
    NSArray *citys = [dic allKeys];
    
    NSMutableArray *tmpCitys = [NSMutableArray arrayWithCapacity:citys.count];
    for (NSString *tmp in citys) {
        
        LQPickerCity *city = [[LQPickerCity alloc]init];
        city.name = tmp;
        city.province = self.name;
        NSArray *area = [dic objectForKey:tmp];
        
        [city configWithArr:area];
        [tmpCitys addObject:city];
        
    }
    
    self.cities = [tmpCitys copy];
}
@end

@implementation LQPickerCity

- (void) loadCity:(NSInteger )count config:(void(^)(LQPickerArea *area, NSInteger index)) config {
    
    NSMutableArray *temps = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        LQPickerArea *city = [[LQPickerArea alloc]init];
        if (config) {
            config(city, i);
        }
        
        [temps addObject:city];
    }
    
    self.areas = [NSArray arrayWithArray:temps];
}

- (void)configWithArr:(NSArray *)arr {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:arr.count];
    for (NSString *tmp in arr) {
        
        LQPickerArea *area = [[LQPickerArea alloc]init];
        area.name = tmp;
        area.province = self.province;
        area.city = self.name;
        [array addObject:area];
    }
    
    self.areas = [array copy];
}
@end

@implementation LQPickerArea

- (NSString *)address {
    
    return [NSString stringWithFormat:@"%@-%@-%@", self.province, self.city, self.name];
}
@end
