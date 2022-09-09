//
//  HouseCell.m
//  ErpApp
//
//  Created by midland on 2022/8/8.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "HouseCell.h"
#import "HKHouseCommon.h"
#import "HKSecondHouseListCell.h"
#import "HKSecondHouseListVC.h"
#import "HKSecondeHouseDetailVC.h"

#define kTableViewCellHeight 110

@interface HouseCell()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIButton *seeAllButton;
@property (nonatomic, strong)UIView *separatorView;

@end

@implementation HouseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
    }
    return self;
}

- (void)setDetailModel:(HKCommunityDetailModel *)detailModel {
    NSUInteger prefix5 = detailModel.top8HouseVos.count > 5 ? 5 : detailModel.top8HouseVos.count;

    NSArray *top5HouseVos = [detailModel.top8HouseVos subarrayWithRange:NSMakeRange(0, prefix5)];
    _detailModel = detailModel;
    _detailModel.top8HouseVos = top5HouseVos;
    
    /// 根据实际数据重新布局
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kTableViewCellHeight*top5HouseVos.count + 40);
    }];
    
    [self.tableView reloadData];
    
    [self.seeAllButton setTitle:[NSString stringWithFormat:@"查看小区全部%@套房源",detailModel.sellCount] forState:UIControlStateNormal];
}

- (void)createUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.seeAllButton];
    [self.contentView addSubview: self.separatorView];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(kViewSize6(kTableViewCellHeight*3));
    }];
    
    [self.seeAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.detailModel.top8HouseVos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKSecondHouseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKSecondHouseListCell class]) forIndexPath:indexPath];
    [cell updateModel:self.detailModel.top8HouseVos[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *serialNo = self.detailModel.top8HouseVos[indexPath.row].serialNo;
    if (serialNo) {
        HKSecondeHouseDetailVC *detailVC = [[HKSecondeHouseDetailVC alloc] initWithSerialNo:serialNo];
        [[HFTControllerManager getCurrentAvailableNavController] pushViewController:detailVC animated:YES];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFontBoldSize6(17);
        _titleLabel.text = @"小区房源";
        _titleLabel.textColor = HEX_RGB(0x4E4F54);
    }
    return _titleLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kViewSize6(430)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kViewSize6((110));
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView.backgroundColor = RGBGRAY(246);
        _tableView.backgroundColor = RGBGRAY(246);
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[HKSecondHouseListCell class] forCellReuseIdentifier:NSStringFromClass([HKSecondHouseListCell class])];
    }
    return _tableView;
}

- (UIButton *)seeAllButton {
    if (!_seeAllButton) {
        _seeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_seeAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _seeAllButton.titleLabel.font = kFontSize6(14);
        _seeAllButton.backgroundColor = HEX_RGB(0xD8BA84);
        
        [_seeAllButton bk_whenTapped:^{
            HKSecondHouseListVC *listvc = [[HKSecondHouseListVC alloc]initWithTitle:self.detailModel.nameChi estateId:self.detailModel.estateId];
            [[HFTControllerManager getCurrentAvailableNavController] pushViewController:listvc animated:YES];
        }];
    }
    return _seeAllButton;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = kColorLineGray;
    }
    return _separatorView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _seeAllButton.layer.cornerRadius = 4;
    _seeAllButton.layer.masksToBounds = YES;
}



@end
