//
//  HKNewHouseVC.m
//  ErpApp
//
//  Created by midland on 2022/7/14.
//

#import "HKNewHouseVC.h"
#import "HKHouseCommon.h"
#import <HFTWebKit/HFTBaseWebViewController.h>
#import <GlobalDataCacher/GDC+CompanyStaff.h>

@interface HKNewHouseVC ()

@property (nonatomic, strong) HFTBaseWebViewController *HKWebView;

@end

@implementation HKNewHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _HKWebView = [HFTBaseWebViewController new];
    NSString *url = [NSString stringWithFormat:@"%@%@", [APPNetworkHelper getHKBaseUrl], @"houseExchangeWeb/index.html#/app"];
//    NSString *url = @"https://recms.midland.com.cn/houseExchangeWeb/index.html#/app";
    _HKWebView.netUrl = url;
    _HKWebView.showLoadingView = YES;
    _HKWebView.view.frame = CGRectMake(0, 8, kScreenWidth, self.view.height);
    [self addChildViewController:_HKWebView];
    [self.view addSubview:_HKWebView.view];
    
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
