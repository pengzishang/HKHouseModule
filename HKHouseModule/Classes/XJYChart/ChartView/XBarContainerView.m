//
//  XBarContainerView.m
//  RecordLife
//
//  Created by 谢俊逸 on 16/03/2017.
//  Copyright © 2017 谢俊逸. All rights reserved.
//

#import "XBarContainerView.h"
#import "XAuxiliaryCalculationHelper.h"
#import "XAbscissaView.h"
#import "XColor.h"
#import "XAnimationLabel.h"
#import "XAnimation.h"
#import "XNotificationBridge.h"
#import "CALayer+XLayerSelectHelper.h"
#import "XBarChartConfiguration.h"
#import <BlocksKit/NSArray+BlocksKit.h>
#import "Masonry.h"
#import "YYCategories/UIView+YYAdd.h"
#import "HFTCommonDefinition/HFTCommonDefinition.h"

#pragma mark - Macro

#define PointDiameter 2.0

#define GradientFillColor1          \
  [UIColor colorWithRed:117 / 255.0 \
                  green:184 / 255.0 \
                   blue:245 / 255.0 \
                  alpha:1]          \
      .CGColor
#define GradientFillColor2                                                     \
  [UIColor colorWithRed:24 / 255.0 green:141 / 255.0 blue:240 / 255.0 alpha:1] \
      .CGColor
#define BarBackgroundFillColor \
  [UIColor colorWithRed:232 / 255.0 green:232 / 255.0 blue:232 / 255.0 alpha:1]
#define animationDuration 3

@interface XBarContainerView ()
@property(nonatomic, strong) CABasicAnimation* pathAnimation;
@property(nonatomic, strong) NSMutableArray<NSValue*>* pointsArrays;
@property(nonatomic, strong) NSMutableArray<UIColor*>* colorArray;
@property(nonatomic, strong) NSMutableArray<NSString*>* dataDescribeArray;
@property(nonatomic, strong) NSMutableArray<NSNumber*>* dataNumberArray;
@property(nonatomic, strong)
    NSMutableArray<CAShapeLayer*>* layerArray;  // value layer
@property(nonatomic, strong)
    NSMutableArray<CAShapeLayer*>* backgroundLayerArray;  // background layer
@property(nonatomic, strong) CALayer* coverLayer;
@property(nonatomic, strong)
    NSMutableArray<XAnimationLabel*>* animationLabelArray;

@property(nonatomic, strong) UIView *popContentView;

@end

@implementation XBarContainerView

- (instancetype)initWithFrame:(CGRect)frame
                dataItemArray:(NSMutableArray<XBarItem*>*)dataItemArray
                    topNumber:(NSNumber*)topNumbser
                 bottomNumber:(NSNumber*)bottomNumber
          chartConfiguration:(XBarChartConfiguration*)configuration
{
  if (self = [super initWithFrame:frame]) {
    self.configuration = configuration;
    if (self.chartBackgroundColor == nil) {
      self.chartBackgroundColor = XJYWhite;
    }
    self.backgroundColor = self.chartBackgroundColor;

    self.coverLayer = [CALayer layer];

    self.layerArray = [[NSMutableArray alloc] init];
    self.backgroundLayerArray = [[NSMutableArray alloc] init];
    self.colorArray = [[NSMutableArray alloc] init];
    self.dataNumberArray = [[NSMutableArray alloc] init];
      self.pointsArrays = [NSMutableArray array];
    self.animationLabelArray = [NSMutableArray new];

    self.dataItemArray = dataItemArray;
    self.top = topNumbser;
    self.bottom = bottomNumber;
      
      _popContentView = [UIView new];
      _popContentView.backgroundColor = [UIColor whiteColor];
      [self addSubview:_popContentView];

      [_popContentView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.width.equalTo(@85);
          make.height.equalTo(@38.5);
      }];
      _popContentView.layer.shadowColor = [UIColor blackColor].CGColor;
      _popContentView.layer.shadowRadius = 3;
      _popContentView.layer.shadowOpacity = 0.08;
      _popContentView.layer.shadowOffset = CGSizeMake(1, 2);
      _popContentView.layer.cornerRadius = 4;
      [_popContentView setHidden:YES];

#pragma mark Notification
    // App Alive Animation Notification
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(becomeAlive)
               name:UIApplicationDidBecomeActiveNotification
             object:nil];

    // App Resign Set Animation Start State
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(enterBackground)
               name:UIApplicationDidEnterBackgroundNotification
             object:nil];
  }
  return self;
}

#pragma mark Draw

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  //    [self cleanPreDrawAndData];
  //    [self strokeChart];
  [self startAnimation];
}

- (void)refreshView {
  [self cleanPreDrawAndData];
  [self strokeChart];
}

- (void)startAnimation {
  [self refreshView];
}

- (void)cleanPreDrawAndData {
  // remove layer
  [self.layerArray
      enumerateObjectsUsingBlock:^(CAShapeLayer* _Nonnull obj, NSUInteger idx,
                                   BOOL* _Nonnull stop) {
        [obj removeFromSuperlayer];
      }];
  [self.backgroundLayerArray
      enumerateObjectsUsingBlock:^(CAShapeLayer* _Nonnull obj, NSUInteger idx,
                                   BOOL* _Nonnull stop) {
        [obj removeFromSuperlayer];
      }];
  [self.animationLabelArray
      enumerateObjectsUsingBlock:^(XAnimationLabel* _Nonnull obj,
                                   NSUInteger idx, BOOL* _Nonnull stop) {
        [obj removeFromSuperview];
      }];
  [self.coverLayer removeFromSuperlayer];

  // clean array
  [self.animationLabelArray removeAllObjects];
  [self.layerArray removeAllObjects];
  [self.backgroundLayerArray removeAllObjects];
  [self.colorArray removeAllObjects];
  [self.dataNumberArray removeAllObjects];
}

- (void)strokeChart {
  // data filter
    self.pointsArrays = [self getPointsArrays];
  [self.dataItemArray
      enumerateObjectsUsingBlock:^(XBarItem* _Nonnull obj, NSUInteger idx,
                                   BOOL* _Nonnull stop) {
        [self.colorArray addObject:obj.color];
        [self.dataNumberArray addObject:obj.dataNumber];
        [self.dataDescribeArray addObject:obj.dataDescribe];
      }];

  // background layer
  NSMutableArray<NSNumber*>* xArray = [[self getxArray] copy];
  NSMutableArray<NSValue*>* rectArray =
      [self getBackgroundRectArrayWithXArray:xArray];
  self.backgroundLayerArray = [self getBackgroundLayerWithRectArray:rectArray];
  [self.backgroundLayerArray
      enumerateObjectsUsingBlock:^(CAShapeLayer* _Nonnull obj, NSUInteger idx,
                                   BOOL* _Nonnull stop) {
        [self.layer addSublayer:obj];
      }];

  // fill layer
  NSMutableArray<NSNumber*>* fillHeightArray = [[NSMutableArray alloc] init];
  [self.dataItemArray
      enumerateObjectsUsingBlock:^(XBarItem* _Nonnull obj, NSUInteger idx,
                                   BOOL* _Nonnull stop) {
        CGFloat height =
            [[XAuxiliaryCalculationHelper shareCalculationHelper]
                calculateTheProportionOfHeightByTop:self.top.doubleValue
                                             bottom:self.bottom.doubleValue
                                             height:self.dataNumberArray[idx]
                                                        .doubleValue] *
            self.bounds.size.height;
        [fillHeightArray addObject:@(height)];
      }];

  NSMutableArray<NSValue*>* fillRectArray = [[NSMutableArray alloc] init];
  [xArray enumerateObjectsUsingBlock:^(NSNumber* _Nonnull obj, NSUInteger idx,
                                       BOOL* _Nonnull stop) {
    // height - fillHeightArray[idx].doubleValue 计算起始Y
    CGRect fillRect = CGRectMake(
        obj.doubleValue - [self getBarWidthWithItemCount:xArray.count] / 2,
        [self getTotalBarHeight] - fillHeightArray[idx].doubleValue,
        [self getBarWidthWithItemCount:xArray.count],
        fillHeightArray[idx].doubleValue);
    [fillRectArray addObject:[NSValue valueWithCGRect:fillRect]];
  }];

  NSMutableArray* fillShapeLayerArray = [[NSMutableArray alloc] init];
  [fillRectArray enumerateObjectsUsingBlock:^(NSValue* _Nonnull obj,
                                              NSUInteger idx,
                                              BOOL* _Nonnull stop) {
    CGRect fillRect = obj.CGRectValue;
    CAShapeLayer* fillRectShapeLayer =
        [self rectAnimationLayerWithBounds:fillRect
                                 fillColor:self.dataItemArray[idx].color];
    // animation number label
    XAnimationLabel* topLabel = [self
        topLabelWithRect:CGRectMake(fillRect.origin.x, fillRect.origin.y - 15,
                                    fillRect.size.width, 15)
               fillColor:[UIColor clearColor]
                    text:self.dataNumberArray[idx].stringValue];

    [self addSubview:topLabel];
    [self.animationLabelArray addObject:topLabel];

    [topLabel countFromCurrentTo:topLabel.text.floatValue
                        duration:animationDuration];

    // toplabel center change
    CGPoint tempCenter = topLabel.center;
    topLabel.center = CGPointMake(topLabel.center.x,
                                  topLabel.center.y + fillRect.size.height);
    [UIView animateWithDuration:animationDuration
                     animations:^{
                       topLabel.center = tempCenter;
                     }];

    [self.layer addSublayer:fillRectShapeLayer];
    [self.layerArray addObject:fillRectShapeLayer];
    [fillShapeLayerArray addObject:fillRectShapeLayer];
  }];
}

// compute Points Arrays
- (NSMutableArray<NSValue*>*)getPointsArrays {
    // 避免重复计算
    if (self.pointsArrays.count > 0) {
        return self.pointsArrays;
    } else {
        NSMutableArray* pointsArrays = [NSMutableArray new];
        [self.dataItemArray enumerateObjectsUsingBlock:^(XBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGPoint point = [self calculateDrawablePointWithNumber:obj.dataNumber
                                                               idx:idx
                                                             count:self.dataItemArray.count
                                                            bounds:self.bounds];
            NSValue* pointValue = [NSValue valueWithCGPoint:point];
            [pointsArrays addObject:pointValue];
        }];
        return pointsArrays;
    }
}


- (CGFloat)getTotalBarHeight {
  return self.bounds.size.height;
}

- (CGFloat)getBarWidthWithItemCount:(NSUInteger)count {
  if (self.configuration.x_width) {
    return self.configuration.x_width;
  }
  return (self.bounds.size.width / count) / 3 * 2;
}

- (NSMutableArray*)getxArray {
  // x coordinates
  NSMutableArray<NSNumber*>* xArray = [[NSMutableArray alloc] init];
  [self.dataItemArray
      enumerateObjectsUsingBlock:^(XBarItem* _Nonnull obj, NSUInteger idx,
                                   BOOL* _Nonnull stop) {
        CGFloat x =
            self.bounds.size.width *
            [[XAuxiliaryCalculationHelper shareCalculationHelper]
                calculateTheProportionOfWidthByIdx:idx
                                             count:self.dataItemArray.count];
        [xArray addObject:@(x)];
      }];
  return xArray;
}

- (NSMutableArray*)getBackgroundRectArrayWithXArray:
    (NSMutableArray<NSNumber*>*)xArray {
  NSMutableArray<NSValue*>* rectArray = [[NSMutableArray alloc] init];
  [xArray enumerateObjectsUsingBlock:^(NSNumber* number, NSUInteger idx,
                                       BOOL* _Nonnull stop) {
    CGRect rect = CGRectMake(
        number.doubleValue - [self getBarWidthWithItemCount:xArray.count] / 2,
        0, [self getBarWidthWithItemCount:xArray.count],
        [self getTotalBarHeight]);
    [rectArray addObject:[NSValue valueWithCGRect:rect]];
  }];
  return rectArray;
}

- (NSMutableArray<CAShapeLayer*>*)getBackgroundLayerWithRectArray:
    (NSMutableArray<NSValue*>*)rectArray {
  NSMutableArray<CAShapeLayer*>* backgroundLayerArray =
      [[NSMutableArray alloc] init];
  // background layer
  [rectArray enumerateObjectsUsingBlock:^(NSValue* _Nonnull obj, NSUInteger idx,
                                          BOOL* _Nonnull stop) {
    CGRect rect = obj.CGRectValue;
    CAShapeLayer* rectShapeLayer =
        [self rectShapeLayerWithBounds:rect fillColor:BarBackgroundFillColor];
    [backgroundLayerArray addObject:rectShapeLayer];
  }];
  return backgroundLayerArray;
}

#pragma mark Helper
/**
 计算点通过 数值 和 idx

 @param number number
 @param idx like 0.1.2.3...
 @return CGPoint
 */
// Calculate -> Point
- (CGPoint)calculateDrawablePointWithNumber:(NSNumber*)number
                                        idx:(NSUInteger)idx
                                      count:(NSUInteger)count
                                     bounds:(CGRect)bounds {
  CGFloat percentageH = [[XAuxiliaryCalculationHelper shareCalculationHelper]
      calculateTheProportionOfHeightByTop:self.top.doubleValue
                                   bottom:self.bottom.doubleValue
                                   height:number.doubleValue];
  CGFloat percentageW = [[XAuxiliaryCalculationHelper shareCalculationHelper]
      calculateTheProportionOfWidthByIdx:(idx)
                                   count:count];
  CGFloat pointY = percentageH * bounds.size.height;
  CGFloat pointX = percentageW * bounds.size.width;
  CGPoint point = CGPointMake(pointX, pointY);
  CGPoint rightCoordinatePoint =
      [[XAuxiliaryCalculationHelper shareCalculationHelper]
          changeCoordinateSystem:point
                  withViewHeight:self.frame.size.height];
  return rightCoordinatePoint;
}

#pragma mark Get

#pragma mark HelpMethods

- (CAShapeLayer*)rectAnimationLayerWithBounds:(CGRect)rect
                                    fillColor:(UIColor*)fillColor {
  // real startPoint endPoint
  CGPoint startPoint = CGPointMake(rect.origin.x + (rect.size.width) / 2,
                                   (rect.origin.y + rect.size.height));
  CGPoint endPoint =
      CGPointMake(rect.origin.x + (rect.size.width) / 2, (rect.origin.y));

  CAShapeLayer* chartLine = [CAShapeLayer layer];
  chartLine.lineCap = kCALineCapSquare;
  chartLine.lineJoin = kCALineJoinRound;
  chartLine.lineWidth = rect.size.width;

  // animation path(beacause of line width...so animation path must defferent
  // with real path)
  CGPoint temStartPoint =
      CGPointMake(startPoint.x, startPoint.y + rect.size.width / 2);
  CGPoint temEndPoint =
      CGPointMake(endPoint.x, endPoint.y + rect.size.width / 2);
  UIBezierPath* temPath = [[UIBezierPath alloc] init];
  [temPath moveToPoint:temStartPoint];
  [temPath addLineToPoint:temEndPoint];

  chartLine.path = temPath.CGPath;
  chartLine.strokeStart = 0.0;
  chartLine.strokeEnd = 1.0;
  chartLine.strokeColor = fillColor.CGColor;
  [chartLine addAnimation:self.pathAnimation forKey:@"strokeEndAnimation"];
  // help to judge is touch in area
  chartLine.frameValue = [NSValue valueWithCGRect:rect];
  chartLine.selectStatusNumber = [NSNumber numberWithBool:NO];
  return chartLine;
}

- (CAShapeLayer*)rectShapeLayerWithBounds:(CGRect)rect
                                fillColor:(UIColor*)fillColor {
  UIBezierPath* path = [UIBezierPath bezierPathWithRect:rect];
  CAShapeLayer* rectLayer = [CAShapeLayer layer];
  rectLayer.path = path.CGPath;
  rectLayer.fillColor = fillColor.CGColor;
  rectLayer.path = path.CGPath;
  rectLayer.frameValue = [NSValue valueWithCGRect:rect];
  return rectLayer;
}

- (XAnimationLabel*)topLabelWithRect:(CGRect)rect
                           fillColor:(UIColor*)color
                                text:(NSString*)text {
  XAnimationLabel *label = [XAnimationLabel topLabelWithFrame:rect text:text textColor:[UIColor black50PercentColor] fillColor:color];
  label.verticalAlignment = XVerticalAlignmentBottom;
//  label.font = [UIFont systemFontOfSize:8];
  return label;
}

- (CAGradientLayer*)rectCoverGradientLayerWithBounds:(CGRect)rect {
  CAGradientLayer* gradientLayer = [CAGradientLayer layer];
  gradientLayer.frame = rect;
  gradientLayer.colors =
      @[ (__bridge id)GradientFillColor1, (__bridge id)GradientFillColor2 ];
  gradientLayer.startPoint = CGPointMake(0.5, 0);
  gradientLayer.endPoint = CGPointMake(0.5, 1);
  //    [gradientLayer addAnimation:[XAnimation
  //    getBarChartSpringAnimationWithLayer:gradientLayer] forKey:@""];
  [[XAnimation shareInstance] addLSSpringFrameAnimation:gradientLayer];
  return gradientLayer;
}

- (CABasicAnimation*)pathAnimation {
  _pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
  _pathAnimation.duration = animationDuration;
  _pathAnimation.timingFunction = [CAMediaTimingFunction
      functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  _pathAnimation.fromValue = @0.0f;
  _pathAnimation.toValue = @1.0f;
  return _pathAnimation;
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event {
  CGPoint __block point = [[touches anyObject] locationInView:self];

  // touch whole bar
  [self.backgroundLayerArray enumerateObjectsUsingBlock:^(CALayer* _Nonnull obj,
                                                          NSUInteger idx,
                                                          BOOL* _Nonnull stop) {
    CAShapeLayer* shapeLayer = (CAShapeLayer*)obj;
    CGRect layerFrame = shapeLayer.frameValue.CGRectValue;

    if (CGRectContainsPoint(layerFrame, point)) {
      //上一次点击的layer,清空上一次的状态
      CAShapeLayer* preShapeLayer =
          (CAShapeLayer*)
              self.layerArray[self.coverLayer.selectIdxNumber.intValue];
      preShapeLayer.selectStatusNumber = [NSNumber numberWithBool:NO];
      [self.coverLayer removeFromSuperlayer];

      // Notification + Delegate To CallBack
      [[NSNotificationCenter defaultCenter]
          postNotificationName:[XNotificationBridge shareXNotificationBridge]
                                   .TouchBarNotification
                        object:nil
                      userInfo:
                          @{
                                [XNotificationBridge shareXNotificationBridge].
                                BarIdxNumberKey : @(idx)
                          }];
      CAShapeLayer* subShapeLayer = (CAShapeLayer*)self.layerArray[idx];
      if (subShapeLayer.selectStatusNumber.boolValue == YES) {
        subShapeLayer.selectStatusNumber = [NSNumber numberWithBool:NO];
        [self.coverLayer removeFromSuperlayer];
        return;
      }
      BOOL boolValue = subShapeLayer.selectStatusNumber.boolValue;
      subShapeLayer.selectStatusNumber = [NSNumber numberWithBool:!boolValue];
      self.coverLayer =
          [self rectCoverGradientLayerWithBounds:subShapeLayer.frameValue
                                                     .CGRectValue];
      self.coverLayer.selectIdxNumber = @(idx);

      [subShapeLayer addSublayer:self.coverLayer];
      return;
    }
  }];
    // 这些都是按照以前思路写的,一言难尽
    NSArray<NSValue*>* points = self.pointsArrays;
    /// 找到点击了哪个点
    NSInteger resultIndex = -1;
    for (int i = 0; i < points.count; i++) {
        CGPoint center = points[i].CGPointValue;
        CGFloat r = PointDiameter * 2;
        CGRect currentRect = CGRectMake(center.x-r, 0, r*2, self.height);
        if (CGRectContainsPoint(currentRect, point)) {
            resultIndex = i;
            NSLog(@"点击了%d--%@",i,points[i]);
        }
    }
    
    [self.popContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    if (resultIndex >= 0 && resultIndex < self.dataItemArray.count) {
        [self bringSubviewToFront:self.popContentView];
        [self.popContentView setHidden:NO];
        [self creatPopViewWithCount:[self.dataItemArray[resultIndex].dataNumber stringValue]   clickPoint:points[resultIndex].CGPointValue];
    } else {
        [self.popContentView setHidden:YES];
    }
}

- (void)creatPopViewWithCount:(NSString *)count clickPoint:(CGPoint)point {
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = kFontSize6(9);
    dateLabel.text = @"注册量";
    dateLabel.textColor = HEX_RGB(0x444444);
    dateLabel.textAlignment = NSTextAlignmentLeft;
    [_popContentView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_popContentView).offset(9);
        make.left.equalTo(_popContentView).offset(5);
        make.right.equalTo(_popContentView).inset(5);
    }];
    
    UIView *squareView = [UIView new];
    squareView.backgroundColor = HEX_RGB(0x7D5D23);
    [_popContentView addSubview:squareView];
    [squareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_popContentView).offset(5);
        make.width.equalTo(@10);
        make.height.equalTo(@4);
        make.top.equalTo(dateLabel.mas_bottom).offset(4);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.font = kFontSize6(9);
    priceLabel.text = [NSString stringWithFormat:@"%@宗",count];
    priceLabel.textColor = HEX_RGB(0x444444);
    [_popContentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(squareView);
        make.right.equalTo(_popContentView).inset(5);
//        make.bottom.equalTo(_popContentView).inset(8);
        make.left.equalTo(squareView.mas_right).offset(6);
    }];
    CGFloat safeInset = 2;
    [_popContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@85);
        make.height.equalTo(@38.5);
        if (point.y + 38.5 + safeInset > self.height ) {
            make.bottom.equalTo(self).inset(self.height - point.y + safeInset);
        } else {
            make.top.equalTo(self).inset(point.y);
        }
        if (point.x + 85 + safeInset  > self.width ) {
            make.right.equalTo(self).inset(self.width - point.x + safeInset);
        } else {
            make.left.equalTo(self).inset(point.x + safeInset);
        }
    }];
}


#pragma mark Notification Action

- (void)becomeAlive {
  [self startAnimation];
}

- (void)enterBackground {
  [self cleanPreDrawAndData];
}

@end
