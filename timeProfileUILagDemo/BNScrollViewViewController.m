//
//  BNScrollViewViewController.m
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import "BNScrollViewViewController.h"
#import "UIView+Extend.h"
#import "BNBuildHelper.h"
#import "BNToolHelper.h"

@interface BNScrollViewViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation BNScrollViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.view.height * 1.5);
    [self.view addSubview:self.scrollView];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 24)];
        label.textColor = [UIColor blackColor];
        [label setText:@"锚定文案"];
        [label sizeToFit];
        label.top = _scrollView.height / 2;
        label.left = (_scrollView.width - label.width) / 2;
        [_scrollView addSubview:label];
        
        self.closeButton.top = label.top - 54;
        self.closeButton.left = (_scrollView.width - self.closeButton.width) / 2;
        [_scrollView addSubview:self.closeButton];
    }
    return _scrollView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [BNBuildHelper buildButtonWithFrame:CGRectMake(0, 0, 132, 48) backgroundColor:[UIColor orangeColor] titleColor:[UIColor whiteColor] title:@"返回上一层" target:self action:@selector(onClickCloseAction) cornerRadius:_closeButton.height / 2];
    }
    return _closeButton;
}

- (void)onClickCloseAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [BNToolHelper caclLotsUselessNums];
}

@end
