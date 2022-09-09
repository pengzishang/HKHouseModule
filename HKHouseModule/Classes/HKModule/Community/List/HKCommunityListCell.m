//
//  HKCommunityListCell.m
//  ErpApp
//
//  Created by midland on 2022/7/18.
//

#import "HKCommunityListCell.h"
#import "HKhouseCommon.h"
#import "HKHouseUtil.h"

#define rzHColor(value) RGB(value, value, value)

/// 小区列表的cell
@interface HKCommunityListCell ()
/// 房源首图
@property (nonatomic, strong) UIImageView *houseImageView;
/// 标题
@property (nonatomic, strong) UILabel  *titleLabel;
/// 
@property (nonatomic, strong) UILabel  *areaLabel;
/// 建筑年代
@property (nonatomic, strong) UILabel  *buildYearLabel;
/// 地址
@property (nonatomic, strong) UILabel  *addressLabel;
/// 售价
@property (nonatomic, strong) UILabel  *priceLabel;
@property (nonatomic, strong) UIView  *separatorView;

@end

@implementation HKCommunityListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)setModel:(HKCommunityListModel *)model {
    _model = model;
    [self initData];
}

- (void)initData {
    BOOL isCNY = [[HKHouseUtil shareManager] isCNY];
    [self.houseImageView sd_setImageWithURL:[NSURL URLWithString:self.model.imgPath] placeholderImage:rzImage(@"global_image_placeholder_load")];
    
    self.titleLabel.text = self.model.nameChi;
    [self.areaLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(self.model.intSmDistrictName).font(kFontSize6(11)).textColor(rzHColor(51));
        confer.text(@"/ ");
        if (isCNY) {
            NSString *areaText = [NSString stringWithFormat:@"%.2f~%.2f㎡",[HKHouseUtil toSquare:[self.model.maxArea doubleValue]],[HKHouseUtil toSquare:[self.model.minArea doubleValue]]];
            confer.text(areaText).font(kFontSize6(11)).textColor(rzHColor(51));
        } else {
            NSString *areaText = [NSString stringWithFormat:@"%@~%@呎",self.model.maxArea,self.model.minArea];
            confer.text(areaText).font(kFontSize6(11)).textColor(rzHColor(51));
        }
    }];
    
    [self.buildYearLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        NSString *text = [NSString stringWithFormat:@"建筑年代：%@",[self.model.firstOpDate isExist] ? [NSDate formatDate:[NSDate dateFromString:self.model.firstOpDate formatStr:@"yyyy-MM-dd HH:mm:ss"] formatStr:@"yyyy年"] : @"--"];
        confer.text(text).font(kFontSize6(11)).textColor(rzHColor(51));
    }];
    
    /// @"近日成交 23 套丨在售 231 套";
    [self.addressLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(@"近日成交 ").font(kFontSize6(11)).textColor(rzHColor(51));
        confer.text([self.model.marketStatTxCount isExist] ? self.model.marketStatTxCount : @"--" ).font(kFontSize6(11)).textColor(kColorTheme);
        confer.text(@" 套 | 在售 ").font(kFontSize6(11)).textColor(rzHColor(51));
        confer.text([self.model.sellCount isExist] ? self.model.sellCount : @"--").font(kFontSize6(11)).textColor(kColorTheme);
        confer.text(@" 套").font(kFontSize6(11)).textColor(rzHColor(51));
    }];
    
    if ([self.model.avgNetFtPrice isExist]) {
        if ([HKHouseUtil shareManager].isCNY) {
            self.priceLabel.text = [NSString stringWithFormat:@"%@元/㎡",self.model.avgNetFtPrice];
        } else {
            NSNumber *rate = [[HKHouseUtil shareManager] rate];
            self.priceLabel.text = [NSString stringWithFormat:@"HK$%.2f/呎",[self.model.avgNetFtPrice doubleValue]*[rate doubleValue]];
        }
    }
}

- (void)createUI {
    
    [self.contentView addSubview:self.houseImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.areaLabel];
    [self.contentView addSubview:self.buildYearLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.separatorView];
    
    [self layout];
}

- (void)layout {
    [self.houseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.width.mas_equalTo(115);
        make.height.mas_equalTo(85);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.houseImageView.mas_right).offset(15);
        make.top.equalTo(self.houseImageView.mas_top);
        make.right.mas_equalTo(-20);
    }];
    
    [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.right.mas_equalTo(-20);
    }];
    
    [self.buildYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.areaLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(-20);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.buildYearLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(-20);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(8);
        make.right.mas_equalTo(-20);
    }];
    
    
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.houseImageView);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.contentView);
    }];
}

- (UIImageView *)houseImageView {
    if (!_houseImageView) {
        _houseImageView = [[UIImageView alloc]init];
        _houseImageView.contentMode = UIViewContentModeScaleAspectFill;
        _houseImageView.layer.masksToBounds = YES;
    }
    return _houseImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.text = @"这里是新房名称巴拉巴拉巴拉巴拉";
        _titleLabel.font = kFontSize6(16);
    }
    return _titleLabel;
}

- (UILabel *)buildYearLabel {
    if (!_buildYearLabel) {
        _buildYearLabel = [[UILabel alloc]init];
        _buildYearLabel.font = kFontSize6(11);
        _buildYearLabel.textColor = rzHColor(51);;
    }
    return _buildYearLabel;
}

- (UILabel *)areaLabel {
    if (!_areaLabel) {
        _areaLabel = [[UILabel alloc]init];
        _areaLabel.font = kFontSize6(11);
        _areaLabel.textColor = rzHColor(51);
    }
    return _areaLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.font = kFontSize6(11);
        _addressLabel.textColor = rzHColor(51);;
    }
    return _addressLabel;
}



- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = kFontSize6(17);
        _priceLabel.textColor = HEX_RGB(0xEA3323);
        _priceLabel.numberOfLines = 1;
    }
    return _priceLabel;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = kColorLineGray;
    }
    return _separatorView;
}

@end
