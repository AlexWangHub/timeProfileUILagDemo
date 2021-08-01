//
//  BNCommonPanelView.h
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import <UIKit/UIKit.h>

@class BNCommonPanelViewInfo;

typedef NS_ENUM(NSUInteger, BNCommonPanelViewLevel) {
    BNCommonPanelViewLevelDefault = 0, ///< 占位
    BNCommonPanelViewLevelScroll = 1, ///< scrollView 卡顿 Demo
    BNCommonPanelViewLevelTableView = 2, ///< tableView 卡顿 Demo
};

NS_ASSUME_NONNULL_BEGIN

@protocol BNCommonPanelViewDelegate <NSObject>

@required
- (void)onClickPanelViewWithLevel:(BNCommonPanelViewLevel)level info:(NSObject *)info;
- (void)panelViewHeightChanged; // panelView 的高度发生变更了

@end

@interface BNCommonPanelView : UIView

@property (nonatomic, weak) id<BNCommonPanelViewDelegate> delegate;

- (instancetype)init DISPATCH_UNAVAILABLE_MSG("Use initWithFrame:");
+ (instancetype)new DISPATCH_UNAVAILABLE_MSG("Use initWithFrame:");

- (void)updateWithInfoArray:(NSArray<BNCommonPanelViewInfo *> *)infoArray;

@end

NS_ASSUME_NONNULL_END
