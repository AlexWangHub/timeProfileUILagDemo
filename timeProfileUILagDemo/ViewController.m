//
//  ViewController.m
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import "ViewController.h"
#import "BNCommonPanelView.h"
#import "UIView+Extend.h"
#import "BNCommonPanelViewInfo.h"
#import "BNDataDefine.h"
#import "BNScrollViewViewController.h"
#import "BNTableViewViewController.h"

#define BNPanelViewLeftRightMargin 12

@interface ViewController ()<BNCommonPanelViewDelegate>

@property (nonatomic,strong) BNCommonPanelView *panelView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.panelView];
    [self.panelView updateWithInfoArray:[self _getPanelInfoArray]];
}

- (NSArray<BNCommonPanelViewInfo *> *)_getPanelInfoArray {
    NSMutableArray *infoArray = [NSMutableArray array];
    
    BNCommonPanelViewInfo *scrollInfo = [[BNCommonPanelViewInfo alloc] init];
    scrollInfo.level = BNCommonPanelViewLevelScroll;
    
    BNCommonPanelViewInfo *tableViewInfo = [[BNCommonPanelViewInfo alloc] init];
    tableViewInfo.level = BNCommonPanelViewLevelTableView;
    
    [infoArray addObject:scrollInfo];
    [infoArray addObject:tableViewInfo];
    
    return [infoArray mutableCopy];
}

- (BNCommonPanelView *)panelView {
    if (!_panelView) {
        _panelView = [[BNCommonPanelView alloc] initWithFrame:CGRectMake(BNPanelViewLeftRightMargin, 120, self.view.width - 2 * BNPanelViewLeftRightMargin, self.view.height)];
        _panelView.delegate = self;
    }
    return _panelView;
}

#pragma mark - BNCommonPanelViewDelegate
- (void)onClickBusinessViewWithInfo:(BNCommonPanelViewInfo *)info {
    NSLog(@"ViewController onClickBusinessViewWithInfo level:%lu",(unsigned long)info.level);
    switch (info.level) {
        case BNCommonPanelViewLevelScroll: {
            BNScrollViewViewController *scrollVC = [[BNScrollViewViewController alloc] init];
            scrollVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:scrollVC animated:YES completion:nil];
        }
            break;
        case BNCommonPanelViewLevelTableView: {
            BNTableViewViewController *tableViewVC = [[BNTableViewViewController alloc] init];
            tableViewVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:tableViewVC animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

@end
