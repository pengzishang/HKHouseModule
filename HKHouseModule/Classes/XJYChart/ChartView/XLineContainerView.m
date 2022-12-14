//
//  XLineContainerView.m
//  RecordLife
//
//  Created by 谢俊逸 on 17/03/2017.
//  Copyright © 2017 谢俊逸. All rights reserved.
//
// macOS  和 iOS 的坐标系问题

#import "XLineContainerView.h"
#import "XAuxiliaryCalculationHelper.h"
#import "XColor.h"
#import "XAnimationLabel.h"
#import "XAnimation.h"
#import "XPointDetect.h"
#import "CALayer+XLayerSelectHelper.h"
#import "CAShapeLayer+XLayerHelper.h"
#import "XJYNumberLabelDecoration.h"
#import "HKHouseCommon.h"
#pragma mark - Macro

#define LineWidth 2.0
#define PointDiameter 10.0
#define ExpandMaxCount 5

// Control Touch Area
CGFloat touchLineWidth = 20;

@interface XLineContainerView ()
@property(nonatomic, strong) CABasicAnimation* pathAnimation;

@property(nonatomic, strong) CAShapeLayer* coverLayer;

@property(nonatomic, strong) UIView *popContentView;

/**
 All lines points
 */
@property(nonatomic, strong)
    NSMutableArray<NSMutableArray<NSValue*>*>* pointsArrays;
@property(nonatomic, strong) NSMutableArray<CAShapeLayer*>* shapeLayerArray;
@property(nonatomic, strong) NSMutableArray<CAShapeLayer*>* pointLayerArray;
@property(nonatomic, strong) XJYNumberLabelDecoration* numberLabelDecoration;
@end

@implementation XLineContainerView

- (instancetype)initWithFrame:(CGRect)frame
                dataItemArray:(NSMutableArray<XLineChartItem*>*)dataItemArray
                    topNumber:(NSNumber*)topNumber
                 bottomNumber:(NSNumber*)bottomNumber
                configuration:(XNormalLineChartConfiguration*)configuration {\
    if (self = [super initWithFrame:frame]) {
        self.configuration = configuration;
        self.backgroundColor = self.configuration.chartBackgroundColor;
        
        self.coverLayer = [CAShapeLayer layer];
        self.shapeLayerArray = [NSMutableArray new];
        self.pointsArrays = [NSMutableArray new];
        self.numberLabelDecoration = [[XJYNumberLabelDecoration alloc] initWithViewer:self];
        self.pointLayerArray = [NSMutableArray new];
        
        self.dataItemArray = dataItemArray;
        self.top = topNumber;
        self.bottom = bottomNumber;
        
        _popContentView = [UIView new];
        _popContentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_popContentView];

        [_popContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@100);
            make.height.equalTo(@45);
        }];
        _popContentView.layer.shadowColor = [UIColor blackColor].CGColor;
        _popContentView.layer.shadowRadius = 3;
        _popContentView.layer.shadowOpacity = 0.08;
        _popContentView.layer.shadowOffset = CGSizeMake(1, 2);
        _popContentView.layer.cornerRadius = 4;
        [_popContentView setHidden:YES];
    }
    return self;
}

#pragma mark - Draw

// Draw Template
- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  CGContextRef contextRef = UIGraphicsGetCurrentContext();
  [self cleanPreDrawLayerAndData];
  [self strokeAuxiliaryLineInContext:contextRef];
  [self strokeLineChart];
  [self strokePointInContext];
  [self strokeNumberLabels];
}

/// Stroke Auxiliary
- (void)strokeAuxiliaryLineInContext:(CGContextRef)context {
  if (self.configuration.isShowAuxiliaryDashLine) {
    CGContextSetStrokeColorWithColor(context, self.configuration.auxiliaryDashLineColor.CGColor);
    CGContextSaveGState(context);
    CGFloat lengths[2] = {5.0, 5.0};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextSetLineWidth(context, 0.2);
    for (int i = 0; i < 11; i++) {
      CGContextMoveToPoint(
                           context, 5, self.frame.size.height - (self.frame.size.height) / 11 * i);
      CGContextAddLineToPoint(
                              context, self.frame.size.width,
                              self.frame.size.height - ((self.frame.size.height) / 11) * i);
      CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, self.configuration.auxiliaryDashLineColor.CGColor);
  }

  
  if (self.configuration.isShowCoordinate) {
    // ordinate
    CGContextMoveToPoint(context, 5, 0);
    CGContextAddLineToPoint(context, 5, self.frame.size.height);
    CGContextStrokePath(context);
    
    // abscissa
    CGContextMoveToPoint(context, 5, self.frame.size.height);
    CGContextAddLineToPoint(context, self.frame.size.width,
                            self.frame.size.height);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    // arrow
    UIBezierPath* arrow = [[UIBezierPath alloc] init];
    arrow.lineWidth = 0.7;
    [arrow moveToPoint:CGPointMake(0, 8)];
    [arrow addLineToPoint:CGPointMake(5, 0)];
    [arrow moveToPoint:CGPointMake(5, 0)];
    [arrow addLineToPoint:CGPointMake(10, 8)];
    [[UIColor black75PercentColor] setStroke];
    arrow.lineCapStyle = kCGLineCapRound;
    [arrow stroke];
  }
}

- (void)cleanPreDrawLayerAndData {
  [self.coverLayer removeFromSuperlayer];
  [self.shapeLayerArray
      enumerateObjectsUsingBlock:^(CAShapeLayer* _Nonnull obj, NSUInteger idx,
                                   BOOL* _Nonnull stop) {
        [obj removeFromSuperlayer];
      }];

  [self.numberLabelDecoration removeNumberLabels];
  
  [self.pointLayerArray enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [obj removeFromSuperlayer];
  }];

  [self.pointsArrays removeAllObjects];
  [self.shapeLayerArray removeAllObjects];
  [self.pointLayerArray removeAllObjects];
}

/// Stroke Point
- (void)strokePointInContext {
  
  if (self.configuration.isShowPoint) {
    self.pointsArrays = [self getPointsArrays];
    [self.pointsArrays enumerateObjectsUsingBlock:^(NSMutableArray* _Nonnull obj,
                                                    NSUInteger idx,
                                                    BOOL* _Nonnull stop) {
      
      UIColor *color = self.dataItemArray[idx].color;
      
      [obj enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx,
                                        BOOL* _Nonnull stop) {
        NSValue* pointValue = obj;
        CGPoint point = pointValue.CGPointValue;
        /// Change To CALayer
        CAShapeLayer* pointLayer = [CAShapeLayer pointLayerWithDiameter:PointDiameter color:color center:point];
        
        [self.pointLayerArray addObject:pointLayer];
        [self.layer addSublayer:pointLayer];
        
      }];
    }];
  }

}

/// Stroke Line
- (void)strokeLineChart {
  self.pointsArrays = [self getPointsArrays];
  [self.pointsArrays enumerateObjectsUsingBlock:^(NSMutableArray* _Nonnull obj,
                                                  NSUInteger idx,
                                                  BOOL* _Nonnull stop) {

    [self.shapeLayerArray
          addObject:[self lineShapeLayerWithPoints:obj
                                            colors:self.dataItemArray[idx].color
                                          lineMode:self.configuration.lineMode]];
  }];

  [self.shapeLayerArray
      enumerateObjectsUsingBlock:^(CAShapeLayer* _Nonnull obj, NSUInteger idx,
                                   BOOL* _Nonnull stop) {
        [self.layer addSublayer:obj];
      }];
}


// 绘制number label
- (void)strokeNumberLabels {
  if (!self.configuration.isEnableNumberLabel) {
    return;
  }
  
  for (int i = 0; i < self.pointsArrays.count; i++) {
    [self.numberLabelDecoration drawWithPoints:self.pointsArrays[i] TextNumbers:self.dataItemArray[i].numberArray isEnableAnimation:self.configuration.isEnableNumberAnimation];
  }
}

// compute Points Arrays
- (NSMutableArray<NSMutableArray<NSValue*>*>*)getPointsArrays {
    // 避免重复计算
    if (self.pointsArrays.count > 0) {
        return self.pointsArrays;
    } else {
        NSMutableArray* pointsArrays = [NSMutableArray new];
        // Get Points
        [self.dataItemArray
         enumerateObjectsUsingBlock:^(
                                      XLineChartItem* _Nonnull obj, NSUInteger idx,
                                      BOOL* _Nonnull stop) {
                                          NSMutableArray* numberArray = obj.numberArray;
                                          NSMutableArray* linePointArray = [NSMutableArray new];
                                          [obj.numberArray enumerateObjectsUsingBlock:^(NSNumber* _Nonnull obj,
                                                                                        NSUInteger idx,
                                                                                        BOOL* _Nonnull stop) {
                                              CGPoint point = [self calculateDrawablePointWithNumber:obj
                                                                                                 idx:idx
                                                                                               count:numberArray.count
                                                                                              bounds:self.bounds];
                                              NSValue* pointValue = [NSValue valueWithCGPoint:point];
                                              [linePointArray addObject:pointValue];
                                          }];
                                          [pointsArrays addObject:linePointArray];
                                      }];
        return pointsArrays;
    }
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

- (CAShapeLayer*)lineShapeLayerWithPoints:
                     (NSMutableArray<NSValue*>*)pointsValueArray
                                   colors:(UIColor*)color
                                 lineMode:(XLineMode)lineMode {
  UIBezierPath* line = [[UIBezierPath alloc] init];

  CAShapeLayer* chartLine = [CAShapeLayer layer];
  chartLine.lineCap = kCALineCapRound;
  chartLine.lineJoin = kCALineJoinRound;
  chartLine.lineWidth = LineWidth;

  for (int i = 0; i < pointsValueArray.count - 1; i++) {
    CGPoint point1 = pointsValueArray[i].CGPointValue;

    CGPoint point2 = pointsValueArray[i + 1].CGPointValue;
    [line moveToPoint:point1];

    if (lineMode == Straight) {
      [line addLineToPoint:point2];
    } else if (lineMode == CurveLine) {
      CGPoint midPoint = [[XAuxiliaryCalculationHelper shareCalculationHelper]
          midPointBetweenPoint1:point1
                      andPoint2:point2];
      [line addQuadCurveToPoint:midPoint
                   controlPoint:[[XAuxiliaryCalculationHelper
                                    shareCalculationHelper]
                                    controlPointBetweenPoint1:midPoint
                                                    andPoint2:point1]];
      [line addQuadCurveToPoint:point2
                   controlPoint:[[XAuxiliaryCalculationHelper
                                    shareCalculationHelper]
                                    controlPointBetweenPoint1:midPoint
                                                    andPoint2:point2]];
    } else {
      [line addLineToPoint:point2];
    }

    //当前线段的四个点
    CGPoint rectPoint1 =
        CGPointMake(point1.x - LineWidth / 2, point1.y - LineWidth / 2);
    NSValue* value1 = [NSValue valueWithCGPoint:rectPoint1];
    CGPoint rectPoint2 =
        CGPointMake(point1.x - LineWidth / 2, point1.y + LineWidth / 2);
    NSValue* value2 = [NSValue valueWithCGPoint:rectPoint2];
    CGPoint rectPoint3 =
        CGPointMake(point2.x + LineWidth / 2, point2.y - LineWidth / 2);
    NSValue* value3 = [NSValue valueWithCGPoint:rectPoint3];
    CGPoint rectPoint4 =
        CGPointMake(point2.x + LineWidth / 2, point2.y + LineWidth / 2);
    NSValue* value4 = [NSValue valueWithCGPoint:rectPoint4];

    //当前线段的矩形组成点
    NSMutableArray<NSValue*>* segementPointsArray = [NSMutableArray new];
    [segementPointsArray addObject:value1];
    [segementPointsArray addObject:value2];
    [segementPointsArray addObject:value3];
    [segementPointsArray addObject:value4];

    //把当前线段的矩形组成点数组添加到 数组中
    if (chartLine.segementPointsArrays == nil) {
      chartLine.segementPointsArrays = [[NSMutableArray alloc] init];
      [chartLine.segementPointsArrays addObject:segementPointsArray];
    } else {
      [chartLine.segementPointsArrays addObject:segementPointsArray];
    }
  }

  chartLine.path = line.CGPath;
  chartLine.strokeStart = 0.0;
  chartLine.strokeEnd = 1.0;
  chartLine.opacity = 0.6;
  chartLine.strokeColor = color.CGColor;
  chartLine.fillColor = [UIColor clearColor].CGColor;
  
  
  if (self.configuration.isShowShadow) {
    // shadow
    chartLine.shadowColor = [UIColor blackColor].CGColor;
    chartLine.shadowOpacity = 0.45f;
    chartLine.shadowOffset = CGSizeMake(0.0f, 6.0f);
    chartLine.shadowRadius = 5.0f;
    chartLine.masksToBounds = NO;
  } else {
    [chartLine addAnimation:self.pathAnimation forKey:@"strokeEndAnimation"];
  }
  
  // selectedStatus
  chartLine.selectStatusNumber = [NSNumber numberWithBool:NO];

  return chartLine;
}

- (CAShapeLayer*)coverShapeLayerWithPath:(CGPathRef)path color:(UIColor*)color {
  CAShapeLayer* chartLine = [CAShapeLayer layer];
  chartLine.lineCap = kCALineCapRound;
  chartLine.lineJoin = kCALineJoinRound;
  chartLine.lineWidth = LineWidth * 1.5;
  chartLine.path = path;
  chartLine.strokeStart = 0.0;
  chartLine.strokeEnd = 1.0;
  chartLine.strokeColor = color.CGColor;
  chartLine.fillColor = [UIColor clearColor].CGColor;
  chartLine.opacity = 0.8;

  return chartLine;
}

- (CABasicAnimation*)pathAnimation {
  _pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
  _pathAnimation.duration = 3.0;
  _pathAnimation.timingFunction = [CAMediaTimingFunction
      functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  _pathAnimation.fromValue = @0.0f;
  _pathAnimation.toValue = @1.0f;
  return _pathAnimation;
}

#pragma mark - Touch
- (void)removePreHiglightDraw {
  [self.numberLabelDecoration removeNumberLabels];
  [self.coverLayer removeFromSuperlayer];
}

- (void)findXIdx:(int *)areaIdx point:(const CGPoint *)point {
  NSArray<NSValue*>* points = self.pointsArrays.lastObject;
  for (int i = 0; i < points.count - 1; i++) {
    if (point->x >= points[i].CGPointValue.x &&
        point->x <= points[i + 1].CGPointValue.x) {
      *areaIdx = i;
    }
  }
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event {
  
    if (self.configuration.isEnableTouchShowNumberLabel) {
        static bool flag = true;
        if (flag) {
            //遍历每一条线时，只判断在 areaIdx 的 线段 是否包含 该点
            [self.shapeLayerArray
             enumerateObjectsUsingBlock:^(
                                          CAShapeLayer* _Nonnull obj, NSUInteger idx,
                                          BOOL* _Nonnull stop) {
                                              [self.numberLabelDecoration drawWithPoints:self.pointsArrays[idx] TextNumbers:self.dataItemArray[idx].numberArray isEnableAnimation:self.configuration.isEnableNumberAnimation];
                                          }];
        } else {
            [self.numberLabelDecoration removeNumberLabels];
        }
        flag = !flag;
        return ;
    }
  
    if (self.configuration.isEnableNumberLabel) {
        return;
    }
    //根据 点击的x坐标 只找在x 坐标区域内的 线段进行判断
    //坐标系转换
    CGPoint __block point = [[touches anyObject] locationInView:self];
    NSArray<NSValue*>* points = self.pointsArrays.firstObject;
    /// 找到点击了哪个点
    NSInteger resultIndex = -1;
    for (int i = 0; i < points.count; i++) {
        CGPoint center = points[i].CGPointValue;
        CGFloat r = PointDiameter+2;
        CGRect currentRect = CGRectMake(center.x-r, center.y-r, r*2, r*2);
        if (CGRectContainsPoint(currentRect, point)) {
            resultIndex = i;
            NSLog(@"点击了%d--%@",i,self.dataItemArray.firstObject.dataArray[i].avgNetFtPrice);
            
        }
    }
    
    [self.popContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    if (resultIndex >= 0 && resultIndex < self.dataItemArray.firstObject.dataArray.count) {
        [self bringSubviewToFront:self.popContentView];
        [self.popContentView setHidden:NO];
        [self creatPopViewWithPrice:self.dataItemArray.firstObject.dataArray[resultIndex].avgNetFtPrice date:self.dataItemArray.firstObject.dataArray[resultIndex].monthlyDate clickPoint:self.pointsArrays.firstObject[resultIndex].CGPointValue];
    } else {
        [self.popContentView setHidden:YES];
    }
}

- (XNormalLineChartConfiguration *)configuration {
  if (_configuration == nil) {
    _configuration = [[XNormalLineChartConfiguration alloc] init];
  }
  return _configuration;
}

- (void)creatPopViewWithPrice:(NSString *)price date:(NSString *)date clickPoint:(CGPoint)point {
    
    NSDateFormatter *stringformatter = [[NSDateFormatter alloc] init];
    [stringformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM/yyyy"];
    
    NSDate *dateTemp = [stringformatter dateFromString:date];
    NSString *desc = [dateformatter stringFromDate:dateTemp];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = kFontSize6(9);
    dateLabel.text = desc;
    dateLabel.textColor = HEX_RGB(0x444444);
    dateLabel.numberOfLines = 0;
    dateLabel.textAlignment = NSTextAlignmentLeft;
    [_popContentView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_popContentView).offset(8.5);
        make.left.equalTo(_popContentView).offset(5);
        make.right.equalTo(_popContentView).offset(-5);
    }];
    
    UIView *circleView = [UIView new];
    circleView.backgroundColor = HEX_RGB(0xD8BA84);
    circleView.layer.cornerRadius = 3.5;
    [_popContentView addSubview:circleView];
    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_popContentView).offset(5);
        make.size.equalTo(@7);
        make.top.equalTo(dateLabel.mas_bottom).offset(9);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.font = kFontSize6(9);
    priceLabel.text = [NSString stringWithFormat:@"呎价：$%@",price];
    priceLabel.textColor = HEX_RGB(0x444444);
    [_popContentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(circleView);
        make.right.equalTo(_popContentView).offset(-5);
        make.bottom.equalTo(_popContentView).offset(-9);
        make.left.equalTo(circleView.mas_right).offset(6);
    }];
    [_popContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@45);
        if (point.y + 45 > self.height ) {
            make.bottom.equalTo(self).inset(self.height - point.y - 4);
        } else {
            make.top.equalTo(self).inset(point.y + 4);
        }
        if (point.x + 100 > self.width ) {
            make.right.equalTo(self).inset(self.width - point.x);
        } else {
            make.left.equalTo(self).inset(point.x);
        }
    }];
}


@end
