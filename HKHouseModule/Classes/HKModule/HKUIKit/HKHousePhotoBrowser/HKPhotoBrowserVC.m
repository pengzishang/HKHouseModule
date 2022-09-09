/*******************************************************************************
 # File        : PhotoBrowserViewController.m
 # Project     : ErpApp
 # Author      : rztime
 # Created     : 2017/12/23
 # Corporation : 成都好房通科技股份有限公司
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "HKPhotoBrowserVC.h"
#import "HKPhotoBrowserNavBar.h"
#import "HKHouseCommon.h"
#import "HKPhotoBottomToolsBar.h"

@interface HKPhotoBrowserVC ()
// 导航栏
@property (nonatomic, strong) HKPhotoBrowserNavBar *navBar;
// 底部的工具条
@property (nonatomic, strong) HKPhotoBottomToolsBar *bottomToolsBar;

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, assign) BOOL toolBarHadHide;

@property (nonatomic, assign) NSUInteger showIndex;
@end

@implementation HKPhotoBrowserVC

- (instancetype)init {
    if (self = [super init]) {
        _showNavRightButton = YES;
    }
    return self;
}

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    _showIndex = -1;
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.currentIndex == 0) {
        [self scrollCompleteActionWithIndex:0];
    }    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    
}

#pragma mark - 初始化界面
- (void)createUI {
    [self bottomToolsBar];
}

- (void)configCustomNaviBar {
    [self navBar];
}

- (HKPhotoBrowserNavBar *)navBar {
    if (!_navBar) {
        _navBar = [[HKPhotoBrowserNavBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
        [self.view addSubview:_navBar];
        LazyWeakSelf;
        [_navBar.backButton bk_addEventHandler:^(id sender) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } forControlEvents:UIControlEventTouchUpInside];
        _navBar.rightButton.hidden = !_showNavRightButton;
        [_navBar.rightButton addTarget:self action:@selector(navBarRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBar;
}

- (HKPhotoBottomToolsBar *)bottomToolsBar {
    if (!_bottomToolsBar) {
        _bottomToolsBar = [[HKPhotoBottomToolsBar alloc]initWithFrame:CGRectMake(0, self.view.height - kSafeBottomMargin - 60, kScreenWidth, 60)];
        [self.view addSubview:_bottomToolsBar];
        LazyWeakSelf;
        _bottomToolsBar.DidClickedIndex = ^(NSUInteger currentIndex) {
            [weakSelf bottomToolsBarDidChangedIndex:currentIndex];
        };
        
        NSMutableArray *titles = [NSMutableArray new];
        NSMutableArray *models = [NSMutableArray new];
        [_photos enumerateObjectsUsingBlock:^(HKPhotoBrowserItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = [NSString stringWithFormat:@"%@(%ld)", obj.title, obj.photos.count];
            [titles addObject:title];
            [models addObjectsFromArray:obj.photos];
        }];
        [self.bottomToolsBar setTitles:titles.copy];
        super.models = models.copy;
    }
    return _bottomToolsBar;
}

#pragma mark ----------------------------- 其他方法 ------------------------------
- (void)navBarRightButtonClicked:(UIButton *)sender {
    sender.enabled = NO;
    if (_didClickedNavBarRightButton) {
        _didClickedNavBarRightButton();
    }
    sender.enabled = YES;
}

- (void)viewTapAction {
    if (_animating) {
        return ;
    }
    _animating = YES;
    [UIView animateWithDuration:0.3 animations:^{
        if (_toolBarHadHide) {
            // 显示
            self.navBar.frame = ({
                CGRect frame = self.navBar.frame;
                frame.origin.y = 0;
                frame;
            });
            self.bottomToolsBar.alpha = 1;
            self.bottomToolsBar.frame = ({
                CGRect frame = self.bottomToolsBar.frame;
                frame.origin.y = self.view.height - kSafeBottomMargin - frame.size.height;
                frame;
            });
        } else {
            // 隐藏
            self.navBar.frame = ({
                CGRect frame = self.navBar.frame;
                frame.origin.y = -frame.size.height;
                frame;
            });
            self.bottomToolsBar.alpha = 0;
            self.bottomToolsBar.frame = ({
                CGRect frame = self.bottomToolsBar.frame;
                frame.origin.y = kScreenHeight;
                frame;
            });
        }
        _toolBarHadHide = !_toolBarHadHide;
    } completion:^(BOOL finished) {
        _animating = NO;
    }];
}
#pragma mark ----------------------------- 公用方法 ------------------------------
/**
 滚动完成后要处理的事
 */
- (void)scrollCompleteActionWithIndex:(NSInteger)index {
    if (index != self.showIndex) {
        self.showIndex = index;
        
        __block NSUInteger count = 0;
        __block NSString *title = @"";
        __block NSUInteger toolsBarIndex = 0;
        [self.photos enumerateObjectsUsingBlock:^(HKPhotoBrowserItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (index < count + obj.photos.count) {
                title = [NSString stringWithFormat:@"%@(%ld/%ld)", obj.title, index - count + 1, obj.photos.count];
                toolsBarIndex = idx;
                *stop = YES;
            } else {
                count += obj.photos.count;
            }
        }];
        
        self.navBar.titleLabel.text = title;
        self.bottomToolsBar.currentIndex = toolsBarIndex;
    }
}

- (void)bottomToolsBarDidChangedIndex:(NSUInteger )index{
    __block NSUInteger mayBeIndex = 0;
    [self.photos enumerateObjectsUsingBlock:^(HKPhotoBrowserItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < index) {
            mayBeIndex += obj.photos.count;
        } else {
            *stop = YES;
        }
    }];
    self.currentIndex = mayBeIndex;
    LazyWeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.currentIndex >= 0) {
            [weakSelf.collectionView setContentOffset:CGPointMake((weakSelf.view.width + 20) * weakSelf.currentIndex, 0) animated:NO];
        }
    });
}
#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------
// 重写父类单击cell返回时间，用于隐藏导航栏和底部toolsbar
- (void)backButtonClick {
    [self viewTapAction];
}
#pragma mark --------------------------- setter&getter -------------------------


@end
