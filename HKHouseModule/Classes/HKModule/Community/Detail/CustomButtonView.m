//
//  CustomButtonView.m
//  ErpApp
//
//  Created by midland on 2022/7/22.
//

#import "CustomButtonView.h"
#import "HKHouseCommon.h"

@interface CustomButtonView()
/**图片*/
@property (nonatomic, strong) UIImageView *imageView;
/**标题*/
@property (nonatomic, strong) UILabel *titleLabel;
/**title*/
@property (nonatomic, copy) NSString *titleString;
/**被选中的图片*/
@property (nonatomic, copy) NSString *selectedImageString;
/**默认图片*/
@property (nonatomic, copy) NSString *imageString;

@end

@implementation CustomButtonView
#pragma mark - ---------- 初始化 ----------
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self addTapGesture];
    }
    return self;
}
#pragma mark - ---------- 私有方法 ----------
#pragma mark - 加载界面
- (void)initUI {
    // 图片
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 16, 20, 20)];
    _imageView.userInteractionEnabled = NO;
    [self addSubview:_imageView];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // 标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView.bottom+6, self.width, 12)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textColor = RGBGRAY(128);
    _titleLabel.userInteractionEnabled = NO;
    [self addSubview:_titleLabel];
    _imageView.center = CGPointMake(_titleLabel.centerX, _imageView.centerY);
}

#pragma mark - 添加手势
- (void)addTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    [self addGestureRecognizer:tapGesture];
}

#pragma mark - 手势点击Action
- (void)tapGestureAction {
    _isSelected = !_isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(customButtonTapedActionWith:buttonSelected:)]) {
        [self.delegate customButtonTapedActionWith:self buttonSelected:_isSelected];
    }
}

#pragma mark - ---------- 公有方法 ----------
#pragma mark - 设置图片和标题
- (void)setImageWith:(NSString *)imageString SelectedImage:(NSString *)selectedString title:(NSString *)titleString {
    if (imageString.length > 0) {
        _imageString = imageString;
        _imageView.image = rzImage(_imageString);
    }
    if (titleString.length > 0) {
        _titleString = titleString;
        _titleLabel.text = _titleString;
    }
    _selectedImageString = selectedString;
}

#pragma mark - ---------- Setter ----------
- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (_isSelected) {
        _imageView.image = rzImage(_selectedImageString);
        _titleLabel.textColor = kColorTheme;
    } else {
        _imageView.image = rzImage(_imageString);
        _titleLabel.textColor = RGBGRAY(128);
    }
}
@end
