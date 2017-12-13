
# LZCityPicker
一个简单的全国城市地区选择器, 完美实现三级联动, 不会因为滑动引起crash, 使用简单.
继承自'UIView', 可定制性高, 内部由多个视图实现, 子视图使用懒加载模式, 不必担心多余的视图被创建.

# 使用

初始化十分简单, 只需要调用我提供的方法即可, 不需要手动添加视图, 方法内实现了视图添加, 只需要调用方法后, 配置一些需要的属性即可:
<br>例如:

```
// 初始化视图
    LZCityPickerView *picker = [LZCityPickerView showInView:self.view didSelectWithBlock:^(NSString *address, NSString *province, NSString *city, NSString *area) {
        // 选择结果回调
        self.addressLabel.text = address;
        NSLog(@"%@--%@--%@--%@",address,province,city,area);
    }];
    
    // 配置属性
    picker.autoChange = YES;
    picker.backgroundImage = [UIImage imageNamed:@"40fe711f9b754b596159f3a6.jpg"];

    picker.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]};
    picker.titleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]};
    
```

或者, 直接使用**LZCityPickerController**, 这里增加了一个透明背景, 使用非常简单:
```
[LZCityPickerController showPickerInViewController:self selectBlock:^(NSString *address, NSString *province, NSString *city, NSString *area) {
        
        // 选择结果回调
        self.addressLabel.text = address;
        NSLog(@"%@--%@--%@--%@",address,province,city,area);

    }];
  
```

**block**用于返回结果, 只需要将当前控制器传过去即可;

# 示意图

![示意图](https://github.com/LQQZYY/LZCityPicker/blob/master/pic.gif)
![自动回调选择示意图](https://github.com/LQQZYY/LZCityPicker/blob/master/pic1.gif)
    
