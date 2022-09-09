//
//  HKSecondHouseListCell.m
//  ErpApp
//
//  Created by midland on 2022/7/21.
//

#import "HKSecondHouseListCell.h"
#import "HKhouseCommon.h"
#import "HKHouseUtil.h"

#define rzHColor(value) RGB(value, value, value)

/// 小区列表的cell
@interface HKSecondHouseListCell ()
/// 房源首图
@property (nonatomic, strong) UIImageView *houseImageView;
/// 标题
@property (nonatomic, strong) UILabel  *titleLabel;
/// 各种属性
@property (nonatomic, strong) UILabel  *propertyLabel;
/// 售价
@property (nonatomic, strong) UILabel  *priceLabel;
/// 标签
@property (nonatomic, strong) UILabel  *tagLabel;

@property (nonatomic, strong) UIView  *separatorView;

@property (nonatomic, strong)HKSecondHouseModel *model;

@end

@implementation HKSecondHouseListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
        [self bind];
    }
    return self;
}

- (void)updateModel:(HKSecondHouseModel *)model {
    _model = model;
    BOOL isCNY = [[HKHouseUtil shareManager] isCNY];
    [self setContent:isCNY];
}

- (void)setContent:(BOOL)isCNY {
    [self.houseImageView sd_setImageWithURL:[NSURL URLWithString:self.model.outlookWanDocPath] placeholderImage:rzImage(@"global_image_placeholder_load")];
    
    self.titleLabel.text = self.model.houseName;
    NSNumber *rate = [[HKHouseUtil shareManager] rate];
    
    NSString *propertyText = [NSString string];
    if ([self.model.bedroom isExist]) {
        propertyText = [propertyText stringByAppendingString:self.model.bedroom];
        propertyText = [propertyText stringByAppendingString:@"房"];
    }
    
    if ([self.model.sittingRoom isExist]) {
        propertyText = [propertyText stringByAppendingString:self.model.sittingRoom];
        propertyText = [propertyText stringByAppendingString:@"厅"];
    }
    
    if ([self.model.bedroom isExist]) {
        propertyText = [propertyText stringByAppendingString:self.model.bedroom];
        propertyText = [propertyText stringByAppendingString:@"卫"];
    }
    
    propertyText = [propertyText stringByAppendingString:@" | "];
    if (isCNY) {
        NSString *price = [NSString stringWithFormat:@"%0.f",[HKHouseUtil toSquare:[self.model.area doubleValue]]];
        propertyText = [propertyText stringByAppendingString:[self.model.area isExist] ? price : @"--"];
        propertyText = [propertyText stringByAppendingString:@"㎡"];
    } else {
        NSString *price = [NSString stringWithFormat:@"%0.f",[HKHouseUtil toSquare:[self.model.area doubleValue]]];
        propertyText = [propertyText stringByAppendingString:[self.model.area isExist] ? self.model.area : @"--"];
        propertyText = [propertyText stringByAppendingString:@"呎"];
    }

    propertyText = [propertyText stringByAppendingString:@" | "];
    
    propertyText = [propertyText stringByAppendingString:[self.model.houseAge isExist] ? self.model.houseAge : @"--"];
    propertyText = [propertyText stringByAppendingString:@"年"];
    propertyText = [propertyText stringByAppendingString:@" | "];
    
    propertyText = [propertyText stringByAppendingString:[self.model.orientationName isExist] ? self.model.orientationName : @"--"];
    self.propertyLabel.text = propertyText;
    /// 价格
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0"];
    CGFloat price = [self.model.price doubleValue];
    CGFloat priceTemp = isCNY ? price : price*[rate doubleValue];
    NSString *priceFinally =  [numberFormatter stringFromNumber:@(priceTemp/10000)];
    
    if (isCNY) {
        self.priceLabel.text = [NSString stringWithFormat:@"%@%@",priceFinally, @"万"];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"%@%@",priceFinally, @"萬"];
    }
    
    /// 标签
    [self.tagLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        __block UIColor *bgColor;
        __block UIColor *textColor;
        __block NSString *text;
        [self.model.tagList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            text = [NSString stringWithFormat:@" %@ ",obj];
            bgColor = idx%2==0 ? HEX_RGB(0x423D33) : HEX_RGB(0xFCEDD9);
            textColor = idx%2==0 ? HEX_RGB(0xD5BC8B) : HEX_RGB(0xF3B06F);
            confer.text(text).font(kFontSize6(10)).backgroundColor(bgColor).textColor(textColor);
            confer.text(@"   ");
        }];
    }];
}

- (void)createUI {
    
    [self.contentView addSubview:self.houseImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.propertyLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.tagLabel];
    
    [self.contentView addSubview:self.separatorView];
    
    
    [self layout];
}

- (void)bind {
    LazyWeakSelf
    [[NSNotificationCenter defaultCenter]addObserverForName:@"SwitchCurrencyCallBack" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        BOOL isCNY = [note.object boolValue];
        [HKHouseUtil shareManager].isCNY = isCNY;
        [weakSelf setContent:isCNY];
    }];
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
    
    [self.propertyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.right.mas_equalTo(-20);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.propertyLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(-20);
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(-20);
    }];
    
    
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.tagLabel.mas_bottom).offset(10);
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
        _houseImageView.layer.cornerRadius = 3;
        _houseImageView.layer.masksToBounds = YES;
    }
    return _houseImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 2;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.font = kFontSize6(16);
    }
    return _titleLabel; 
}


- (UILabel *)propertyLabel {
    if (!_propertyLabel) {
        _propertyLabel = [[UILabel alloc]init];
        _propertyLabel.text = @"3房2厅2卫丨158.21 ㎡丨50年丨南";
        _propertyLabel.font = kFontSize6(11);
        _propertyLabel.textColor = rzHColor(51);;
    }
    return _propertyLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.text = @"8888万";
        _priceLabel.font = kFontSize6(17);
        _priceLabel.textColor = HEX_RGB(0xEA3323);
        _priceLabel.numberOfLines = 1;
    }
    return _priceLabel;
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

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = kColorLineGray;
    }
    return _separatorView;
}

/// 创建tags
- (void)createTagButton:(NSArray *)tags superView:(UIView *)superView {
    
    __block UIColor *bgColor;
    __block UIColor *textColor;
    __block NSString *text;
    __block UILabel *lastLabel;
    [tags enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        text = [NSString stringWithFormat:@" %@ ",obj];
        bgColor = idx%2==0 ? HEX_RGB(0x423D33) : HEX_RGB(0xFCEDD9);
        textColor = idx%2==0 ? HEX_RGB(0xD5BC8B) : HEX_RGB(0xF3B06F);
//        confer.text(text).font(kFontSize6(10)).backgroundColor(bgColor).textColor(textColor);
//        confer.text(@"   ");
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = obj;
        label.backgroundColor = bgColor;
        label.textColor = textColor;
        [superView addSubview:label];
        if (lastLabel) {
            
        }else {
//            [label mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(superView).offset(15);
//                make.
//            }];
        }
    }];
}

@end
