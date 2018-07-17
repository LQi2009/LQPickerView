//
//  ViewController.m
//  LZCityPicker
//
//  Created by Artron_LQQ on 16/8/29.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "ViewController.h"
//#import "LZCityPickerView.h"
//#import "LZCityPickerController.h"
#import "LQCityPicker.h"
#import "LQPickerView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ViewController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadData];
    
}

#pragma mark - /** 加载数据源 */
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

- (IBAction)buttonClick:(id)sender {
    
    __weak typeof(self)ws = self;
    [LQCityPicker showInView:self.view datas:self.dataSource didSelectWithBlock:^(NSArray *objs, NSString *dsc) {
        NSLog(@"%@\n%@", objs, dsc);
        ws.addressLabel.text = dsc;
    } cancelBlock:^{
        NSLog(@"cancel");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
