//
//  SaleinformationCell.m
//  ErpApp
//
//  Created by midland on 2022/8/8.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "SaleinformationCell.h"
#import "HKHouseCommon.h"
#import "SaleCommonView.h"
#import "HKHouseUtil.h"

#define kSaleCommonViewBaseTag 2354657

@interface SaleinformationCell()

@property (nonatomic, strong)UIView *vContentView;
@property (nonatomic, strong)UIView *separatorView;

@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation SaleinformationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self createUI];
        
        [self initDataSource];
    }
    return self;
}

- (void)createUI {
    self.vContentView = [UIView new];
    [self.contentView addSubview:self.vContentView];
    [self.contentView addSubview: self.separatorView];
    
    [self.vContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(160);
    }];
    
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vContentView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(10);
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)initDataSource {
    self.dataSource = [NSMutableArray array];
    
    [self.dataSource addObject:[self assemblyData:@"--" imageString:@"近30日成交" des:@"近30日成交" subDes: nil]];
    [self.dataSource addObject:[self assemblyData:@"--" imageString:@"平均成交价" des:@"平均成交价" subDes: @"(过去30日成交)"]];
    [self.dataSource addObject:[self assemblyData:@"--" imageString:@"较上月" des:@"较上月" subDes: nil]];
    [self.dataSource addObject:[self assemblyData:@"--" imageString:@"平均成交价" des:@"平均放盘价" subDes: nil]];
    
    [self.dataSource addObject:[self assemblyData:@"--" imageString:@"最低" des:@"最低" subDes: nil]];
    [self.dataSource addObject:[self assemblyData:@"--" imageString:@"最高" des:@"最高" subDes: nil]];
    
    [self setSubViewsWithDatas:self.dataSource];
    LazyWeakSelf
    [[NSNotificationCenter defaultCenter]addObserverForName:@"SwitchCurrencyCallBack" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        BOOL isCNY = [note.object boolValue];
        [HKHouseUtil shareManager].isCNY = isCNY;
        [weakSelf setContent:isCNY];
    }];
}

- (void)setModel:(HKCommunityDetailModel *)model {
    _model = model;
    
    if (_model == nil) {
        return;
    }
    /// 组装数据并画UI
    BOOL isCNY = [[HKHouseUtil shareManager] isCNY];
    [self setContent:isCNY];
}

- (void)setContent:(BOOL)isCNY {
    NSNumber *rate = [[HKHouseUtil shareManager] rate];
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SaleCommonView *view = [self.vContentView viewWithTag:kSaleCommonViewBaseTag+idx];
        switch (idx) {
            case 0:
                view.value = rzFitStringExDefault(self.model.marketStatTxCount, @"套");
                break;
            case 1: {
                CGFloat marketStatNetFtPrice = [self.model.marketStatNetFtPrice doubleValue];
                if (isCNY) {
                    CGFloat transforPrice = marketStatNetFtPrice/[rate doubleValue];
                    NSString *tranString = [NSString stringWithFormat:@"%.0f",transforPrice];
                    [view makeAreaStyle:tranString];
                } else {
                    CGFloat transforPrice = marketStatNetFtPrice;
                    NSString *tranString = [NSString stringWithFormat:@"%.0f",transforPrice];
                    [view makeAreaStyle:tranString];
                }
                break;
            }
            case 2:
                view.value = [self.model.marketStatNetFtPriceChg isExist] ? [NSString stringWithFormat:@"%@%%",self.model.marketStatNetFtPriceChg] : @"--";
                break;
            case 3: {
                if (isCNY) {
                    CGFloat avgNetFtPrice = [self.model.avgNetFtPrice doubleValue];
                    CGFloat transforAvgNetFtPrice = avgNetFtPrice/[rate doubleValue];
                    NSString *tranString = [NSString stringWithFormat:@"%.0f",transforAvgNetFtPrice];
                    [view makeAreaStyle:tranString];
                } else {
                    CGFloat avgNetFtPrice = [self.model.avgNetFtPrice doubleValue];
                    CGFloat transforAvgNetFtPrice = avgNetFtPrice;
                    NSString *tranString = [NSString stringWithFormat:@"%.0f",transforAvgNetFtPrice];
                    [view makeAreaStyle:tranString];
                }
                break;
            }
                
            case 4: {
                if (isCNY) {
                    CGFloat minPrice = [self.model.minPrice doubleValue];
                    CGFloat transforMinPrice = minPrice / [rate doubleValue];
                    [view makePriceStyle:[self.model.minPrice isExist] ? [NSString stringWithFormat:@"%.0f",(transforMinPrice/10000.0)] : @"--"];
                } else {
                    CGFloat minPrice = [self.model.minPrice doubleValue];
                    CGFloat transforMinPrice = minPrice;
                    [view makePriceStyle:[self.model.minPrice isExist] ? [NSString stringWithFormat:@"%.0f",(transforMinPrice/10000.0)] : @"--"];
                }
                break;
            }
            case 5: {
                if (isCNY) {
                    CGFloat maxPrice = [self.model.maxPrice doubleValue];
                    CGFloat transforMaxPrice = maxPrice/[rate doubleValue];
                    [view makePriceStyle:[self.model.maxPrice isExist] ? [NSString stringWithFormat:@"%.0f",(transforMaxPrice/10000.0)] : @"--"];
                } else {
                    CGFloat maxPrice = [self.model.maxPrice doubleValue];
                    CGFloat transforMaxPrice = maxPrice;
                    [view makePriceStyle:[self.model.maxPrice isExist] ? [NSString stringWithFormat:@"%.0f",(transforMaxPrice/10000.0)] : @"--"];
                }
                break;
            }
            default:
                break;
        }
    }];
}

- (void)setSubViewsWithDatas:(NSArray *)datas {
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SaleCommonView *view = [[SaleCommonView alloc] initWithModel:obj frame:CGRectZero];
        [self.vContentView addSubview:view];
        view.tag = kSaleCommonViewBaseTag+idx;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.vContentView).multipliedBy(0.5);
            make.width.equalTo(self.vContentView).multipliedBy(1/3.0);
            make.centerX.equalTo(self.vContentView).multipliedBy(((idx%3)*2+1)/3.0);
            make.centerY.equalTo(self.vContentView).multipliedBy(((idx/3)*2+1)/2.0);
        }];
    }];
    UIView *lineView1 = [self lineView];
    [self.vContentView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.vContentView).multipliedBy(2/3.0);
        make.width.mas_equalTo(1);
        make.top.mas_equalTo(25);
        make.bottom.mas_equalTo(-25);
    }];
    
    UIView *lineView2 = [self lineView];
    [self.vContentView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.vContentView).multipliedBy(4/3.0);
        make.top.bottom.width.equalTo(lineView1);
    }];
    
    UIView *lineView3 = [self lineView];
    [self.vContentView addSubview:lineView3];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vContentView);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
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

@end
