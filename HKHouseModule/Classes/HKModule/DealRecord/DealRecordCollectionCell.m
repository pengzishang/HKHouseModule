//
//  DealRecordCollectionCell.m
//  ErpApp
//
//  Created by midland on 2022/8/15.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "DealRecordCollectionCell.h"
#import "HKHouseCommon.h"
#import "HKHouseUtil.h"

@interface DealRecordCollectionCell ()

/// 座数
@property (nonatomic, strong)UILabel *zuoLabel;
@property (nonatomic, strong)UILabel *areaLabel;
@property (nonatomic, strong)UILabel *priceLabel;

@end

@implementation DealRecordCollectionCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)setBuildingData:(BuildingData *)buildingData {
    _buildingData = buildingData;
    BOOL isCNY = [[HKHouseUtil shareManager] isCNY];
    [self setContent:isCNY];
}

- (void)setContent:(BOOL)isCNY {
    self.zuoLabel.text = _buildingData.flatName;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@",###"];
    NSString *netArea =  [numberFormatter stringFromNumber:@([_buildingData.netArea intValue])];
    if (isCNY) {
        CGFloat area = [HKHouseUtil toSquare:[netArea doubleValue]];
        self.areaLabel.text = [NSString stringWithFormat:@"%.2f%@",area, @"㎡"];
    } else {
        self.areaLabel.text = [NSString stringWithFormat:@"%@%@",netArea, @"呎"];
    }
     
    [numberFormatter setPositiveFormat:@"###,##0.00"];
    double buildingDataPrice = [_buildingData.price doubleValue]/10000;
    NSNumber *rate = [[HKHouseUtil shareManager] rate];
    if (isCNY) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f%@",buildingDataPrice, @"万"];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"$%.2f%@",buildingDataPrice * [rate doubleValue], @"萬"];
    }
    
    if ([_buildingData.price isExist]) {
        self.contentView.backgroundColor = HEX_RGB(0xC7EFFF);
    }else {
        self.contentView.backgroundColor = HEX_RGB(0xF6F6F6);
    }
}

- (void)createUI {
    [self.contentView addSubview:self.zuoLabel];
    [self.contentView addSubview:self.areaLabel];
    [self.contentView addSubview:self.priceLabel];
    
    [self.zuoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(6);
    }];
    
    [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.zuoLabel.mas_bottom).offset(3);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.areaLabel.mas_bottom).offset(3);
    }];
}

- (UILabel *)zuoLabel {
    if (!_zuoLabel) {
        _zuoLabel = [[UILabel alloc]init];
        _zuoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _zuoLabel.textAlignment = NSTextAlignmentCenter;
        _zuoLabel.font = kFontBoldSize6(13);
        _zuoLabel.textColor = HEX_RGB(0x333333);
    }
    return _zuoLabel;
}


- (UILabel *)areaLabel {
    if (!_areaLabel) {
        _areaLabel = [[UILabel alloc]init];
        _areaLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _areaLabel.textAlignment = NSTextAlignmentCenter;
        _areaLabel.font = kFontSize6(11);
        _areaLabel.textColor = HEX_RGB(0x333333);
    }
    return _areaLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = kFontBoldSize6(11);
        _priceLabel.textColor = HEX_RGB(0x333333);
    }
    return _priceLabel;
}
@end
