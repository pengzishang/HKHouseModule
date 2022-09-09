//
//  CustomButtonView.h
//  ErpApp
//
//  Created by midland on 2022/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CustomButtonView;

@protocol CommunityCustomButtonViewDelegate <NSObject>

@optional

/**
 view被点击的代理方法
 
 @param view veiw自身
 */
- (void)customButtonTapedActionWith:(CustomButtonView *)view buttonSelected:(BOOL)isSelected;

@end

@interface CustomButtonView : UIView
/**代理*/
@property (nonatomic, weak) id<CommunityCustomButtonViewDelegate> delegate;
/**title*/
@property (nonatomic, copy, readonly) NSString *titleString;
/**是否被选中*/
@property (nonatomic, assign) BOOL isSelected;

/**
 设置图片和标题
 
 @param imageString 图片（默认图片）
 @param selectedString 被选中图片图片
 @param titleString 标题
 */
- (void)setImageWith:(NSString *)imageString SelectedImage:(NSString *)selectedString title:(NSString *)titleString;

@end
NS_ASSUME_NONNULL_END
