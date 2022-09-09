//
//  HKPhotosView.m
//  ErpApp
//
//  Created by midland on 2022/8/9.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "HKPhotosView.h"
#import "HKHouseCommon.h"
#import "SegementPhotoView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import <HFTCategroy/NSString+Utils.h>
#import "HKPhotoBrowserVC.h"

@implementation PhotosViewModel

- (instancetype)initWithTitle:(NSString *)title imageURLString:(NSArray *)imageURLStrings {
    self = [super init];
    if (self) {
        self.title = title;
        self.imageURLStrings = imageURLStrings;
    }
    return self;
}

@end

@interface HKPhotosView() <SDCycleScrollViewDelegate>

@property (nonatomic, strong)NSMutableArray *buttons;

@property (nonatomic, strong) SDCycleScrollView *photosView; // 轮播图
/// 切换View
@property (nonatomic, strong)SegementPhotoView *segementPhotoView;
/// 下标
@property (nonatomic, strong)UILabel *indexLabel;
/// 选中的模块下标: 默认：0
@property (nonatomic, assign)NSInteger selectedSegementIndex;

@end

@implementation HKPhotosView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createDefaultData];
        
        [self createUI];
    }
    return self;
}

- (void)createDefaultData {
    self.selectedSegementIndex = 0;
    _dataSource = [NSArray array];
}

- (void)setDataSource:(NSArray<PhotosViewModel *> *)dataSource {
    if (dataSource.count == 0) {
        return;
    }
    _dataSource = dataSource;
    
    NSMutableArray *result = [NSMutableArray array];
    [_dataSource enumerateObjectsUsingBlock:^(PhotosViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObjectsFromArray:obj.imageURLStrings];
    }];
    _photosView.imageURLStringsGroup = result;
    
    self.segementPhotoView.dataSource = [dataSource bk_map:^id(PhotosViewModel *obj) {
        return obj.title;
    }];
    
    [self setIndexLabelText:[NSString stringWithFormat:@"1/%lu",(unsigned long)self.dataSource[self.selectedSegementIndex].imageURLStrings.count]];
}

- (void)createUI {
    [self addSubview:self.photosView];
    
    _segementPhotoView = [[SegementPhotoView alloc] initWithFrame:CGRectMake(15, self.height - 20 - 22, 0, 0)];
    _segementPhotoView.selectIndex = self.selectedSegementIndex;
    [self addSubview:_segementPhotoView];
    @weakify(self);
    [_segementPhotoView setSelectBlock:^(NSInteger selectedIndex) {
        @strongify(self);
        __block NSUInteger mayBeIndex = 0;
        [self.dataSource enumerateObjectsUsingBlock:^(PhotosViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx < selectedIndex) {
                mayBeIndex += obj.imageURLStrings.count;
            } else {
                *stop = YES;
            }
        }];
        self.selectedSegementIndex = mayBeIndex;
        [self.photosView makeScrollViewScrollToIndex: self.selectedSegementIndex];
    }];
    
    [self addSubview:self.indexLabel];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segementPhotoView);
        make.height.mas_equalTo(22);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(0);
    }];
    
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc]init];
        _indexLabel.font = kFontSize6(11);
        _indexLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _indexLabel.layer.cornerRadius = 11;
        _indexLabel.layer.masksToBounds = YES;
        _indexLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _indexLabel;
}

- (SDCycleScrollView *)photosView {
    if (!_photosView) {
        _photosView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, self.height) delegate:self placeholderImage:kErpLoadRectangleImage];
        _photosView.showPageControl = NO;
        [_photosView setValue:@(UIViewContentModeScaleAspectFill) forKeyPath:@"_backgroundImageView.contentMode"];
        _photosView.autoScroll = NO;
        _photosView.infiniteLoop = NO;
        _photosView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _photosView;
}

/// 点击
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    NSMutableArray <HKPhotoBrowserItemModel *> *photos = [NSMutableArray new];
    
    photos = [self.dataSource bk_map:^HKPhotoBrowserItemModel *(PhotosViewModel *obj) {
        HKPhotoBrowserItemModel *itemModel = [[HKPhotoBrowserItemModel alloc] init];
        itemModel.title = obj.title;
        
        itemModel.photos = [obj.imageURLStrings bk_map:^PhotoPreviewModel *(NSString *obj) {
            PhotoPreviewModel *preViewModel = [[PhotoPreviewModel alloc] init];
            preViewModel.imageURL = obj;
            return preViewModel;
        }].mutableCopy;
        return itemModel;
    }].mutableCopy;
    
    HKPhotoBrowserVC *vc = [[HKPhotoBrowserVC alloc]init];
    vc.photos = photos;
    vc.currentIndex = index;
    vc.isShowNav = YES;
    vc.isShowStatusBar = YES;
//    [[HFTControllerManager getCurrentAvailableNavController] pushViewController:vc animated:YES];
    [[HFTControllerManager getCurrentVC] presentViewController:vc animated:YES completion:nil];
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    NSLog([NSString stringWithFormat:@"当前位置%ld",index]);

    __block NSUInteger count = 0;
    __block NSString *title = @"";
    __block NSUInteger toolsBarIndex = 0;
    [self.dataSource enumerateObjectsUsingBlock:^(PhotosViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index < count + obj.imageURLStrings.count) {
            title = [NSString stringWithFormat:@"%ld/%ld", index - count + 1, obj.imageURLStrings.count];
            toolsBarIndex = idx;
            *stop = YES;
        } else {
            count += obj.imageURLStrings.count;
        }
    }];
    
    [self setIndexLabelText:title];
    self.segementPhotoView.selectIndex = toolsBarIndex;
}

- (void)setIndexLabelText:(NSString *)title {
    self.indexLabel.text = title;
    CGFloat width = [title getWidthStrWithFontSize:kFontPointSize6(11) height:22];
    [self.indexLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width+20);
    }];
}

@end
