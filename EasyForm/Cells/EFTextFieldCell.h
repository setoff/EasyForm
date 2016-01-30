//
//  EFTextFieldCell.h
//  Pods
//
//  Created by Ilya Sedov on 27/01/16.
//
//

#import <UIKit/UIKit.h>

@interface EFTextFieldCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;

/// If YES will close keyboard while return key pressed. YES by default.
@property (nonatomic, assign) BOOL resignOnReturn;

@property (nonatomic, copy) void (^onTextChanged)(NSString *text);

@property (nonatomic, copy) void (^onDoneEditing)();

@end
