//
//  HKSearchView.m
//  ErpApp
//
//  Created by midland on 2022/7/15.
//

#import "HKSearchView.h"
#import <ErpCommon/ErpCommonDefinition.h>
#import <HFTUIKit/HFTTextKitHeader.h>
#import <RZColorful/RZColorful.h>
#import <HFTCategroy/NSString+Utils.h>
#import <HFTCategroy/UIView+Frame.h>

@interface HKSearchView () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *searchHeaderView;
@property (nonatomic, strong) CommonTextField *textField;
@property (nonatomic, strong) UIImageView *searchIcon;

@end

@implementation HKSearchView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = RGBA(249, 249, 249, 0.4);
        self.backgroundColor = RGBGRAY(249);
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.searchHeaderView];
    [self.searchHeaderView addSubview:self.searchIcon];
    [self.searchHeaderView addSubview:self.textField];
    
    self.searchHeaderView.frame = CGRectMake(kViewSize6(15), kViewSize6(10), self.width - kViewSize6(30), kViewSize6(45));
    self.searchIcon.frame = CGRectMake(kViewSize6(8), kViewSize6(15), kViewSize6(15), kViewSize6(15));
    self.textField.frame = CGRectMake(kViewSize6(32), kViewSize6(3), self.searchHeaderView.width - kViewSize6(20), self.searchHeaderView.height - kViewSize6(6));
        
    self.placeholder = @"请输入楼盘名称开始找房";
}

- (void)setSearchBlock:(void (^)(NSString * _Nonnull))searchBlock {
    _searchBlock = searchBlock;
}

//实现UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //在这里做你响应【Return】键的代码
    EXECUTE_BLOCK(self.searchBlock,textField.text)
    //取消第一响应者，收键盘
    return  [textField resignFirstResponder];
}

- (CommonTextField *)textField {
    if (!_textField) {
        _textField = [[CommonTextField alloc] init];
        _textField.limitedNumber = 100;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.delegate = self;
        _textField.textColor = RGBGRAY(51);
        _textField.font = [UIFont systemFontOfSize:12];
        _textField.returnKeyType = UIReturnKeySearch;
        //    LazyWeakSelf;
        [_textField setTextDidChangeBlock:^(CommonTextField *textField) {
            NSLog(@"输入的搜索项== %@",textField.text);
        }];
    }
    return _textField;
}

- (void)setKeyword:(NSString *)keyword {
    _keyword = keyword;
    if (_keyword.isExist) {
        self.textField.text = _keyword;
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    _textField.attributedPlaceholder = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
//        confer.appendImage(NAME_BUNDLE_IMAGE(@"SearchBuildResource", @"FPSearchImage"));
//        confer.text(@"  ");
        confer.text(_placeholder.isExist?_placeholder:@"搜索").font([UIFont systemFontOfSize:12]).textColor(RGBGRAY(153));
    }];
}


- (UIView *)searchHeaderView {
    if (!_searchHeaderView) {
        _searchHeaderView = [[UIView alloc] init];
//        _searchHeaderView.backgroundColor = RGBGRAY(249);
        _searchHeaderView.backgroundColor = HEX_RGB(0xf4f4f4);
    }
    return _searchHeaderView;
}

- (UIImageView *)searchIcon {
    if (!_searchIcon) {
        _searchIcon = [[UIImageView alloc] initWithImage:NAME_BUNDLE_IMAGE(@"SearchBuildResource", @"FPSearchImage")];
    }
    return _searchIcon;
}


@end
