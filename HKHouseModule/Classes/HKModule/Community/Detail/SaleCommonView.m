//
//  SaleCommonView.m
//  ErpApp
//
//  Created by midland on 2022/8/8.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "SaleCommonView.h"
#import "HKHouseCommon.h"
#import "HKHouseUtil.h"

@implementation SaleCommonModel

@end

@interface SaleCommonView ()

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UIImageView *imgView;

@property (nonatomic, strong)UILabel *desLabel;

@end

@implementation SaleCommonView

- (instancetype)initWithModel:(SaleCommonModel *)model frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        self.model = model;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)setModel:(SaleCommonModel *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    self.imgView.image = rzImage(model.imgString);
    self.desLabel.text = model.des;
    [self.desLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(model.des).textColor(HEX_RGB(0x909399)).font(kFontSize6(13));
        if (model.subDes) {
            confer.text(@"\n");
            confer.text(model.subDes).textColor(HEX_RGB(0x909399)).font(kFontSize6(8));
        }
    }];
}

- (void)setValue:(NSString *)value {
    _value = value;
    self.model.title = value;
    self.titleLabel.text = value;
}

- (void)makePriceStyle:(NSString *)price {
//    ￥5432万
    BOOL isCNY = [[HKHouseUtil shareManager] isCNY];
    if (isCNY) {
        NSString *string = [NSString stringWithFormat:@"¥%@万",price];
        self.titleLabel.text = string;
        NSMutableAttributedString *attrStr = self.titleLabel.attributedText.mutableCopy;
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:NSMakeRange(0, 1)];
        self.titleLabel.attributedText = attrStr;
    } else {
//        HK$5432萬
        NSString *string = [NSString stringWithFormat:@"HK$%@萬",price];
        self.titleLabel.text = string;
        NSMutableAttributedString *attrStr = self.titleLabel.attributedText.mutableCopy;
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:NSMakeRange(0, 3)];
        self.titleLabel.attributedText = attrStr;
    }
}

- (void)makeAreaStyle:(NSString *)area {
//    ￥5432万
    BOOL isCNY = [[HKHouseUtil shareManager] isCNY];
    if (isCNY) {
        NSString *string = [NSString stringWithFormat:@"%@元/㎡",area];
        self.titleLabel.text = string;
    } else {
//      HK$86856/呎
        NSString *string = [NSString stringWithFormat:@"HK$%@/呎",area];
        self.titleLabel.text = string;
        NSMutableAttributedString *attrStr = self.titleLabel.attributedText.mutableCopy;
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:NSMakeRange(0, 3)];
        self.titleLabel.attributedText = attrStr;
    }
}

- (void)createUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.imgView];
    [self addSubview:self.desLabel];
    
    [self layout];
}

- (void)layout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-10);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
//        make.width.height.mas_equalTo(20);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).offset(5);
        make.top.equalTo(self.imgView.mas_top);
        make.right.equalTo(self.titleLabel.mas_right);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"23套";
        _titleLabel.font = kFontBoldSize6(15);
        _titleLabel.textColor = HEX_RGB(0x4E4F54);
    }
    return _titleLabel;
}

- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.text = @"近30日成交";
        _desLabel.font = kFontSize6(13);
        _desLabel.textColor = HEX_RGB(0x909399);
        _desLabel.numberOfLines = 0;
    }
    return _desLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = rzImage(@"平均成交价");
    }
    return _imgView;
}

@end
