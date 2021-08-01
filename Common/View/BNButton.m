//
//  BNButton.m
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import "BNButton.h"

@implementation BNButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (!UIEdgeInsetsEqualToEdgeInsets(self.touchInsets, UIEdgeInsetsZero)) {
        CGRect responsibleRect = CGRectMake(-self.touchInsets.left,
                                            -self.touchInsets.top,
                                            self.frame.size.width + self.touchInsets.left + self.touchInsets.right,
                                            self.frame.size.height + self.touchInsets.top + self.touchInsets.bottom);
        return CGRectContainsPoint(responsibleRect, point);
    }
    if (_autoExpandHitArea) {
        self.expandHitWidth = MAX(NORMAL_HOTAREA_WIDTH - self.frame.size.width, _expandHitWidth);
        self.expandHitHeight = MAX(NORMAL_HOTAREA_HEIGHT - self.frame.size.height, _expandHitHeight);
    }
    CGRect bounds = CGRectInset(self.bounds, -0.5 * self.expandHitWidth, -0.5 * self.expandHitHeight);
    return CGRectContainsPoint(bounds, point);
}

- (void)setNormalImage:(UIImage *)normal selectedImage:(UIImage *)selected {
    [self setImage:normal forState:UIControlStateNormal];
    [self setImage:selected forState:UIControlStateSelected];
    [self setImage:normal forState:UIControlStateNormal | UIControlStateHighlighted];
    [self setImage:selected forState:UIControlStateSelected | UIControlStateHighlighted];
}

@end
