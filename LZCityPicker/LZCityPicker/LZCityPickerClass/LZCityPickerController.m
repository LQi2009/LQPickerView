//
//  LZCityPickerController.m
//  LZCityPicker
//
//  Created by Artron_LQQ on 2017/1/20.
//  Copyright © 2017年 Artup. All rights reserved.
//

#import "LZCityPickerController.h"
#import "LZCityPickerView.h"

@interface LZCityPickerController ()

@property (nonatomic, strong) CALayer *maskLayer;
@property (nonatomic, strong) LZCityPickerView *cityPicker;
@property (nonatomic, copy) __actionBlock backBlock;
@end

@implementation LZCityPickerController

- (CALayer *)maskLayer {
    if (_maskLayer == nil) {
        _maskLayer = [CALayer layer];
        _maskLayer.backgroundColor = [UIColor blackColor].CGColor;
        _maskLayer.opacity = 0.2;
    }
    
    return _maskLayer;
}
- (void)dealloc {
    NSLog(@"LZCityPickerController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.maskLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.maskLayer];
    
    __weak typeof(self)ws = self;
    _cityPicker = [LZCityPickerView showInView:self.view didSelectWithBlock:^(NSString *address, NSString *province, NSString *city, NSString *area) {
        
        if (ws.backBlock) {
            ws.backBlock(address, province, city, area);
        }
    } cancelBlock:^{
        
        [ws.view removeFromSuperview];
        [ws removeFromParentViewController];
    }];
    
    // picker的一些属性可以在这里配置

//    _cityPicker.type = LZPickerTypeCity;
//        _cityPicker.autoChange = YES;
//        _cityPicker.backgroundImage = [UIImage imageNamed:@"40fe711f9b754b596159f3a6.jpg"];
//    
//        _cityPicker.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]};
//        _cityPicker.titleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]};
}

+ (instancetype)showPickerInViewController:(UIViewController *)vc selectBlock:(__actionBlock)block {
    
    LZCityPickerController *picker = [[LZCityPickerController alloc]init];
    
    picker.backBlock = block;
    [vc addChildViewController:picker];
    [vc.view addSubview:picker.view];
    return picker;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    __weak typeof(self)ws = self;
    [_cityPicker dismissWithBlock:^{
        
        [ws.view removeFromSuperview];
        [ws removeFromParentViewController];
       
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
