//
//  DealZuoshuActionSheet.m
//  ErpApp
//
//  Created by midland on 2022/8/15.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "DealZuoshuActionSheet.h"
#import <HFTCommonDefinition/HFTCommonDefinition.h>
#import <HFTCategroy/UIView+Frame.h>
#import <HFTCategroy/UIImageView+Blur.h>
#import <Masonry/Masonry.h>


#define kRowHeight kViewSize6(44)

@interface DealZuoshuActionSheet() <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong)UIPickerView *pickView;


@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *contentView;
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, copy) NSString *determinelTitle;

@property (nonatomic, strong) NSArray<NSArray *> *dataAry;

@end

@implementation DealZuoshuActionSheet

+ (DealZuoshuActionSheet *)showDealZuoshuSheetWithTitle:(nullable NSString *)title
                                     cancelTitle:(nullable NSString *)cancelTitle
                                 determinelTitle:(nullable NSString *)determinelTitle
                                       dataArray:(NSArray *)dataArray
                                     selectIndex:(NSInteger)selectIndex
                            determineActionBlock:(nullable void (^)(NSInteger row0, NSInteger row1, NSInteger row2, NSInteger row3))determineActionBlock
                                      cancleActionBlock:(nullable void(^)(void))cancleActionBlock {
    DealZuoshuActionSheet *sheet = [[DealZuoshuActionSheet alloc] initWithDataArr:dataArray selectIndex:selectIndex Title:title cancelTitle:cancelTitle determinelTitle:determinelTitle];
    sheet.didSelectPhone = determineActionBlock;
    sheet.CancleAction = cancleActionBlock;
    [sheet show];
    return sheet;
}

- (instancetype)initWithDataArr:(NSArray<NSArray *> *)dataArr
                    selectIndex:(NSInteger)selectIndex
                          Title:(nullable NSString *)title
                    cancelTitle:(nullable NSString *)cancelTitle
                determinelTitle:(nullable NSString *)determinelTitle {
    NSAssert(dataArr.count > 0, @"dataArr 不能为空");
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.title = title;
        self.cancelTitle = cancelTitle;
        self.determinelTitle = determinelTitle;
        self.dataAry = dataArr;
        
        [self createAPPActionSheetSubView];
    }
    return self;
}


- (void)createAPPActionSheetSubView {
    _coverView = [[UIView alloc] initWithFrame:self.bounds];
    _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    if (self.cancelTitle.length > 0) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCoverView:)];
        [_coverView addGestureRecognizer:tap];
    }
    
    [self addSubview:_coverView];
    
    CGFloat contentView = 0.0;

    CGFloat tableHeight = 5 * kRowHeight;
    contentView += tableHeight;
    // 顶部
    if (self.title) {
        contentView += self.headerView.frame.size.height;
    }
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, contentView)];
    [self addSubview:_contentView];
    // titleview
    [_contentView addSubview:self.headerView];

    _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.headerView?self.headerView.frame.size.height:0, self.frame.size.width, tableHeight)];
    _pickView.backgroundColor = RGB(254, 254, 254);
    _pickView.delegate = self;
    _pickView.dataSource = self;
    [_contentView addSubview:_pickView];
}

#pragma mark - lazy load
- (UIView *)headerView {
    if (!self.title) {
        return nil;
    }
    if (!_headerView) {
        CGFloat posY = 18.0;
        UILabel *titleView = nil;
        titleView = [[UILabel alloc] initWithFrame:CGRectMake(15, posY, self.width-2*15, MAXFLOAT)];
        titleView.font = kFontSize6(13);
        titleView.textColor = RGBGRAY(102);
        titleView.numberOfLines = 2;
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.text = self.title;
        [titleView sizeToFit];
        titleView.frame = CGRectMake(15, posY, self.width-2*15, titleView.height);
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, titleView.height+2*posY+0.5)];
        _headerView.backgroundColor = RGBGRAY(249);
        [_headerView addSubview:titleView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.height-0.5, self.width, 0.5)];
        line.backgroundColor = RGBGRAY(245);
        [_headerView addSubview:line];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.cancelTitle forState:UIControlStateNormal];
        btn.titleLabel.font = kFontSize6(14);
        [btn setTitleColor:RGBGRAY(153) forState:UIControlStateNormal];
        [_headerView addSubview:btn];
        [btn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(24);
            make.centerY.equalTo(titleView.mas_centerY);
        }];
        
        UIButton *determineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [determineBtn setTitle:self.determinelTitle forState:UIControlStateNormal];
        determineBtn.titleLabel.font = kFontSize6(14);
        [determineBtn setTitleColor:RGB(51,150,251) forState:UIControlStateNormal];
        [_headerView addSubview:determineBtn];
        [determineBtn addTarget:self action:@selector(determineClick) forControlEvents:UIControlEventTouchUpInside];
        [determineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-24);
            make.centerY.equalTo(titleView.mas_centerY);
        }];
    }
    return _headerView;
}

#pragma mark - action
- (void)tapCoverView:(UITapGestureRecognizer *)tap {
    if (!CGRectContainsPoint(_contentView.frame, [tap locationInView:self])) {
        [self cancelClick];
    }
}

- (void)cancelClick {
    if (self.CancleAction) {
        self.CancleAction();
    }
    [self dismiss];
}

- (void)determineClick {
    if (self.didSelectPhone){
        NSInteger row0 = [self.pickView selectedRowInComponent:0];
        NSInteger row1 = [self.pickView selectedRowInComponent:1];
        NSInteger row2 = [self.pickView selectedRowInComponent:2];
        NSInteger row3 = [self.pickView selectedRowInComponent:3];
        
        self.didSelectPhone(row0, row1, row2, row3);
    }
    [self dismiss];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.pickView reloadAllComponents];
    
    self.contentView.y = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.height = self.height;
        CGFloat posY = [UIScreen mainScreen].bounds.size.height - self.contentView.height - kSafeBottomMargin;
        self.contentView.y = posY;
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.height = self.height;
        self.contentView.y = [UIScreen mainScreen].bounds.size.height;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.contentView removeFromSuperview];
            self.contentView = nil;
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - pickView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.dataAry.count;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component==3) {

        NSInteger component1Row = [self.pickView selectedRowInComponent:1];
        CommunityBuildModel *communityBuildModel = [self.dataAry[1] objectAtIndex:component1Row];
        return communityBuildModel.buildVos.count;
    }else {
        return self.dataAry[component].count;
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    
    //用label来设置字体大小
    myView.backgroundColor = [UIColor clearColor];
    if (component==3) {
        NSInteger component1Row = [self.pickView selectedRowInComponent:1];
        CommunityBuildModel *communityBuildModel = [self.dataAry[1] objectAtIndex:component1Row];
        if (row < communityBuildModel.buildVos.count) {
            myView.text = communityBuildModel.buildVos[row].buildingName;
        }
    }else if (component == 1) {
        CommunityBuildModel *communityBuildModel = self.dataAry[component][row];
        myView.text = communityBuildModel.phaseName;
    }else {
        myView.text = self.dataAry[component][row];
    }
    
    if (component == 0 || component == 2) {
        myView.font = [UIFont systemFontOfSize:13];
    }
    
    if (component == 1 || component == 3) {
        myView.font = [UIFont systemFontOfSize:17];
    }
   
    return myView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 1) {
        [pickerView reloadComponent:3];
    }
}

@end
