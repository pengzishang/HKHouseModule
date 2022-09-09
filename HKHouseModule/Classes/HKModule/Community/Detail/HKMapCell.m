//
//  HKMapCell.m
//  ErpApp
//
//  Created by midland on 2022/7/22.
//

#import "HKMapCell.h"
#import "HKHouseCommon.h"
#import "DetailMapView.h"
#import <ErpRubbish/HFTVerticalContentView.h>
#import "DetailSurroundingFacilityViewController.h"

@interface HKMapCell ()
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 地址
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *tipButton;
@property (nonatomic, assign) CGFloat mapHeight;
@property (nonatomic, strong) DetailMapView *mapView;
@property (nonatomic, strong) UIView  *mavBgView;

@property(nonatomic, strong)UIView *separatorView;
@end

@implementation HKMapCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
}

#pragma mark - 初始化界面
- (void)createUI {
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.tipButton];
    
    _mavBgView = [[UIView alloc]init];
    [self.contentView addSubview:_mavBgView];
    
    [self.contentView addSubview:self.separatorView];
    
    // 初始化地图，将地图添加到地图背景图上，并且隐藏顶部的title
    _mapView = [[DetailMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10) hideTitle:YES];
    _mapHeight = _mapView.height;
    [_mavBgView addSubview:_mapView];
    
    _mavBgView.userInteractionEnabled = YES;
}

#pragma mark - 布局界面
- (void)createConstraints {

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@15);
        make.width.equalTo(self.contentView).multipliedBy(0.333333);
        make.height.equalTo(@30);
    }];

    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(8);
    }];
    
    [self.tipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(self.titleLabel);
    }];
//
//    [_lastYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.bottom.top.equalTo(_priceLabel);
//        make.left.equalTo(_lastMonthLabel.mas_right);
//    }];
    [_mavBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).offset(10);
        make.height.equalTo(@(_mapHeight));
        make.left.right.equalTo(self.contentView);
        
    }];
    _mavBgView.layer.masksToBounds = YES;
    
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mavBgView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(10);
        make.bottom.equalTo(self.contentView);
    }];
    
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setDetailModel:(HKCommunityDetailModel *)detailModel {
    _detailModel = detailModel;
    
    self.addressLabel.text = detailModel.address;
    
    _mapView.hidden = NO;
    [_mapView setDetailModel:detailModel];
    [_mavBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(_mapHeight));
    }];
    LazyWeakSelf
    [_tipButton bk_whenTapped:^{
        [weakSelf jumpMapDetail];
    }];
    _addressLabel.text = [NSString stringWithFormat:@"地址:%@",detailModel.address];
}

//- (void)setHouseHelper:(HFTHouseHelper *)houseHelper {
//    _houseHelper = houseHelper;
//    // 没有数据时，隐藏
//    houseHelper.buildingInfo.avgPrice = @"";
//    houseHelper.buildingInfo.ratioByLastMonthForSalePrice = @"";
//    houseHelper.buildingInfo.ratioByLastYearForPrice = @"";
//    if ( houseHelper.buildingInfo.avgPrice.length == 0 && houseHelper.buildingInfo.ratioByLastMonthForSalePrice.length == 0 && houseHelper.buildingInfo.ratioByLastYearForPrice.length == 0) {
//        [_priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(0.5));
//        }];
//        _priceLabel.text = @"";
//        _sqlLine.hidden = YES;
//    } else{
//        _sqlLine.hidden = NO;
//        [_priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@84);
//        }];
//        [_priceLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
//            confer.paragraphStyle.lineSpacing(8).alignment(NSTextAlignmentCenter);
//            if (houseHelper.buildingInfo.avgPrice.length == 0) {
//                confer.text(@"--").textColor(RGB(51, 51, 51)).font(rzHFont(18));
//            } else {
//                NSString *text = [NSString stringWithFormat:@"%@", @(houseHelper.buildingInfo.avgPrice.floatValue)];
//                confer.text(text).textColor(RGB(51, 51, 51)).font(rzHFont(18));
//            }
//            confer.text(@"\n本月均价(元/m²)").textColor(RGB(153, 153, 153)).font(rzHFont(12));
//        }];
//        LazyWeakSelf;
//        // 环比上月
//        [_lastMonthLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
//            NSString *text = [NSString stringWithFormat:@"%@", @(houseHelper.buildingInfo.ratioByLastMonthForSalePrice.floatValue)];
//            [weakSelf confer:confer data:text desc:@"\n环比上月"];
//        }];
//        // 同比去年
//        [_lastYearLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
//            NSString *text = [NSString stringWithFormat:@"%@", @(houseHelper.buildingInfo.ratioByLastYearForPrice.floatValue)];
//            [weakSelf confer:confer data:text desc:@"\n同比去年"];
//        }];
//    }
//
//    // 没有坐标时，隐藏
//    if (houseHelper.buildingInfo.positionX.length == 0 || houseHelper.buildingInfo.positionY.length == 0) {
//        _mapView.hidden = YES;
//        [_mavBgView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(0.5));
//        }];
//    } else {
//        _mapView.hidden = NO;
//        _mapView.houseLocation = CLLocationCoordinate2DMake([houseHelper.buildingInfo.positionX doubleValue], [houseHelper.buildingInfo.positionY doubleValue]);
//        [_mavBgView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(_mapHeight));
//        }];
//    }
//
//}

- (void)confer:(RZColorfulConferrer *)confer data:(NSString *)data desc:(NSString *)desc{
    NSInteger flag = 0;
    confer.paragraphStyle.lineSpacing(8).alignment(NSTextAlignmentCenter);
    if (data.length == 0) {
        confer.text(@"--").textColor(RGBGRAY(51)).font(kFontSize6(18));
    } else if (data.floatValue == 0.0f) {
        confer.text(@"持平").textColor(RGBGRAY(51)).font(kFontSize6(18));
    } else {
        NSDecimalNumber *temp = [NSDecimalNumber decimalNumberWithString:data];
        NSDecimalNumber *tempNumber = [temp decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
        flag = [tempNumber compare:@(0)]; // 1上升 -1下降 0持平
        confer.text(rzFitStringEx(RZNSStringFromNumber(tempNumber), @"--")).textColor([self getTextColor:flag]).font(kFontSize6(18));
        confer.text(@"%").textColor([self getTextColor:flag]).font(kFontSize6(18));
        confer.appendImage([self getFlagImage:flag]);
    }
    confer.text(desc).textColor(RGB(153, 153, 153)).font(kFontSize6(12));
}

- (void)jumpMapDetail {
    DetailSurroundingFacilityViewController *vc = [[DetailSurroundingFacilityViewController alloc] init];
    vc.isSelectedNemu = NO;
    vc.currentIndex = -1;
    vc.houseLocation = _mapView.houseLocation;
    [[HFTControllerManager getCurrentAvailableNavController] pushViewController:vc animated:YES];
}

- (UIColor *)getTextColor:(NSInteger)flag {
    if (flag == 1) {
        return RGB(255,93,47);
    }
    if (flag == -1) {
        return RGB(0,174,57);
    }
    return RGBGRAY(51);
}

- (UIImage *)getFlagImage:(NSUInteger)flag {
    if (flag == 1) {
        return rzImage(@"HouseBuildUp");
    }
    if (flag == -1) {
        return rzImage(@"HouseBuildDown");
    }
    return nil;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"周边分析";
        _titleLabel.font = kFontBoldSize6(17);
        _titleLabel.textColor = HEX_RGB(0x4E4F54);
    }
    return _titleLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.text = @"地址:这里是好大的地址";
        _addressLabel.font = kFontSize6(14);
    }
    return _addressLabel;
}

- (UIButton *)tipButton {
    if (!_tipButton) {
        _tipButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_tipButton setTitle:@"查看详情 >" forState:(UIControlStateNormal)];
        _tipButton.titleLabel.font = kFontSize6(13);
        [_tipButton setTitleColor:HEX_RGB(0xBFA475) forState:(UIControlStateNormal)];
    }
    return _tipButton;
}
    
- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = kColorLineGray;
    }
    return _separatorView;
}

@end
