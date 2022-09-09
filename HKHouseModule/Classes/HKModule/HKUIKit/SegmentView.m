//
//  SegmentView.m
//  ErpApp
//
//  Created by midland on 2022/7/22.
//

#import "SegmentView.h"
#import "HKHouseCommon.h"
#import "HKHouseUtil.h"

#define kSelectButtonBaseTag 12453
@interface SegmentView()

@property (nonatomic, strong)NSArray *dataSource;
/// 选中的标签，默认为1
@property (nonatomic, assign)NSInteger selectIndex;

@property (nonatomic, strong)NSMutableArray<UIButton *> *buttons;

@end

@implementation SegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = @[@"港币",@"人民币"];
        self.buttons = [NSMutableArray array];
        BOOL isCNY = [HKHouseUtil shareManager].isCNY;
        self.selectIndex = isCNY ? 1 : 0;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    CGFloat buttonWidth = self.width/self.dataSource.count;
    
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [self createSelectButton:obj index:idx isSelected:idx == self.selectIndex];
        [self.buttons addObject:button];
        
        [self addSubview:button];
        button.frame = CGRectMake(idx*buttonWidth, 0, buttonWidth, self.height);
    }];
}

- (UIButton *)createSelectButton:(NSString *)title index:(NSInteger)index isSelected:(BOOL)isSelected {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:kFontSize6(10)];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    btn.tag = kSelectButtonBaseTag + index;
    btn.backgroundColor = RGBGRAY(240);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:HEX_RGB(0xBFA475) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor]
              forState:UIControlStateSelected];
    [btn setBackgroundImage:[self imageWithColor:HEX_RGB(0xBFA475)] forState:UIControlStateSelected];
    [btn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    btn.selected = isSelected;
    [btn addTarget:self action:@selector(clickedSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)clickedSelectButton:(UIButton *)sender {
    //更新选中条件
    NSString *title = self.dataSource[sender.tag-kSelectButtonBaseTag];

    NSLog(@"选中了--%@",title);
    [self.buttons bk_each:^(UIButton *obj) {
        obj.selected = obj == sender;
    }];
    BOOL isCNY = sender.tag != kSelectButtonBaseTag;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SwitchCurrencyCallBack" object:@(isCNY) userInfo:nil];
}

//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
