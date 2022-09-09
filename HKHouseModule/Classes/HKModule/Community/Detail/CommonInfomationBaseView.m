//
//  CommonInfomationBaseView.m
//  ErpApp
//
//  Created by midland on 2022/8/8.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "CommonInfomationBaseView.h"
#import "HKHouseCommon.h"

@implementation CommonInfomationBaseViewModel

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        self.left = 118;
//    }
//    return self;
//}

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content {
    self = [super init];
    if (self) {
        self.title = [title isExist] ? title : @"--";
        self.content = [content isExist] ? content : @"--";
    }
    return self;
}

@end

@interface CommonInfomationBaseView ()

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *contentLabel;

@end

@implementation CommonInfomationBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.mLeft = 118;
        [self createSubView];
    }
    return self;
}


- (void)createSubView {
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(self);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mLeft);
        make.top.equalTo(self.titleLabel);
        make.right.mas_equalTo(-13);
        make.bottom.equalTo(self);
    }];
    
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.eq
//    }];
}

- (void)setMLeft:(NSInteger)mLeft {
    _mLeft = mLeft;
    if (self.contentLabel.superview == nil) {
        return;
    }
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mLeft);
    }];
}

- (void)setModel:(CommonInfomationBaseViewModel *)model {
    _model = model;
    self.contentLabel.text = model.content;
    self.titleLabel.text = model.title;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFontSize6(13);
        _titleLabel.textColor = HEX_RGB(0x909399);
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = kFontSize6(15);
        _contentLabel.textColor = HEX_RGB(0x4E4F54);
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
