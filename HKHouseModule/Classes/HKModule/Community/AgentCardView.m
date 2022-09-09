//
//  AgentCardView.m
//  ErpApp
//
//  Created by midland on 2022/8/9.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "AgentCardView.h"
#import "HKHouseCommon.h"

@interface AgentCardView ()

@property (nonatomic, strong) UIImageView *houseImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *wechatLabel;
@property (nonatomic, strong) UIButton *cpButton;

@end

@implementation AgentCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.shadowColor = RGB(51, 51, 51).CGColor;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 5;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        [self createUI];
    }
    return self;
}

- (void)setAgentModel:(AgentModel *)agentModel {
    _agentModel = agentModel;
    
    [self.houseImageView sd_setImageWithURL:[NSURL URLWithString:agentModel.empPhoto] placeholderImage:rzImage(@"rzUserDefaultHeader")];
    
    [self.titleLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(agentModel.nameChi).textColor(HEX_RGB(0x4E4F54)).font(kFontSize6(15));
        confer.text(agentModel.licenceNo).textColor(HEX_RGB(0x4E4F54)).font(kFontSize6(12));
    }];
    
    [self.wechatLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(@"微信号：").textColor(HEX_RGB(0x9399A5)).font(kFontSize6(12));
        confer.text([agentModel.wechatId isExist] ? agentModel.wechatId : @"--").textColor(HEX_RGB(0x9399A5)).font(kFontSize6(12));
    }];
}

- (void)setAgencyModel:(Agency *)agencyModel {
    _agencyModel = agencyModel;
    
    [self.houseImageView sd_setImageWithURL:[NSURL URLWithString:agencyModel.deptHeadPhotoPath] placeholderImage:rzImage(@"rzUserDefaultHeader")];
    
    [self.titleLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(agencyModel.deptHeadNameChi).textColor(HEX_RGB(0x4E4F54)).font(kFontSize6(15));
        confer.text(agencyModel.deptHeadPhoneNo).textColor(HEX_RGB(0x4E4F54)).font(kFontSize6(12));
    }];
    
    [self.wechatLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(@"微信号：").textColor(HEX_RGB(0x9399A5)).font(kFontSize6(12));
        confer.text([agencyModel.deptHeadWechatId isExist] ? agencyModel.deptHeadWechatId : @"--").textColor(HEX_RGB(0x9399A5)).font(kFontSize6(12));
    }];
}

- (void)createUI {
    [self addSubview:self.houseImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.wechatLabel];
    [self addSubview:self.cpButton];
    
    [self.houseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(13);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.houseImageView);
        make.left.equalTo(self.houseImageView.mas_right).offset(10);
    }];
    
    [self.wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.titleLabel);
    }];
    
    [self.cpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wechatLabel.mas_right).offset(10);
        make.centerY.equalTo(self.wechatLabel);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(23);
    }];
    
}


- (UIImageView *)houseImageView {
    if (!_houseImageView) {
        _houseImageView = [[UIImageView alloc]init];
        _houseImageView.contentMode = UIViewContentModeScaleAspectFill;
        _houseImageView.layer.cornerRadius = 20;
        _houseImageView.layer.masksToBounds = YES;
    }
    return _houseImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFontBoldSize6(17);
        _titleLabel.text = @"名字";
        _titleLabel.textColor = HEX_RGB(0x4E4F54);
    }
    return _titleLabel;
}

- (UILabel *)wechatLabel {
    if (!_wechatLabel) {
        _wechatLabel = [[UILabel alloc] init];
        _wechatLabel.font = kFontBoldSize6(17);
        _wechatLabel.text = @"微信";
        _wechatLabel.textColor = HEX_RGB(0x4E4F54);
    }
    return _wechatLabel;
}

- (UIButton *)cpButton {
    if (!_cpButton) {
        _cpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cpButton setTitleColor:HEX_RGB(0xD6B386) forState:UIControlStateNormal];
        [_cpButton setTitle:@"复制" forState:UIControlStateNormal];
        _cpButton.titleLabel.font = kFontSize6(14);
        _cpButton.backgroundColor = HEX_RGB(0xFBF6EC);
        _cpButton.layer.cornerRadius = 4;
        _cpButton.layer.masksToBounds = YES;
        @weakify(self);
        [_cpButton bk_whenTapped:^{
            @strongify(self);
            
            NSString *wechatID;
            if (self.agencyModel) {
                wechatID = self.agencyModel.deptHeadWechatId;
            }
            if (self.agentModel) {
                wechatID = self.agentModel.wechatId;
            }
            
            if (![wechatID isExist]) {
                [HFTHud showWarnMessage:@"微信号不存在"];
                return;
            }
            UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
            pastboard.string = wechatID?:@"";
            [HFTHud showTipMessage:@"微信号复制成功"];
        }];
    }
    return _cpButton;
}

@end
