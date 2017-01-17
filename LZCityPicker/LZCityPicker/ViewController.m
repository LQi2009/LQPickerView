//
//  ViewController.m
//  LZCityPicker
//
//  Created by Artron_LQQ on 16/8/29.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "ViewController.h"
#import "LZCityPickerView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}
- (IBAction)buttonClick:(id)sender {
    
    // 初始化视图
    LZCityPickerView *picker = [LZCityPickerView showInView:self.view didSelectWithBlock:^(NSString *address, NSString *province, NSString *city, NSString *area) {
        // 选择结果回调
        self.addressLabel.text = address;
        NSLog(@"%@--%@--%@--%@",address,province,city,area);
    }];
    
    // 配置属性
    picker.autoChange = YES;
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
