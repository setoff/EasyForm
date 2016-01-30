//
//  EFWideButtonCell.m
//  Pods
//
//  Created by Ilya Sedov on 27/01/16.
//
//

#import "EFWideButtonCell.h"

@interface EFWideButtonCell ()

@property (nonatomic, strong) NSNumber *vMargin;

@end

@implementation EFWideButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.vMargin = @4.0;
        [self buildViews];
        [self addActions];
    }
    return self;
}

- (void)buildViews {
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.button];
    NSDictionary *metrics = NSDictionaryOfVariableBindings(_vMargin);
    NSDictionary *views = NSDictionaryOfVariableBindings(_button);
    [self.contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_button]-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [self.contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(_vMargin)-[_button]-(_vMargin)-|"
                                             options:0
                                             metrics:metrics
                                               views:views]];
    [self.button setTitle:@"This is wide button" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.button.backgroundColor = [UIColor lightGrayColor];
}

- (void)addActions {
    [self.button addTarget:self
                    action:@selector(buttonTapped:)
          forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonTapped:(id)sender {
    if (self.onTap) {
        self.onTap();
    }
}

@end
