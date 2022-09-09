//
//  SegementPhotoView.m
//  ErpApp
//
//  Created by midland on 2022/8/9.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "SegementPhotoView.h"
#import "HKHouseCommon.h"

#define kButtonWidth 50

@interface SegementPhotoView()

@property (nonatomic, strong)NSMutableArray<UIButton *> *buttons;

@property (nonatomic, strong)UIView *caverView;

@end

@implementation SegementPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.height = 22;
        self.layer.cornerRadius = self.height/2.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        
        [self createDefaultData];
        
        [self addSubview:self.caverView];
    }
    return self;
}

- (void)createDefaultData {
    self.selectIndex = 0;
    _dataSource = [NSArray array];
    _buttons = [NSMutableArray array];
}

/// 切换选中的下标
- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    
    
    if (self.buttons == nil || self.buttons.count == 0) {
        return;
    }
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (selectIndex == idx) {
            obj.selected = YES;
            self.caverView.frame = obj.frame;
        }else {
            obj.selected = NO;
        }
    }];
}

- (void)commonSetter {
    
}

- (void)setDataSource:(NSArray *)dataSource {
    if (dataSource.count == 0) {
        return;
    }
    _dataSource = dataSource;
    self.width = kButtonWidth*dataSource.count;
    
    
    CGFloat buttonHeight = self.height;
    
    [_dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [self createSelectButton:obj index:idx selected: idx == self.selectIndex];
        button.frame = CGRectMake(kButtonWidth*idx, 0, kButtonWidth, buttonHeight);
        [self addSubview:button];
        [_buttons addObject:button];
        
        /// 设置
        if (self.selectIndex == idx) {
            self.caverView.frame = button.frame;
        }
    }];
}

- (UIButton *)createSelectButton:(NSString *)title index:(NSInteger)index selected:(BOOL)isSelected {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:kFontSize6(10)];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    btn.tag = index;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor]
              forState:UIControlStateSelected];
    btn.selected = isSelected;
    [btn addTarget:self action:@selector(clickedSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)clickedSelectButton:(UIButton *)sender {
    self.selectIndex = sender.tag;
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = idx == sender.tag;
    }];
    
    self.caverView.frame = sender.frame;
    
    EXECUTE_BLOCK(self.selectBlock, self.selectIndex);
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


- (UIView *)caverView {
    if (!_caverView) {
        _caverView = [[UIView alloc] init];
        _caverView.backgroundColor = HEX_RGB(0xBFA475);
        _caverView.layer.cornerRadius = self.height/2;
        _caverView.layer.masksToBounds = YES;
    }
    return _caverView;
}

@end
