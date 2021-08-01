//
//  BNCommonPanelView.m
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import "BNCommonPanelView.h"
#import "BNCommonPanelViewInfo.h"

@interface BNCommonPanelView ()
@property (nonatomic, strong) NSArray<BNCommonPanelViewInfo *> *infoArray;
@end

@implementation BNCommonPanelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)updateWithInfoArray:(NSArray<BNCommonPanelViewInfo *> *)infoArray {
    _infoArray = infoArray;
    [self _updatePanelViewWithInfoArray:infoArray];
}

- (void)_updatePanelViewWithInfoArray:(NSArray<BNCommonPanelViewInfo *> *)infoArray {
    [self ]
}

@end
