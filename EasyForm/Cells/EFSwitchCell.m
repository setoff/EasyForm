//
//  EFSwitchCell.m
//  Pods
//
//  Created by Ilya Sedov on 27/01/16.
//
//

#import "EFSwitchCell.h"

@implementation EFSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildViews];
        [self addActions];
    }
    return self;
}

- (void)buildViews {
    self.switchToggle = [[UISwitch alloc] initWithFrame:CGRectZero];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.switchToggle.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.switchToggle];
    [self.contentView addSubview:self.titleLabel];

    NSDictionary *views = NSDictionaryOfVariableBindings(_switchToggle, _titleLabel);
    [self.contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_titleLabel]-[_switchToggle]-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [self.contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_titleLabel]-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [self.contentView addConstraint:
     [NSLayoutConstraint constraintWithItem:_switchToggle
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.contentView
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0 constant:0.0]];
    [self.switchToggle setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                         forAxis:UILayoutConstraintAxisHorizontal];
    [self.switchToggle setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                       forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)addActions {
    [self.switchToggle addTarget:self
                          action:@selector(toggled:)
                forControlEvents:UIControlEventValueChanged];
}

- (void)toggled:(id)sender {
    if (self.onToggle) {
        self.onToggle(self.switchToggle.isOn);
    }
}

@end
