//
//  FYLRatioView.m
//  仿-支付宝资金比例动画
//
//  Created by FuYunLei on 2017/4/18.
//  Copyright © 2017年 FuYunLei. All rights reserved.
//

#import "FYLRatioView.h"


//是否使用默认颜色 1:使用  2:不使用(代码70行)
#define kUseDefaultColor 0

@interface FYLRatioView ()<CAAnimationDelegate>

@property(nonatomic,assign)CGFloat startAngle;//动画开始的角度
@property(nonatomic,assign)CGFloat endAngle;//动画结束的角度
@property(nonatomic,assign)NSInteger index;//当前的动画

@property(nonatomic,strong)NSArray *numbers;//金额数组
@property(nonatomic,assign)CGFloat total;//总金额
@property(nonatomic,strong)NSArray *titles;//标题数组
@property(nonatomic,strong)NSMutableArray *colors;//颜色数组

@end

@implementation FYLRatioView

///初始化
- (FYLRatioView *)initWithNumbers:(NSArray *)numbers andTitles:(NSArray *)titles{
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.startAngle = -M_PI_2;
        self.endAngle = 0;
        self.index = 0;
        self.numbers = numbers;
        self.titles = titles;
        self.colors = [NSMutableArray arrayWithArray:@[[UIColor orangeColor],
                                                       [UIColor redColor],
                                                       [UIColor greenColor],
                                                       [UIColor purpleColor],
                                                       [UIColor blueColor],
                                                       [UIColor yellowColor]]];
        self.total = [self getTotal];
        //对齐5个字以内的全中文title
        [self handleTitles];
    }
    return self;
}
//布局子控件
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    //布局左边信息面板
    CGFloat height = frame.size.height/self.titles.count;
    for (int i = 0; i<self.titles.count; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, i*height, 160, height)];
        [self addSubview:view];
        
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, height/2 - 5, 10, 10)];
        //自定义color
        UIColor *color = [UIColor colorWithRed:1-255*i/self.titles.count/255.f green:255*i/self.titles.count/255.f blue:25/255.f alpha:1.0];
        [self.colors addObject:color];
        
        colorView.backgroundColor = self.colors[i + (kUseDefaultColor==1?0:6)];
        [view addSubview:colorView];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 145, height)];
        label.textColor = self.colors[i + (kUseDefaultColor==1?0:6)];
        label.text = [NSString stringWithFormat:@"%@: %@",self.titles[i],self.numbers[i]];
        [view addSubview:label];
    }
    
}
//绘图
- (void)drawRect:(CGRect)rect {
    [self.layer removeAllAnimations];
    [self startAnimation];
}
- (void)startAnimation{
    if (self.index >= self.numbers.count) {
        self.index = 0;
        return;
    }
        CGFloat lineWidth = 30;

        UIBezierPath *path = [UIBezierPath bezierPath];
        CGPoint center = CGPointMake(self.bounds.size.width - 100, CGRectGetMidY(self.bounds));
        CGFloat radius = 50;
        
        CGFloat n = [self.numbers[self.index] floatValue];
        CGFloat angle = 2*M_PI*n/self.total;
        self.endAngle = self.startAngle + angle;
        [path addArcWithCenter:center radius:radius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
        self.startAngle = self.endAngle;
        
        CAShapeLayer *layerAnimation = [CAShapeLayer layer];
        layerAnimation.path = path.CGPath;
        layerAnimation.strokeColor = [self.colors[self.index + (kUseDefaultColor==1?0:6)] CGColor];
        layerAnimation.lineWidth = lineWidth;
        layerAnimation.frame = self.bounds;
        layerAnimation.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:layerAnimation];
        [self drawArcAnimation:layerAnimation withDuration:2 * n /self.total];

}
- (void)drawArcAnimation:(CALayer*)layer withDuration:(CGFloat)duration{
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.delegate = self;
    bas.duration = duration;
    bas.fromValue = @0;
    bas.toValue = @1;
    [layer addAnimation:bas forKey:@"arcAnimation"];
}
#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    self.index++;
    [self startAnimation];
    
}
#pragma mark - tool
- (void)handleTitles{
    
    NSInteger legthMax = 0;
    
    for (NSString *title in self.titles) {
        
        if (title.length > legthMax) {
            legthMax = title.length;
        }
    }
    if (legthMax>5) {
        return;
    }
    NSMutableArray *newTitles = [NSMutableArray array];
    for (NSString *title in self.titles) {
        
        NSInteger spaceCount = (legthMax == 5?5:3 - title.length)*4;
        if (spaceCount != 0) {
            NSMutableString *newTitle = [NSMutableString string];
            switch (title.length) {
                case 1:
                {
                    for (int i = 0; i < spaceCount + 1; i++) {
                        if (i == spaceCount/2) {
                            [newTitle appendString:title];
                            continue;
                        }
                        [newTitle appendString:@" "];
                    }
                }
                    break;
                case 2:
                {
                    for (int i = 0; i < spaceCount + 2; i++) {
                        if (i == 0) {
                            [newTitle appendString:[title substringWithRange:NSMakeRange(0, 1)]];
                            continue;
                        }
                        if (i == spaceCount + 1) {
                            [newTitle appendString:[title substringWithRange:NSMakeRange(1, 1)]];
                            continue;
                        }
                        [newTitle appendString:@" "];
                    }
                }
                    break;
                case 3:
                {
                    for (int i = 0; i < spaceCount + 3; i++) {
                        if (i == 0) {
                            [newTitle appendString:[title substringWithRange:NSMakeRange(0, 1)]];
                            continue;
                        }
                        if (i == spaceCount/2 + 1) {
                            [newTitle appendString:[title substringWithRange:NSMakeRange(1, 1)]];
                            continue;
                        }
                        if (i == spaceCount + 2) {
                            [newTitle appendString:[title substringWithRange:NSMakeRange(2, 1)]];
                            continue;
                        }
                        [newTitle appendString:@" "];
                    }
                }
                    break;
                case 4:
                {
                    for (int i = 0; i < spaceCount + 4; i++) {
                        if (i == 0) {
                            [newTitle appendString:[title substringWithRange:NSMakeRange(0, 1)]];
                            continue;
                        }
                        if (i == 2) {
                            [newTitle appendString:[title substringWithRange:NSMakeRange(1, 1)]];
                            continue;
                        }
                        if (i == 4) {
                            [newTitle appendString:[title substringWithRange:NSMakeRange(2, 1)]];
                            continue;
                        }
                        if (i == 7) {
                            [newTitle appendString:[title substringWithRange:NSMakeRange(2, 1)]];
                            continue;
                        }
                        [newTitle appendString:@" "];
                    }
                }
                    break;
 
                default:
                    break;
            }
            [newTitles addObject:newTitle];
        }else
        {
            [newTitles addObject:title];
        }
    }
 
    
    self.titles = [NSArray arrayWithArray:newTitles];
}

///获取总金额
- (CGFloat)getTotal{
    CGFloat sum = 0;
    for (NSNumber *num in _numbers) {
        sum += [num floatValue];
    }
    return sum;
}

@end
