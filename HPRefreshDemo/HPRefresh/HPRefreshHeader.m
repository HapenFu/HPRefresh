//
//  HPRefreshHeader.m
//  HPRefreshDemo
//
//  Created by 付海鹏 on 2016/10/24.
//  Copyright © 2016年 Haipeng. All rights reserved.
//

#import "HPRefreshHeader.h"
#import "UIView+HPRefresh.h"
#import "UIColor+HPRefresh.h"

static const CGFloat HPRefreshHeaderHeight = 35.f;
static const CGFloat HPRefreshHeaderRadio = 5.f;
static const CGFloat HPRefreshPullLen     = 55.f;
static const CGFloat HPRefreshTranslatLen = 5.f;

@interface HPRefreshHeader ()

@property (nonatomic, strong) CAShapeLayer *topPointLayer;
@property (nonatomic, strong) CAShapeLayer *leftPointLayer;
@property (nonatomic, strong) CAShapeLayer *bottomPointLayer;
@property (nonatomic, strong) CAShapeLayer *rightPointLayer;

@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL animating;

@end

@implementation HPRefreshHeader

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, HPRefreshHeaderHeight, HPRefreshHeaderHeight)];
    if (self) {
        [self initLayers];
    }
    return self;
}

#pragma mark - Iniatial

- (void)initLayers {
    CGFloat headerCenterY = HPRefreshHeaderHeight / 2;
    
    CGPoint topPoint = CGPointMake(headerCenterY, HPRefreshHeaderRadio);
    self.topPointLayer = [self layerWithCenter:topPoint color:[UIColor topPointColor]];
    self.topPointLayer.hidden = NO;
    self.topPointLayer.opacity = 0.f;
    [self.layer addSublayer:self.topPointLayer];
    
    CGPoint leftPoint = CGPointMake(HPRefreshHeaderRadio, headerCenterY);
    self.leftPointLayer = [self layerWithCenter:leftPoint color:[UIColor leftPointColor]];
    [self.layer addSublayer:self.leftPointLayer];
    
    CGPoint bottomPoint = CGPointMake(headerCenterY, HPRefreshHeaderHeight - HPRefreshHeaderRadio);
    self.bottomPointLayer = [self layerWithCenter:bottomPoint color:[UIColor bottomPointColor]];
    [self.layer addSublayer:self.bottomPointLayer];
    
    CGPoint rightPoint = CGPointMake(HPRefreshHeaderHeight - HPRefreshHeaderRadio, headerCenterY);
    self.rightPointLayer = [self layerWithCenter:rightPoint color:[UIColor rightPointColor]];
    [self.layer addSublayer:self.rightPointLayer];
    
    // 滑动条
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.frame = self.bounds;
    self.lineLayer.lineWidth = HPRefreshHeaderRadio * 2;
    self.lineLayer.lineCap = kCALineCapRound;
    self.lineLayer.lineJoin = kCALineJoinRound;
    self.lineLayer.fillColor = [UIColor topPointColor].CGColor;
    self.lineLayer.strokeColor = [UIColor topPointColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:topPoint];
    [path addLineToPoint:leftPoint];
    [path moveToPoint:leftPoint];
    [path addLineToPoint:bottomPoint];
    [path moveToPoint:bottomPoint];
    [path addLineToPoint:rightPoint];
    [path moveToPoint:rightPoint];
    [path addLineToPoint:topPoint];
    self.lineLayer.path = path.CGPath;
    self.lineLayer.strokeStart = 0.f;
    self.lineLayer.strokeEnd = 0.f;
    [self.layer insertSublayer:self.layer above:self.topPointLayer];
    
}

- (CAShapeLayer *)layerWithCenter:(CGPoint)center color:(UIColor *)color {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(center.x - HPRefreshHeaderRadio, center.y - HPRefreshHeaderRadio, HPRefreshHeaderRadio * 2, HPRefreshHeaderRadio * 2);
    layer.fillColor = color.CGColor;
    layer.path = [self pointPath];
    layer.hidden = YES;
    return layer;
}

- (CGPathRef)pointPath {
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(HPRefreshHeaderRadio, HPRefreshHeaderRadio) radius:HPRefreshHeaderRadio startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath;
}

#pragma mark - Override

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        self.scrollView = (UIScrollView *)newSuperview;
        self.center = CGPointMake(self.scrollView.centerX, self.centerY);
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    } else {
        [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        self.progress = - self.scrollView.contentOffset.y;
    }
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    if (!self.animating) {
        if (progress >= HPRefreshPullLen) {
            self.y = - (HPRefreshPullLen - (HPRefreshPullLen - HPRefreshHeaderHeight) / 2);
        } else {
            if (progress < self.height) {
                self.y = progress;
            } else {
                self.y = -(self.height - (progress - self.height) / 2);
            }
        }
        [self setLineLayerWithStrokeProgress:progress];
    }
    
    if (progress > HPRefreshPullLen && !self.animating && !self.scrollView.dragging) {
        // 开始动画
        [self startAnimation];
        if (self.handle) {
            self.handle();
        }
    }
}

#pragma mark - Adjustment

- (void)setLineLayerWithStrokeProgress:(CGFloat)progress {
    
}


#pragma mark - Animation

- (void)startAnimation {
    
}

- (void)addTranslationAnimationToLayer:(CALayer *)layer xValue:(CGFloat)xValue yValue:(CGFloat)yValue {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1.f;
    
    
}


@end
