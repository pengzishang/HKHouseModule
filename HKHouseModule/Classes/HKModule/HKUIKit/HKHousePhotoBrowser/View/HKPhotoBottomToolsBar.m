/*******************************************************************************
 # File        : PhotoBottomToolsBar.m
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

#import "HKPhotoBottomToolsBar.h"
#import "HKHouseCommon.h"

@interface HKPhotoBottomToolsBar ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scroView;

@property (nonatomic, strong) NSMutableArray <UIButton *> *buttons;

@end

@implementation HKPhotoBottomToolsBar

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.height = 60;
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化默认数据
        [self createDefaultData];
        // 初始化界面
        [self createUI];
        // 布局界面
        [self createConstraints];
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    _buttons = [NSMutableArray new];
    _currentIndex = 0;
}

#pragma mark - 初始化界面
- (void)createUI {
    _scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    [self addSubview:_scroView];
    _scroView.delegate = self;
}

#pragma mark - 布局界面
- (void)createConstraints {
    
}

- (void)setTitles:(NSArray *)titles {
    _titles = [NSArray arrayWithArray:titles];
    [_buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [_buttons removeAllObjects];
    
    for (int i = 0; i < titles.count; i++) {
        NSString *title = [titles safeObjectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.titleLabel.font = kFontSize6(12);
        [button setTitle:title forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 3;
        button.frame = ({
            UIButton *leftBtn = [self.buttons safeObjectAtIndex:i - 1];
            CGRect frame = CGRectMake(0, 15, title.length * button.titleLabel.font.pointSize, 30);
            frame.origin.x = CGRectGetMaxX(leftBtn.frame) + 10;
            frame;
        });
        [_scroView addSubview:button];
        [_buttons addObject:button];
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _scroView.contentSize = CGSizeMake(CGRectGetMaxX(button.frame) + 10, 60);
    }
    [self setHighliteButton];
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    _currentIndex = currentIndex;
    
    [self setHighliteButton];
}

- (void)setHighliteButton {
    LazyWeakSelf;
    [_buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == weakSelf.currentIndex) {
            obj.backgroundColor = RGB(52,69,88);
        
            // 让当前选中的居中
            CGFloat xPoint = obj.center.x;
            xPoint -= (kScreenWidth/2);
            if (xPoint > _scroView.contentSize.width - kScreenWidth) {
                xPoint = _scroView.contentSize.width - kScreenWidth;
            }
            if (xPoint < 0) {
                xPoint = 0;
            }
            [_scroView setContentOffset:CGPointMake(xPoint, 0) animated:YES];
        } else {
            obj.backgroundColor = [UIColor clearColor];
        }
    }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)buttonClicked:(UIButton *)sender {
    if (_currentIndex == sender.tag) {
        return ;
    }
    self.currentIndex = sender.tag;
    if (self.DidClickedIndex) {
        self.DidClickedIndex(_currentIndex);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end
