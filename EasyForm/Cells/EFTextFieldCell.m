//
//  EFTextFieldCell.m
//  EasyForm
//
//  Created by Ilya Sedov on 27/01/16.
//
//

#import "EFTextFieldCell.h"

@implementation EFTextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.resignOnReturn = YES;
        [self buildViews];
        [self addActions];
    }
    return self;
}

- (void)buildViews {
    self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.textField];

    NSDictionary *views = NSDictionaryOfVariableBindings(_textField);
    [self.contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_textField]-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [self.contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_textField]-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
}

- (void)addActions {
    [self.textField addTarget:self
                       action:@selector(textChanged:)
             forControlEvents:UIControlEventEditingChanged];
    [self.textField addTarget:self
                       action:@selector(doneEditing:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)textChanged:(id)sender {
    if (self.onTextChanged) {
        self.onTextChanged(self.textField.text);
    }
}

- (void)doneEditing:(id)sender {
    if (self.resignOnReturn) {
        [sender resignFirstResponder];
    }

    if (self.onDoneEditing) {
        self.onDoneEditing();
    }
}


@end
