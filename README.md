
# LQPickerView

对UIPickerView的封装，完美实现多级联动！
内部封装了一个model：LQPickerItem，实现了外部不需考虑内部的数据分配及选择逻辑，只需要按照一定规则包装数据，即可完美实现数据的显示及选择；
选择器显示几级数据，完全依靠数据源的结构，内部自动返回列数，不需要额外设置。
 
 其属性和方法都有注释，也比较简单，直接看源码即可！
 
 ### LQPickerItem
 
 ```
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
```

此model设置了三个属性及一个方法：<br>
name属性：主要是选择器显示的文字，在配置数据的时候是必须要设置的；<br>
obj属性：是保存其他的数据信息的，如果其他的信息需要使用不同的属性来记录，可以创建LQPickerItem的子类来添加多个属性；<br>
datas属性：主要是用来保存其二级菜单数据的，内部元素同样是LQPickerItem实例对象，此值也是内部判断是否有下一级选择的依据；<br>
loadData方法：主要是用来为其属性datas内元素进行赋值的回调；当前，如果完全在外部创建实例，只要其结构一致即可！<br>
datas属性内的元素一定要是LQPickerItem，如此逐级嵌套！<br>

# LQCityPicker
基于LQPickerView实现的一个简单的全国城市地区选择器, 完美实现三级联动, 不会因为滑动引起crash, 使用简单

以此来说明如何配置数据源，来实现显示多级数据，这里是加载了一个地址信息的plist文件，其数据结构是这样的：

![地址数据结构](https://github.com/LQi2009/LQPickerView/blob/master/地址数据结构.png)

加载数据源的方法为：
```
- (void)loadData {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Address" ofType:@"plist"];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
    
    NSArray *provinces = [dic allKeys];
    
    for (NSString *tmp in provinces) {
        
        // 创建第一级数据
        LQPickerItem *item1 = [[LQPickerItem alloc]init];
        item1.name = tmp;
        
        NSArray *arr = [dic objectForKey:tmp];
        NSDictionary *cityDic = [arr firstObject];
        
        NSArray *keys = cityDic.allKeys;
        // 配置第二级数据
        [item1 loadData:keys.count config:^(LQPickerItem *item, NSInteger index) {
            
            item.name = keys[index];
            NSArray *area = [cityDic objectForKey:item.name];
            // 配置第三极数据
            [item loadData:area.count config:^(LQPickerItem *item, NSInteger index) {
                item.name = area[index];
            }];
        }];
        
        [self.dataSource addObject:item1];
    }
}

```
这样便有一个三级的地址选择器：

![三级数据](https://github.com/LQi2009/LQPickerView/blob/master/三级数据.png)

如果将上述加载的方法的第三极数据注释掉，即：
```
- (void)loadData {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Address" ofType:@"plist"];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
    
    NSArray *provinces = [dic allKeys];
    
    for (NSString *tmp in provinces) {
        
        // 创建第一级数据
        LQPickerItem *item1 = [[LQPickerItem alloc]init];
        item1.name = tmp;
        
        NSArray *arr = [dic objectForKey:tmp];
        NSDictionary *cityDic = [arr firstObject];
        
        NSArray *keys = cityDic.allKeys;
        // 配置第二级数据
        [item1 loadData:keys.count config:^(LQPickerItem *item, NSInteger index) {
            
            item.name = keys[index];
//            NSArray *area = [cityDic objectForKey:item.name];
//            // 配置第三极数据
//            [item loadData:area.count config:^(LQPickerItem *item, NSInteger index) {
//                item.name = area[index];
//            }];
        }];
        
        [self.dataSource addObject:item1];
    }
}
```

如此便有一个两级的地址选择器：

![两级数据](https://github.com/LQi2009/LQPickerView/blob/master/两级数据.png)


### LQCityPicker使用

LQCityPicker的使用, 只需要调用我提供的方法即可, 不需要手动添加视图, 方法内实现了视图添加, 只需要调用方法后, 配置一些需要的属性即可:
<br>例如:

```
// 初始化视图
   __weak typeof(self)ws = self;
    [LQCityPicker showInView:self.view datas:self.dataSource didSelectWithBlock:^(NSArray *objs, NSString *dsc) {
        NSLog(@"%@\n%@", objs, dsc);
        ws.addressLabel.text = dsc;
    } cancelBlock:^{
        NSLog(@"cancel");
    }];
    
    // 配置属性
    picker.autoChange = YES;
    picker.backgroundImage = [UIImage imageNamed:@"40fe711f9b754b596159f3a6.jpg"];

    picker.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]};
    picker.titleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]};
    
```

# 示意图

![示意图](https://github.com/LQQZYY/LZCityPicker/blob/master/pic.gif)
![自动回调选择示意图](https://github.com/LQQZYY/LZCityPicker/blob/master/pic1.gif)
    
