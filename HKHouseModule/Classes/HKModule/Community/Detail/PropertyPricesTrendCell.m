//
//  PropertyPricesTrendCell.m
//  ErpApp
//
//  Created by midland on 2022/8/8.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "PropertyPricesTrendCell.h"
#import "HKHouseCommon.h"
#import "DealRecordVC.h"
#import "XJYChart.h"

@interface PropertyPricesTrendCell () <XJYChartDelegate>

typedef enum : NSUInteger {
    PeriodHalf,
    PeriodSole,
    PeriodDouble,
} Period;

@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UIButton *seeAllButton;
@property(nonatomic, strong)UIView *separatorView;

@property(nonatomic, strong)UIButton *halfYearBtn;
@property(nonatomic, strong)UIButton *oneYearBtn;
@property(nonatomic, strong)UIButton *twoYearBtn;

@property(nonatomic, strong)UIView *chartContentView;

@property(nonatomic, strong)UILabel *tipLabel;

@property (nonatomic,assign) Period period;
/// 楼价走势
@property (nonatomic, strong) NSArray<Monthlies *> *monthliesSlice;


@end

@implementation PropertyPricesTrendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self createUI];
    }
    return self;
}

- (void)setDetailModel:(HKCommunityDetailModel *)detailModel {
    _detailModel = detailModel;
    [self selectPeriod:PeriodHalf];
}

- (void)selectPeriod:(Period)period {
    NSInteger length = _detailModel.monthlies.count;
    if (length == 0) {
        return;
    }
    NSInteger lastIndex = length - 1;
    
    switch (period) {
        case PeriodHalf:
            [self buttonAction:self.halfYearBtn];
            NSInteger locHalf = lastIndex - 6 > 0 ? lastIndex - 6 : 0;
            self.monthliesSlice = [self.detailModel.monthlies subarrayWithRange:NSMakeRange(locHalf, length > 6 ? 6:length)];
            break;
        case PeriodSole:
            [self buttonAction:self.oneYearBtn];
            NSInteger locSole = lastIndex - 12 > 0 ? lastIndex - 12 : 0;
            self.monthliesSlice = [self.detailModel.monthlies subarrayWithRange:NSMakeRange(locSole, length > 12 ? 12:length)];
            break;
        case PeriodDouble:
            [self buttonAction:self.twoYearBtn];
            NSInteger locDouble = lastIndex - 24 > 0 ? lastIndex - 24 : 0;
            self.monthliesSlice = [self.detailModel.monthlies subarrayWithRange:NSMakeRange(locDouble, length > 24 ? 24:length)];
            break;
    }
    [self createChartView];
}

- (void)createUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.seeAllButton];
    [self.contentView addSubview:self.separatorView];
    
    self.halfYearBtn = [self createButtonWithTitle:@"半年" period:PeriodHalf];
    self.oneYearBtn = [self createButtonWithTitle:@"1年" period:PeriodSole];
    self.twoYearBtn = [self createButtonWithTitle:@"2年" period:PeriodDouble];
    
    [self.contentView addSubview:self.halfYearBtn];
    [self.contentView addSubview:self.oneYearBtn];
    [self.contentView addSubview:self.twoYearBtn];
    
    [self.contentView addSubview:self.chartContentView];
    [self.contentView addSubview:self.tipLabel];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(30);
    }];
    
    [self.halfYearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(25);
    }];
    
    [self.oneYearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.halfYearBtn);
        make.left.equalTo(self.halfYearBtn.mas_right).offset(10);
    }];
    
    [self.twoYearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.halfYearBtn);
        make.left.equalTo(self.oneYearBtn.mas_right).offset(10);
    }];
    
    [self.chartContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.halfYearBtn.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(440);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chartContentView.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(45);
        make.right.equalTo(self.contentView).offset(-45);
    }];
    
    [self.seeAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(kViewSize6(40));
    }];
    
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.seeAllButton.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(10);
        make.bottom.equalTo(self.contentView);
    }];
}

- (UIButton *)seeAllButton {
    if (!_seeAllButton) {
        _seeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_seeAllButton setTitle:@"全栋历史成交记录" forState:UIControlStateNormal];
        [_seeAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _seeAllButton.titleLabel.font = kFontSize6(14);
        _seeAllButton.backgroundColor = HEX_RGB(0xD8BA84);
        _seeAllButton.layer.cornerRadius = 4;
        _seeAllButton.layer.masksToBounds = YES;
        
        [_seeAllButton bk_whenTapped:^{
            DealRecordVC *listvc = [[DealRecordVC alloc] initWithEstateId:self.detailModel.estateId];
            [[HFTControllerManager getCurrentAvailableNavController] pushViewController:listvc animated:YES];
        }];
    }
    return _seeAllButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFontBoldSize6(17);
        _titleLabel.text = @"楼价走势";
        _titleLabel.textColor = HEX_RGB(0x4E4F54);
    }
    return _titleLabel;
}

- (UIView *)chartContentView {
    if (!_chartContentView) {
        _chartContentView = [UIView new];
    }
    return _chartContentView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = kFontSize6(8);
        _tipLabel.text = @"以上数据是综合土地注册处的物业买卖注册个案资料及香港置业的物业资料库资 料统计，计算而成。所有资料仅供参考。在筹备该等素材时，虽已作出合理谨慎 措施，但若因错漏而引致任何不便或损失，香港置业概不负责。";
        _tipLabel.textColor = HEX_RGB(0xDDDDDD);
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

- (UIButton *)createButtonWithTitle:(NSString *)title period:(Period)period {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithColor:HEX_RGB(0xF4F5F9)] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithColor:HEX_RGB(0xD8BA84)] forState:UIControlStateSelected];
    [button setTitleColor:HEX_RGB(0x666666) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.titleLabel.font = kFontBoldSize6(13);
    button.layer.cornerRadius = 12.5;
    button.layer.masksToBounds = YES;
    LazyWeakSelf
    [button bk_addEventHandler:^(id sender) {
        [weakSelf selectPeriod:period];
    } forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonAction:(UIButton *)button {
    [@[self.halfYearBtn,self.oneYearBtn,self.twoYearBtn] enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = button == obj;
    }];
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

#pragma chartView
- (void)createChartView {
    [self.chartContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self createLineChart];
    [self createBarChart];
}

- (void)createLineChart {
    
    UILabel *label = [UILabel new];
    label.text = @"呎价(元)";
    label.font = [UIFont boldSystemFontOfSize:11];
    label.textColor = HEX_RGB(0x999999);
    [self.chartContentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chartContentView);
        make.left.equalTo(self.chartContentView);
        make.height.equalTo(@15);
    }];
    
    /// 最大值，最小值
    __block NSString *maxNum = self.monthliesSlice.firstObject.avgNetFtPrice;
    __block NSString *minNum = self.monthliesSlice.firstObject.avgNetFtPrice;
    __block NSArray *numberArray = [self.monthliesSlice bk_map:^id(Monthlies * obj) {
        return obj.avgNetFtPrice;
    }];
    [self.monthliesSlice enumerateObjectsUsingBlock:^(Monthlies * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.avgNetFtPrice compare:maxNum] == NSOrderedDescending) {
            maxNum = obj.avgNetFtPrice;
        }
        if ([obj.avgNetFtPrice compare:minNum] == NSOrderedAscending) {
            minNum = obj.avgNetFtPrice;
        }
    }];
    
    NSDateFormatter *stringformatter = [[NSDateFormatter alloc] init];
    [stringformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy/MM/dd"];

    NSArray <NSString *> *dates = [self.monthliesSlice bk_map:^id(Monthlies *obj) {
        NSDate *date = [stringformatter dateFromString:obj.monthlyDate];
        NSString *desc = [dateformatter stringFromDate:date];
        return desc;
    }];

    XLineChartItem* item =
        [[XLineChartItem alloc] initWithDataNumberArray:numberArray
                                              dataArray:self.monthliesSlice
                                                  color:HEX_RGB(0xD8BA84)];
    XNormalLineChartConfiguration* configuration =
        [[XNormalLineChartConfiguration alloc] init];
    configuration.isShowShadow = NO;
    configuration.isEnableNumberAnimation = NO;
//    configuration.isEnableNumberLabel = YES;
    XLineChart* lineChart =
        [[XLineChart alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth - 2*15, 200)
                            dataItemArray:@[item].mutableCopy
                        dataDiscribeArray:dates.mutableCopy
         // 最大值。最小值分别放大，缩小
                                topNumber:@([maxNum integerValue]*1.1)
                             bottomNumber:@([minNum integerValue]*0.9)
                                graphMode:MutiLineGraph
                       chartConfiguration:configuration];
    [self.chartContentView addSubview:lineChart];
}

- (void)createBarChart {
    // TODO: 注册量的字段
    UILabel *label = [UILabel new];
    label.text = @"注册量(宗)";
    label.font = [UIFont boldSystemFontOfSize:11];
    label.textColor = HEX_RGB(0x999999);
    [self.chartContentView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chartContentView).inset(225);
        make.left.equalTo(self.chartContentView);
        make.height.equalTo(@15);
    }];
    // TODO: 最大最小
    __block NSString *maxNum = self.monthliesSlice.firstObject.avgNetFtPrice;
    __block NSString *minNum = self.monthliesSlice.firstObject.avgNetFtPrice;

    [self.monthliesSlice enumerateObjectsUsingBlock:^(Monthlies * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.avgNetFtPrice compare:maxNum] == NSOrderedDescending) {
            maxNum = obj.avgNetFtPrice;
        }
        if ([obj.avgNetFtPrice compare:minNum] == NSOrderedAscending) {
            minNum = obj.avgNetFtPrice;
        }
    }];
    
    UIColor* waveColor = HEX_RGB(0x7D5D23);
    
    NSDateFormatter *stringformatter = [[NSDateFormatter alloc] init];
    [stringformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy/MM/dd"];

    NSArray <XBarItem *> *itemArray = [self.monthliesSlice bk_map:^id(Monthlies *obj) {
        NSDate *date = [stringformatter dateFromString:obj.monthlyDate];
        NSString *desc = [dateformatter stringFromDate:date];
        XBarItem* item1 = [[XBarItem alloc] initWithDataNumber:@([obj.totalTxCount integerValue])
                                                         color:waveColor
                                                  dataDescribe:desc];
        return item1;
    }];

    XBarChartConfiguration *configuration = [XBarChartConfiguration new];
    configuration.isScrollable = YES;
    configuration.isShowXAbscissa = YES;
    configuration.isShowOrdinate = YES;
    configuration.x_width = 2;
    XBarChart* barChart =
        [[XBarChart alloc] initWithFrame:CGRectMake(0, 240, kScreenWidth - 2*15, 200)
                           dataItemArray:itemArray
                               topNumber:@150
                            bottomNumber:@(0)
                      chartConfiguration:configuration];
    barChart.barChartDelegate = self;
    [self.chartContentView addSubview:barChart];
}


@end
