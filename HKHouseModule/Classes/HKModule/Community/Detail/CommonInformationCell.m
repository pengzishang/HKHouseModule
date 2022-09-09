//
//  CommonInformationCell.m
//  ErpApp
//
//  Created by midland on 2022/8/8.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "CommonInformationCell.h"
#import "HKHouseCommon.h"
#import "CommonInfomationBaseView.h"
#import "HKHouseUtil.h"

#define kString(a,b) ([a isExist] ? [NSString stringWithFormat:@"%@%@",a,b] : @"--")

@interface CommonInformationCell ()

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIView *vContentView;
@property (nonatomic, strong)UIView *separatorView;

@end

@implementation CommonInformationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(30);
        }];
        self.vContentView = [[UIView alloc] init];
        [self.contentView addSubview:self.vContentView];
        [self.vContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(-10);
        }];
        
        [self.contentView addSubview: self.separatorView];
        [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vContentView.mas_bottom);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(10);
            make.bottom.equalTo(self.contentView);
        }];
        
    }
    return self;
}

- (void)setModel:(HKCommunityDetailModel *)model {
    _model = model;
    BOOL isCNY = [[HKHouseUtil shareManager] isCNY];
    [self setContent:isCNY];
}

- (void)setContent:(BOOL)isCNY {
    [self.vContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    NSMutableArray *dataSource = [NSMutableArray array];
    /// 组装数据
    [dataSource addObject:[[CommonInfomationBaseViewModel alloc] initWithTitle:@"房龄" content:kString(_model.houseAge, @"年")]];
    
    NSString *firstOpDate = [NSDate formatDate:[NSDate dateFromString:_model.firstOpDate formatStr:@"yyyy-MM-dd HH:mm:ss"] formatStr:@"yyyy年"];
    [dataSource addObject:[[CommonInfomationBaseViewModel alloc] initWithTitle:@"建筑年代" content:firstOpDate]];
    [dataSource addObject:[[CommonInfomationBaseViewModel alloc] initWithTitle:@"产权年限" content:_model.termOfYear]];
    if (isCNY) {
        [dataSource addObject:
         [[CommonInfomationBaseViewModel alloc] initWithTitle:@"面积区间"
                                                      content:[NSString stringWithFormat:@"%.2f-%.2f㎡",[HKHouseUtil toSquare:[_model.minArea doubleValue]] ,[HKHouseUtil toSquare:[_model.maxArea doubleValue]]]]];
    } else {
        [dataSource addObject:[[CommonInfomationBaseViewModel alloc] initWithTitle:@"面积区间" content:[NSString stringWithFormat:@"%@-%@呎",_model.minArea,_model.maxArea]]];
    }

    [dataSource addObject:[[CommonInfomationBaseViewModel alloc] initWithTitle:@"房屋总数" content:kString(_model.totalFlats, @"")]];
    [dataSource addObject:[[CommonInfomationBaseViewModel alloc] initWithTitle:@"物业栋数" content:_model.housePropertyNum]];
    [dataSource addObject:[[CommonInfomationBaseViewModel alloc] initWithTitle:@"物业校网(学位)" content:[NSString stringWithFormat:@"小学：%@；中学：%@",_model.schoolNetPrimaryId,_model.schoolNetSecondaryName]]];
    [dataSource addObject:[[CommonInfomationBaseViewModel alloc] initWithTitle:@"物业设施" content:_model.facilityGroup]];
    [dataSource addObject:[[CommonInfomationBaseViewModel alloc] initWithTitle:@"物业费" content:@"--"]];
    [dataSource addObject:[[CommonInfomationBaseViewModel alloc] initWithTitle:@"物业层数" content:_model.noOfStoreys]];
    [dataSource addObject:[[CommonInfomationBaseViewModel alloc] initWithTitle:@"停车位" content:_model.carpark]];
    [dataSource addObject:[[CommonInfomationBaseViewModel alloc] initWithTitle:@"小区概况" content:_model.merits]];
    
    [self createCommonInfomationBaseViewWithDatas:dataSource];
}

- (void)createCommonInfomationBaseViewWithDatas:(NSArray<CommonInfomationBaseViewModel *> *)datas {
    
    __block UIView *lastView = self.titleLabel;
    [datas enumerateObjectsUsingBlock:^(CommonInfomationBaseViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CommonInfomationBaseView *view = [[CommonInfomationBaseView alloc] init];
        view.model = obj;
        [self.vContentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(lastView.mas_bottom).offset(8);
            
            if (idx == datas.count-1) {
                make.bottom.equalTo(self.vContentView).offset(-15);
            }
        }];
        
        lastView = view;
    }];
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFontBoldSize6(17);
        _titleLabel.text = @"基本信息";
        _titleLabel.textColor = HEX_RGB(0x4E4F54);
    }
    return _titleLabel;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = kColorLineGray;
    }
    return _separatorView;
}

@end
