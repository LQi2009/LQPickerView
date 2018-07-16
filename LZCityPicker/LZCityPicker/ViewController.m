//
//  ViewController.m
//  LZCityPicker
//
//  Created by Artron_LQQ on 16/8/29.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "ViewController.h"
#import "LZCityPickerView.h"
#import "LZCityPickerController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

//#pragma mark - /** 加载数据源 */
//- (void)loadData {
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"Address" ofType:@"plist"];
//    
//    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
//    
//    NSArray *provinces = [dic allKeys];
//    
//    for (NSString *tmp in provinces) {
//        
//        LQPickerItem *item1 = [[LQPickerItem alloc]init];
//        item1.name = tmp;
//        
//        NSArray *arr = [dic objectForKey:tmp];
//        NSDictionary *cityDic = [arr firstObject];
//        
//        NSArray *keys = cityDic.allKeys;
//        [item1 loadData:keys.count config:^(LQPickerItem *item, NSInteger index) {
//            
//            item.name = keys[index];
//            //            NSArray *area = [cityDic objectForKey:item.name];
//            //            [item loadData:area.count config:^(LQPickerItem *item, NSInteger index) {
//            //                item.name = area[index];
//            //            }];
//        }];
//        
//        [self.dataSource addObject:item1];
//    }
//}

- (IBAction)buttonClick:(id)sender {
    
    
    [LZCityPickerController showPickerInViewController:self selectBlock:^(NSString *address, NSString *province, NSString *city, NSString *area) {
        
        // 选择结果回调
        self.addressLabel.text = address;
        NSLog(@"%@--%@--%@--%@",address,province,city,area);

    }];
    
    // 初始化视图
//    LZCityPickerView *picker = [LZCityPickerView showInView:self.view didSelectWithBlock:^(NSString *address, NSString *province, NSString *city, NSString *area) {
//        // 选择结果回调
//        self.addressLabel.text = address;
//        NSLog(@"%@--%@--%@--%@",address,province,city,area);
//    }];
//    
//    // 配置属性
//    picker.autoChange = YES;
//    picker.backgroundImage = [UIImage imageNamed:@"40fe711f9b754b596159f3a6.jpg"];
//
//    picker.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]};
//    picker.titleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
