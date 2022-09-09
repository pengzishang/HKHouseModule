//
//  HorizontalFlowLayout.m
//  ErpApp
//
//  Created by midland on 2022/8/15.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "HorizontalFlowLayout.h"

@interface HorizontalFlowLayout ()

@property (strong, nonatomic) NSMutableArray *allAttributes;
@property (nonatomic, assign) CGSize contentSize;
@end

@implementation HorizontalFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    /// 计算出每个item的布局，以及contentSize
    self.allAttributes = [NSMutableArray arrayWithCapacity:0];
    
    CGFloat itemWidth = self.itemSize.width;
    CGFloat itemHeight = self.itemSize.height;
    
    CGFloat contentWidth = 0;
    
    NSInteger sectionNum = [self.collectionView numberOfSections];
    for (int i = 0; i < sectionNum; i++) {
        
        NSInteger itemNum = [self.collectionView numberOfItemsInSection:i];
        /// 取最大的
        if (contentWidth < itemWidth*itemNum) {
            contentWidth = (itemWidth +self.minimumLineSpacing)*itemNum;
        }
        
        for (int j = 0; j < itemNum; j++) {
            UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
            layoutAttributes.frame = CGRectMake((itemWidth+self.minimumLineSpacing)*j, (itemHeight+self.minimumInteritemSpacing)*i, itemWidth, itemHeight);
            [self.allAttributes addObject:layoutAttributes];
        }
    }
    self.contentSize = CGSizeMake(contentWidth, self.collectionViewContentSize.height);
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = 0;
//    NSInteger sectionNum = [self.collectionView numberOfSections];
    for (int i = 0; i < indexPath.section; i++) {
        NSInteger itemNum = [self.collectionView numberOfItemsInSection:i];
        index += itemNum;
    }
    index = index + indexPath.item;
    UICollectionViewLayoutAttributes *layoutAttributes = self.allAttributes[index];
    return layoutAttributes;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    return self.allAttributes;
}


@end
