//
//  HKCommunityDetailCell.m
//  ErpApp
//
//  Created by midland on 2022/7/22.
//

#import "HKCommunityDetailCell.h"
#import "HKHouseCommon.h"
#import "SegmentView.h"
#import "HKHouseUtil.h"

@interface HKCommunityDetailCell()
/// 标题
@property (nonatomic, strong) UILabel  *titleLabel;
/// 地址
@property (nonatomic, strong) UILabel  *addressLabel;
/// 价格
@property (nonatomic, strong) UILabel  *priceLabel;
/// 套数
@property (nonatomic, strong) UILabel  *flatLabel;
/// 切换按钮
@property (nonatomic, strong) SegmentView *segmentView;
/// 提示
@property (nonatomic, strong) UILabel  *tipLabel;
/// 分割线
@property (nonatomic, strong) UIView  *separatorView;

@end

@implementation HKCommunityDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self createUI];
    }
    return self;
}

- (void)setDetailModel:(HKCommunityDetailModel *)detailModel {
    _detailModel = detailModel;
    BOOL isCNY = [[HKHouseUtil shareManager] isCNY];
    [self setContent:isCNY];
}

- (void)setContent:(BOOL)isCNY {
    self.titleLabel.text = self.detailModel.nameChi;
    self.addressLabel.text = self.detailModel.address;
    NSNumber *rate = [[HKHouseUtil shareManager] rate];
    [self.priceLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        CGFloat minPrice = [self.detailModel.minPrice doubleValue];
        CGFloat transforMinPrice = isCNY ? minPrice : minPrice/[rate doubleValue];
        CGFloat maxPrice = [self.detailModel.maxPrice doubleValue];
        CGFloat transforMaxPrice = isCNY ? maxPrice : maxPrice/[rate doubleValue];
        if (isCNY) {
            confer.text([NSString stringWithFormat:@"%.0f-%.0f万",(transforMinPrice/10000.0),(transforMaxPrice/10000.0)]).font(kFontBoldSize6(17)).textColor(HEX_RGB(0xFF0028));
        } else {
            confer.text([NSString stringWithFormat:@"%.0f-%.0f萬",(transforMinPrice/10000.0),(transforMaxPrice/10000.0)]).font(kFontBoldSize6(17)).textColor(HEX_RGB(0xFF0028));
        }
        
        confer.text(@" ");
        confer.text(@"售价").font(kFontSize6(10)).textColor(HEX_RGB(0xBFB9AC));
    }];
    
    [self.flatLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text([NSString stringWithFormat:@"%@套",self.detailModel.sellCount]).font(kFontBoldSize6(17)).textColor(HEX_RGB(0xFF0028));
        confer.text(@" ");
        confer.text(@"在售").font(kFontSize6(10)).textColor(HEX_RGB(0xBFB9AC));
    }];
}

- (void)createUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.flatLabel];
    [self.contentView addSubview:self.segmentView];
    [self.contentView addSubview:self.tipLabel];
    [self.contentView addSubview:self.separatorView];
    
    
    [self layout];
}

- (void)layout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-40);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(10);
    }];
    
    [self.flatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).offset(20);
        make.centerY.equalTo(self.priceLabel);
    }];
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(24);
        make.top.equalTo(self.flatLabel.mas_bottom);
        make.right.mas_equalTo(-15);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom).offset(30);
        make.right.equalTo(self).offset(-15);
    }];
    
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(2);
        make.bottom.equalTo(self.contentView);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.text = @"这里是小区名称巴拉巴拉";
        _titleLabel.font = kFontBoldSize6(24);
//        _titleLabel.textColor = rzHColor(51);
    }
    return _titleLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.numberOfLines = 0;
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _addressLabel.text = @"这里是小区在香港的详细地址";
        _addressLabel.font = kFontSize6(13);
        _addressLabel.textColor = HEX_RGB(0x909399);
    }
    return _addressLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.text = @"886-1288万";
        _priceLabel.font = kFontSize6(13);
        _priceLabel.textColor = HEX_RGB(0x909399);
    }
    return _priceLabel;
}

- (UILabel *)flatLabel {
    if (!_flatLabel) {
        _flatLabel = [[UILabel alloc]init];
        _flatLabel.text = @"231套";
        _flatLabel.font = kFontSize6(13);
        _flatLabel.textColor = HEX_RGB(0x909399);
    }
    return _flatLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.numberOfLines = 0;
        _tipLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _tipLabel.text = @"*港币兑人民币汇率存在波动，价格会随汇率变化";
        _tipLabel.font = kFontSize6(10);
        _tipLabel.textColor = HEX_RGB(0xB7B7B7);
    }
    return _tipLabel;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = kColorLineGray;
    }
    return _separatorView;
}

- (SegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[SegmentView alloc] initWithFrame:CGRectMake(self.width-40, 90, 90, 24)];
        _segmentView.layer.cornerRadius = 12;
        _segmentView.layer.borderColor = HEX_RGB(0xBFA475).CGColor;
        _segmentView.layer.borderWidth = 1.0f;
        _segmentView.layer.masksToBounds = YES;
        LazyWeakSelf
        [[NSNotificationCenter defaultCenter]addObserverForName:@"SwitchCurrencyCallBack" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            BOOL isCNY = [note.object boolValue];
            [HKHouseUtil shareManager].isCNY = isCNY;
            [weakSelf setContent:isCNY];
        }];
    }
    return _segmentView;
}


@end
