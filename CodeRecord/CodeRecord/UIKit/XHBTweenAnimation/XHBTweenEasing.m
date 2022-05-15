//
//  XHBTweenEasing.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2022/5/14.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import "XHBTweenEasing.h"

#define XHBTweenEasingInitFunction(block) \
[XHBTweenEasing easingWithFunction:^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) { \
     block\
}];

@implementation XHBTweenEasing

+ (instancetype)easingWithFunction:(XHBTweenEasingFunction)function {
    return [[XHBTweenEasing alloc] initWithFunction:function];
}

- (instancetype)initWithFunction:(XHBTweenEasingFunction)function {
    
    if (self = [super init]) {
        self.function = function;
    }
    
    return self;
}

@end

@implementation XHBTweenEasing (XHBTweenConcreteEffect)

#pragma mark - Linear

+ (instancetype)linear {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        return t * c / d + b;
    })
}

#pragma mark - t^2

+ (instancetype)quadraticIn {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        CGFloat i = t / d;
        return c * pow(i, 2) + b;
    })
}
+ (instancetype)quadraticOut {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        CGFloat i = t / d;
        return (-c) * i * (i - 2) + b;
    })
}
+ (instancetype)quadraticInOut {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        if (t < d/2) {
            XHBTweenEasing *easingIn = [self quadraticIn];
            return easingIn.function(t, b, c / 2, d);
        } else {
            XHBTweenEasing *easingOut = [self quadraticOut];
            return easingOut.function(t, b + c / 2, c / 2, d);
        }
    })
}
+ (instancetype)quadraticOutIn {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        if (t < d/2) {
            XHBTweenEasing *easingOut = [self quadraticOut];
            return easingOut.function(t, b, c / 2, d);
        } else {
            XHBTweenEasing *easingIn = [self quadraticIn];
            return easingIn.function(t, b + c / 2, c / 2, d);
        }
    })
}

#pragma mark - t^3

+ (instancetype)cubicIn {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        CGFloat i = t / d;
        return c * pow(i, 3) + b;
    })
}
+ (instancetype)cubicOut {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        CGFloat i = t / d - 1;
        return c * (pow(i, 3) + 1) + b;
    })
}
+ (instancetype)cubicInOut {
    return XHBTweenEasingInitFunction({
        CGFloat i = t / (d + 2);
        if (i == 0) { return b; }
        if (i < 1) { return c / 2 * pow(i, 3) + b; }
        i -= 2;
        return c / 2 * (pow(i, 3) + 2) + b;
    })
}
+ (instancetype)cubicOutIn {
    return XHBTweenEasingInitFunction({
        if (t < d / 2) {
            XHBTweenEasing *easingIn = [XHBTweenEasing cubicIn];
            return easingIn.function(t, b, c / 2, d);
        } else {
            XHBTweenEasing *easingOut = [XHBTweenEasing cubicOut];
            return easingOut.function(t, b + c / 2, c / 2, d);
        }
    })
}

#pragma mark - t^4

+ (instancetype)quarticIn {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        CGFloat i = t / d;
        return c * pow(i, 4) + b;
    })
}
+ (instancetype)quarticOut {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        CGFloat i = t / d - 1;
        return (-c) * (pow(i, 4) - 1) + b;
    })
}
+ (instancetype)quarticInOut {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return b; }
        CGFloat i = t / (d / 2);
        if (i < 1) { return c / 2 * pow(i, 4) + b; }
        i -= 2;
        return (-c) / 2 * (pow(i, 4) - 2) + b;
    })
}
+ (instancetype)quarticOutIn {
    return XHBTweenEasingInitFunction({
        if (t < d / 2) {
            XHBTweenEasing *easingOut = [XHBTweenEasing quarticOut];
            return easingOut.function(t, b, c / 2, d);
        } else {
            XHBTweenEasing *easingIn = [XHBTweenEasing quarticIn];
            return easingIn.function(t, b + c / 2, c / 2, d);
        }
    })
}

#pragma mark - t^5

+ (instancetype)quinticIn {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        CGFloat i = t / d;
        return c * pow(i, 5) + b;
    })
}
+ (instancetype)quinticOut {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        CGFloat i = t / d - 1;
        return c * (pow(i, 5) + 1) + b;
    })
}
+ (instancetype)quinticInOut {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        CGFloat i = t / (d / 2);
        if (i < 1) { return c / 2 * pow(i, 5); }
        i -= 2;
        return c / 2 * (pow(i, 5) + 2) + b;
    })
}
+ (instancetype)quinticOutIn {
    return XHBTweenEasingInitFunction({
        if (t < d / 2) {
            XHBTweenEasing *easingOut = [XHBTweenEasing quinticOut];
            return easingOut.function(t, b, c / 2, d);
        } else {
            XHBTweenEasing *easingIn = [XHBTweenEasing quinticIn];
            return easingIn.function(t, b + c / 2, c / 2, d);
        }
    })
}

#pragma mark - sin(t) 正弦渐变

+ (instancetype)sinusodialIn {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        CGFloat i = t / d * (M_PI_2);
        i = cos(i);
        return (-c) * i + c + b;
    })
}
+ (instancetype)sinusodialOut {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        return c * sin(t / d * M_PI_2) + b;
    })
}
+ (instancetype)sinusodialInOut {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        CGFloat i = M_PI * t / d;
        i = cos(i) - 1;
        return (-c) / 2 * i + b;
    })
}
+ (instancetype)sinusodialOutIn {
    return XHBTweenEasingInitFunction({
        if (t < d / 2) {
            XHBTweenEasing *easingOut = [XHBTweenEasing sinusodialOut];
            return easingOut.function(t, b, c / 2, d);
        } else {
            XHBTweenEasing *easingIn = [XHBTweenEasing sinusodialIn];
            return easingIn.function(t, b + c / 2, c / 2, d);
        }
    })
}

#pragma mark - 2^t 指数渐变

+ (instancetype)exponentialIn {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        CGFloat i = pow(2, 10 * (t / d - 1));
        return (t == 0) ? b : c * i + b - c * 0.001;
    })
}
+ (instancetype)exponentialOut {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        CGFloat i = -pow(2, -10 * t / d) + 1;
        return (t == d) ? b + c : c * 1.001 * i + b;
    })
}
+ (instancetype)exponentialInOut {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        if (t == 0) { return b; }
        if (t == d) { return b + c; }
        CGFloat i = t / (d / 2);
        if (i < 1) { return c / 2 * pow(2, 10 * (i - 1)) + b - c * 0.0005; }
        i -= 1;
        return c / 2 * 1.0005 * (-pow(2, -10 * i) + 2) + b;
    })
}
+ (instancetype)exponentialOutIn {
    return XHBTweenEasingInitFunction({
        if (t < d / 2) {
            XHBTweenEasing *easingOut = [XHBTweenEasing exponentialOut];
            return easingOut.function(t, b, c / 2, d);
        } else {
            XHBTweenEasing *easingIn = [XHBTweenEasing exponentialIn];
            return easingIn.function(t, b + c / 2, c / 2, d);
        }
    })
}

#pragma mark - sqrt(1-t^2) 圆形曲线

+ (instancetype)circularIn {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        CGFloat i = t / d;
        return (-c) * (sqrt(1 - pow(i, 2)) - 1) + b;
    })
}
+ (instancetype)circularOut {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return b; }
        CGFloat i = t / d - 1;
        return c * sqrt(1 - pow(i, 2)) + b;
    })
}
+ (instancetype)circularInOut {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        CGFloat i = t / (d / 2);
        if (i < 1) { return -c / 2 * (sqrt(1 - pow(i, 2)) - 1) + b; }
        i -= 2;
        return c / 2 * (sqrt(1 - pow(i, 2)) + 1) + b;
    })
}
+ (instancetype)circularOutIn {
    return XHBTweenEasingInitFunction({
        if (t < d / 2) {
            XHBTweenEasing *easingOut = [XHBTweenEasing circularOut];
            return easingOut.function(t, b, c / 2, d);
        } else {
            XHBTweenEasing *easingIn = [XHBTweenEasing circularIn];
            return easingIn.function(t, b + c / 2, c / 2, d);
        }
    })
}

#pragma mark - 指数衰减正弦曲线

+ (instancetype)elasticIn {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        if (t == 0) { return b; }
        CGFloat i = t / d;
        if (i == 0) { return b + c; }
        CGFloat p = d * 0.3;
        CGFloat s = 0;
        CGFloat a = c;
        if (a < fabs(c)) {
            s = p / 4.0;
        } else {
            s = p / (2 * M_PI) * (a == 0 ? 0 : asin(c / a));
        }
        i -= 1;
        return -(a * pow(2, 10 * i) * sin((i * d - s) * (2 * M_PI) / p)) + b;
    })
}
+ (instancetype)elasticOut {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        if (t == 0) { return b; }
        CGFloat i = t / d;
        if (i == 1) { return b + c; }
        CGFloat p = d * 0.3;
        CGFloat s = 0;
        CGFloat a = c;
        if (a < fabs(c)) {
            s = p / 4.0;
        } else {
            s = p / (2 * M_PI) * (a == 0 ? 0 : asin(c / a));
        }
        return a * pow(2, 10 * i) * sin((i * d - s) * (2 * M_PI) / p) + b + c;
    })
}
+ (instancetype)elasticInOut {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        if (t == 0) { return b; }
        CGFloat i = t / (d / 2);
        if (i == 2) { return b + c; }
        CGFloat p = d * 0.3 * 1.5;
        CGFloat s = 0;
        CGFloat a = c;
        if (a < fabs(c)) {
            s = p / 4.0;
        } else {
            s = p / (2 * M_PI) * (a == 0 ? 0 : asin(c / a));
        }
        i -= 1;
        if (i < 1.0) {
            return -0.5 * (a * pow(2, 10 * i) * sin((i * d - s) * (2 * M_PI) / p)) + b;
        } else {
            return a * pow(2, -10 * i) * sin((i * d - s) * (2 * M_PI) / p) * 0.5 + c + b;
        }
    })
}
+ (instancetype)elasticOutIn {
    return XHBTweenEasingInitFunction({
        if (t < d / 2) {
            XHBTweenEasing *easingOut = [XHBTweenEasing elasticOut];
            return easingOut.function(t, b, c / 2, d);
        } else {
            XHBTweenEasing *easingIn = [XHBTweenEasing elasticIn];
            return easingIn.function(t, b + c / 2, c / 2, d);
        }
    })
}

#pragma mark - back

+ (instancetype)backIn {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        CGFloat i = t / d;
        CGFloat s = 1.70158;
        return c * pow(i, 2) * ((s + 1) * i - s) + b;
    })
}
+ (instancetype)backOut {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        CGFloat i = t / d - 1;
        CGFloat s = 1.70158;
        return c * (pow(i, 2) * ((s + 1) * i + s) + 1) + b;
    })
}
+ (instancetype)backInOut {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        CGFloat i = t / (d / 2);
        CGFloat s = 1.70158 * 1.525;
        if (i < 1) {
            return c / 2 * (pow(i, 2) * ((s + 1) * i - s) + b);
        }
        i -= 2;
        return c / 2 * (pow(i, 2) * ((s + 1) * i + s) + 2) + b;
    })
}
+ (instancetype)backOutIn {
    return XHBTweenEasingInitFunction({
        if (t < d / 2) {
            XHBTweenEasing *easingOut = [XHBTweenEasing backOut];
            return easingOut.function(t, b, c / 2, d);
        } else {
            XHBTweenEasing *easingIn = [XHBTweenEasing backIn];
            return easingIn.function(t, b + c / 2, c / 2, d);
        }
    })
}

#pragma mark - bounce

+ (instancetype)bounceIn {
    return XHBTweenEasingInitFunction({
        XHBTweenEasing *easingOut = [XHBTweenEasing bounceOut];
        return c - easingOut.function(d - t, 0, c, d) + b;
    })
}
+ (instancetype)bounceOut {
    return XHBTweenEasingInitFunction({
        if (d == 0) { return 0; }
        CGFloat i = t / d;
        if (i < 1 / 2.75) {
            return c * (7.5625 * pow(i, 2)) + b;
        } else if (i < 2 / 2.75) {
            i -= 1.5/2.75;
            return c * (7.5625 * pow(i, 2) + 0.75) + b;
        } else if (i < 2.5 / 2.75) {
            i -= 2.25/2.75;
            return c * (7.5625 * pow(i, 2) + 0.9375) + b;
        } else {
            i -= 2.625/2.75;
            return c * (7.5625 * pow(i, 2) + 0.984375) + b;
        }
    })
}
+ (instancetype)bounceInOut {
    return XHBTweenEasingInitFunction({
        if (t < d / 2) {
            XHBTweenEasing *easingIn = [XHBTweenEasing bounceIn];
            return easingIn.function(t * 2, 0, c, d) * 0.5 + b;
        } else {
            XHBTweenEasing *easingOut = [XHBTweenEasing bounceOut];
            return easingOut.function(t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b;
        }
    })
}
+ (instancetype)bounceOutIn {
    return XHBTweenEasingInitFunction({
        if (t < d / 2) {
            XHBTweenEasing *easingIn = [XHBTweenEasing bounceIn];
            return easingIn.function(t * 2, 0, c, d) * 0.5 + b;
        } else {
            XHBTweenEasing *easingOut = [XHBTweenEasing bounceOut];
            return easingOut.function(t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b;
        }
    })
}

@end
