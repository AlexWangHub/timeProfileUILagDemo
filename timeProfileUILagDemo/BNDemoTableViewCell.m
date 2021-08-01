//
//  BNDemoTableViewCell.m
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import "BNDemoTableViewCell.h"
#import "UIView+Extend.h"
#import "BNBuildHelper.h"
#import "BNToolHelper.h"

#define BNDemoTableViewCellLeftRightMargin 32

@interface BNDemoTableViewCell ()

@property (nonatomic, strong) UIButton *contentBtn;

@end

@implementation BNDemoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.frame = CGRectMake(0, 0, self.contentView.width, 154);
        self.contentView.backgroundColor = [UIColor orangeColor];
        
        [self.contentView addSubview:self.contentBtn];
        
    }
    return self;
}

- (void)updateContentTitle:(NSString *)title {
    [self.contentBtn setTitle:title forState:UIControlStateNormal];
    [self.contentBtn sizeToFit];
    [self layoutUI];
}

- (void)layoutUI {
    self.contentBtn.top = (self.contentView.height - self.contentBtn.height) / 2;
}

- (UIButton *)contentBtn {
    if (!_contentBtn) {
        _contentBtn = [BNBuildHelper buildButtonWithFrame:CGRectMake(BNDemoTableViewCellLeftRightMargin, 0,self.contentView.width - 2 * BNDemoTableViewCellLeftRightMargin, 48) backgroundColor:[UIColor orangeColor] titleColor:[UIColor whiteColor] title:@"" target:nil action:nil cornerRadius:_contentBtn.height / 2];
    }
    return _contentBtn;
}

@end


