//
//  HouseSaleinformationCell.m
//  ErpApp
//
//  Created by midland on 2022/8/10.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "HouseSaleinformationCell.h"
#import "HKHouseCommon.h"
#import "SaleCommonView.h"
#import "CommonInfomationBaseView.h"
#import "HKHouseUtil.h"

#define kSaleCommonViewBaseTag 2354657
#define kString(a,b) ([a isExist] ? [NSString stringWithFormat:@"%@%@",a,b] : @"--")

@interface HouseSaleinformationCell()

@property (nonatomic, strong)UIView *vContentView;

/// 面积
@property (nonatomic, strong)CommonInfomationBaseView *areaView;
/// 户型
@property (nonatomic, strong)CommonInfomationBaseView *floarView;
/// 房龄
@property (nonatomic, strong)CommonInfomationBaseView *ageView;
/// 朝向
@property (nonatomic, strong)CommonInfomationBaseView *towardView;

@property (nonatomic, strong)UILabel *tagLabel;

@property (nonatomic, strong)UIView *separatorView;

@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation HouseSaleinformationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.vContentView = [UIView new];
    [self.contentView addSubview:self.vContentView];
    [self.contentView addSubview:self.areaView];
    [self.contentView addSubview:self.floarView];
    [self.contentView addSubview:self.ageView];
    [self.contentView addSubview:self.towardView];
    [self.contentView addSubview:self.tagLabel];
    [self.contentView addSubview: self.separatorView];
    
    [self.vContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(80);
    }];
    
    [self.areaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.vContentView.mas_bottom).offset(5);
        make.width.equalTo(self.vContentView).multipliedBy(0.5);
    }];
    
    [self.floarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.areaView.mas_right);
        make.height.top.equalTo(self.areaView);
        make.width.equalTo(self.vContentView).multipliedBy(0.5);
    }];
    
    [self.ageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.areaView);
        make.top.equalTo(self.areaView.mas_bottom).offset(10);
        make.width.equalTo(self.vContentView).multipliedBy(0.5);
    }];
    
    [self.towardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.floarView);
        make.top.equalTo(self.ageView);
        make.width.equalTo(self.vContentView).multipliedBy(0.5);
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(self.towardView.mas_bottom).offset(10);
        make.right.mas_equalTo(-20);
    }];
    
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(10);
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)setModel:(HKSecondeHouseDetailModel *)model {
    _model = model;
    BOOL isCNY = [[HKHouseUtil shareManager] isCNY];
    [self setContent:isCNY];
}

- (void)setContent:(BOOL)isCNY {
    [self.vContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.dataSource = [NSMutableArray array];
    
    if (isCNY) {
        [self.dataSource addObject:[self assemblyData:self.model.communityVO.marketStatNetFtPrice imageString:@"小区均价" des:@"小区均价" subDes: nil]];
        
    } else {
        [self.dataSource addObject:[self assemblyData:self.model.communityVO.marketStatNetFtPrice imageString:@"小区均价" des:@"小区均价" subDes: nil]];
    }

    [self.dataSource addObject:[self assemblyData:self.model.communityVO.marketStatNetFtPriceChg imageString:@"与小区均价比较" des:@"与小区均价比较" subDes: nil]];

    [self setSubViewsWithDatas:self.dataSource];
    
    /// 组装数据并画UI
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SaleCommonView *view = [self.vContentView viewWithTag:kSaleCommonViewBaseTag+idx];
        switch (idx) {
            case 0:
                if (isCNY) {
                    [view makeAreaStyle:self.model.communityVO.marketStatNetFtPrice];
                } else {
                    CGFloat price = [self.model.communityVO.marketStatNetFtPrice doubleValue] * [[HKHouseUtil shareManager].rate doubleValue];
                    [view makeAreaStyle:[NSString stringWithFormat:@"%.0f",price]];
                }
                break;
            case 1:{
                if ([self.model.communityVO.marketStatNetFtPriceChg isExist]) {
                    int priceChg = [self.model.communityVO.marketStatNetFtPriceChg intValue];
                    NSString *chgString;
                    NSString *priceString;
                    if (priceChg >= 0) {
                        chgString = @"高";
                        priceString = self.model.communityVO.marketStatNetFtPriceChg;
                    }else if (priceChg < 0) {
                        chgString = @"低";
                        priceString = [self.model.communityVO.marketStatNetFtPriceChg substringFromIndex:1];
                    }
                    
                    NSString *value = [NSString stringWithFormat:@"%@%@%%",chgString,priceString];
                    view.value = rzFitString(value);
                }else {
                    view.value = @"--";
                }
            }
                break;
            default:
                break;
        }
    }];
    if (isCNY) {
        NSString *area =  [NSString stringWithFormat:@"%.0f",[HKHouseUtil toFeet:[_model.area doubleValue]]];
        self.areaView.model = [[CommonInfomationBaseViewModel alloc] initWithTitle:@"建筑面积" content:kString(area, @"㎡")];
    } else {
        self.areaView.model = [[CommonInfomationBaseViewModel alloc] initWithTitle:@"建筑面积" content:kString(_model.area, @"呎")];
    }

    NSString *floar = @"";
    if ([_model.bedroom isExist]) {
        floar = [floar stringByAppendingFormat:@"%@房",_model.bedroom];
    }
    if ([_model.sittingRoom isExist]) {
        floar = [floar stringByAppendingFormat:@"%@厅",_model.sittingRoom];
    }
    if ([_model.sittingRoom isExist]) {
        floar = [floar stringByAppendingFormat:@"%@卫",_model.sittingRoom];
    }
    self.floarView.model = [[CommonInfomationBaseViewModel alloc] initWithTitle:@"户型" content:floar];
    self.ageView.model = [[CommonInfomationBaseViewModel alloc] initWithTitle:@"房龄" content:kString(_model.houseAge, @"年")];
    self.towardView.model = [[CommonInfomationBaseViewModel alloc] initWithTitle:@"朝向" content:rzFitStringEx(_model.orientationName,@"--")];
    
    [self.tagLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
//        __block UIColor *bgColor;
//        __block UIColor *textColor;
        __block NSString *text;
        
        [self.model.tagList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            text = [NSString stringWithFormat:@" %@ ",obj];
//            bgColor = idx%2==0 ? HEX_RGB(0x423D33) : HEX_RGB(0xFCEDD9);
//            textColor = idx%2==0 ? HEX_RGB(0xD5BC8B) : HEX_RGB(0xF3B06F);
            confer.text(text).font(kFontSize6(10)).backgroundColor(HEX_RGB(0xFFECD7)).textColor(HEX_RGB(0xFFAC62));
            confer.text(@"   ");
        }];
    }];
}

- (void)setSubViewsWithDatas:(NSArray *)datas {
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SaleCommonView *view = [[SaleCommonView alloc] initWithModel:obj frame:CGRectZero];
        view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:idx/datas.count];
        [self.vContentView addSubview:view];
        view.tag = kSaleCommonViewBaseTag+idx;
        NSInteger viewNum = 2.0;
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.vContentView);
            make.width.equalTo(self.vContentView).multipliedBy(1/(CGFloat)viewNum);
            make.centerX.equalTo(self.vContentView).multipliedBy(((idx%viewNum)*2+1)/(CGFloat)viewNum);
            make.top.equalTo(self.vContentView);
        }];
    }];
    UIView *lineView1 = [self lineView];
    [self.vContentView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.vContentView);
        make.width.mas_equalTo(1);
        make.top.equalTo(self.vContentView).offset(25);
        make.bottom.equalTo(self.vContentView).offset(-25);
    }];
    
}

- (SaleCommonModel *)assemblyData:(NSString *)title imageString:(NSString *)imageString des:(NSString *)des subDes:(NSString *)subDes {
    SaleCommonModel *scModel = [SaleCommonModel new];
    scModel.title = title;
    scModel.imgString = imageString;
    scModel.des = des;
    scModel.subDes = subDes;
    return scModel;
}

- (UIView *)lineView {
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = kColorLineGray;
    return lineView1;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = kColorLineGray;
    }
    return _separatorView;
}

- (CommonInfomationBaseView *)areaView {
    if (!_areaView) {
        _areaView = [[CommonInfomationBaseView alloc] init];
        _areaView.mLeft = 80;
    }
    return _areaView;
}

- (CommonInfomationBaseView *)floarView {
    if (!_floarView) {
        _floarView = [[CommonInfomationBaseView alloc] init];
        _floarView.mLeft = 80;
    }
    return _floarView;
}

- (CommonInfomationBaseView *)ageView {
    if (!_ageView) {
        _ageView = [[CommonInfomationBaseView alloc] init];
        _ageView.mLeft = 80;
    }
    return _ageView;
}

- (CommonInfomationBaseView *)towardView {
    if (!_towardView) {
        _towardView = [[CommonInfomationBaseView alloc] init];
        _towardView.mLeft = 80;
    }
    return _towardView;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc]init];
        _tagLabel.numberOfLines = 0;
        _tagLabel.font = kFontSize6(13);
        _tagLabel.textColor = HEX_RGB(0xEA3323);
    }
    return _tagLabel;
}

@end
